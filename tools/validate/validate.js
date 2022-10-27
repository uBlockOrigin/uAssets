/*******************************************************************************

    uBlock Origin - a browser extension to block requests.
    Copyright (C) 2022-present Raymond Hill

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see {http://www.gnu.org/licenses/}.

    Home: https://github.com/gorhill/uBlock
*/

// jshint node:true, esversion:8, laxbreak:true

'use strict';

/******************************************************************************/

import fs from 'fs/promises';
import https from 'https';
import path from 'path';
import process from 'process';

import { StaticFilteringParser } from './uBlock/src/js/static-filtering-parser.js';
import { LineIterator } from './uBlock/src/js/text-utils.js';

import config from './config.js';

/******************************************************************************/

const commandLineArgs = (( ) => {
    const args = new Map();
    let name, value;
    for ( const arg of process.argv.slice(2) ) {
        const pos = arg.indexOf('=');
        if ( pos === -1 ) {
            name = arg;
            value = '';
        } else {
            name = arg.slice(0, pos);
            value = arg.slice(pos+1).trim();
        }
        args.set(name, value);
    }
    return args;
})();

/******************************************************************************/

const stdOutput = [];

const log = (text, silent = false) => {
    stdOutput.push(text);
    if ( silent === false ) {
        console.log(text);
    }
};

/******************************************************************************/

const jsonSetMapReplacer = (k, v) => {
    if ( v instanceof Set || v instanceof Map ) {
        if ( v.size === 0 ) { return; }
        return Array.from(v);
    }
    return v;
};

/******************************************************************************/

const writeFile = async (fname, data) => {
    const dir = path.dirname(fname);
    await fs.mkdir(dir, { recursive: true });
    const promise = fs.writeFile(fname, data);
    writeOps.push(promise);
    return promise;
};
const writeOps = [];

/******************************************************************************/

function sleep(ms) {
    return new Promise(resolve => {
        setTimeout(( ) => { resolve(); }, ms);
    });
}

/******************************************************************************/

// https://developers.cloudflare.com/1.1.1.1/encryption/dns-over-https/make-api-requests/dns-json/

async function validateHostnameWithQuery(url) {
    return new Promise((resolve, reject) => {
        const options = {
            headers: {
                accept: 'application/dns-json',
            }
        };
        https.get(url, options, response => {
            const data = [];
            response.on('data', chunk => {
                data.push(chunk.toString());
            });
            response.on('end', ( ) => {
                let result;
                try {
                    result = JSON.parse(data.join(''));
                } catch(ex) {
                }
                resolve(result);
            });
        }).on('error', error => {
            resolve();
        });
    });
}

async function validateHostname(hn) {
    await sleep(config.throttle);
    for ( const dnsQuery of config.dnsQueries ) {
        const url = dnsQuery.replace('${hn}', hn);
        const result = await validateHostnameWithQuery(url);
        if ( result !== undefined && result.Status !== 2 ) { return result; }
    }
}

/******************************************************************************/

function parseHostnameList(parser, s, hostnames) {
    let beg = 0;
    let slen = s.length;
    while ( beg < slen ) {
        let end = s.indexOf('|', beg);
        if ( end === -1 ) { end = slen; }
        const hn = parser.normalizeHostnameValue(s.slice(beg, end));
        beg = end + 1;
        if ( hn === undefined ) { continue; }
        if ( hn.includes('*') ) { continue; }
        hostnames.push(hn);
    }
    return hostnames;
}

/******************************************************************************/

function processNet(parser) {
    const hostnames = [];
    if ( parser.patternIsPlainHostname() ) {
        hostnames.push(parser.getPattern());
    } else if ( parser.patternIsLeftHostnameAnchored() ) {
        const match = /^([^/?]+)/.exec(parser.getPattern());
        if (
            match !== null &&
            match[1].includes('*') === false &&
            match[1].startsWith('.') === false &&
            match[1].endsWith('.') === false
        ) {
            hostnames.push(match[0]);
        }
    }
    if ( parser.hasOptions() === false ) { return hostnames; }
    for ( const { id, val } of parser.netOptions() ) {
        if ( id !== parser.OPTTokenDomain ) { continue; }
        parseHostnameList(parser, val, hostnames);
    }
    return hostnames;
}

/******************************************************************************/

function processExt(parser) {
    const hostnames = [];
    if ( parser.hasOptions() === false ) { return hostnames; }
    for ( const { hn } of parser.extOptions() ) {
        if ( hn.includes('*') ) { continue; }
        hostnames.push(hn);
    }
    return hostnames;
}

/******************************************************************************/

// https://www.rfc-editor.org/rfc/rfc1035.html

function checkHostname(hn, result) {
    if ( result instanceof Object === false ) { return; }
    if ( result.Status === 1 ) { return `${hn}    format error`; }
    if ( result.Status === 2 ) { return `${hn}    dns server failure`; }
    if ( result.Status === 3 ) { return `${hn}    name error`; }
    if ( result.Status === 4 ) { return `${hn}    not implemented`; }
    if ( result.Status === 5 ) { return `${hn}    refused`; }
    if ( result.Answer === undefined ) { return; }
    for ( const entry of result.Answer ) {
        if ( entry.data === undefined ) { continue; }
        for ( const re of parkedDomainAuthorities ) {
            if ( re.test(entry.data) === false ) { continue; }
            return `${hn}    parked`;
        }
    }
}

const parkedDomainAuthorities = [
    /^traff-\d+\.hugedomains\.com\.?$/,
    /^\d+\.parkingcrew\.net\.?$/,
    /^ns\d\.centralnic\.net\.?(\s|$)/,
    /^ns\d\.pananames\.com\.?(\s|$)/,
];

/******************************************************************************/

function toProgressString(lineno, hn) {
    const parts = [];
    if ( lineno > 0 ) { parts.push(`${lineno}`); }
    if ( hn ) { parts.push(hn); }
    const s = parts.join('  ');
    process.stdout.write(`\r${s.padEnd(lastProgressStr.length)}\r`);
    lastProgressStr = s;
}

let lastProgressStr = '';

/******************************************************************************/

// TODO: resume from partial results

async function processList(parser, text, lineto, fpath) {
    
    const lineIter = new LineIterator(text);
    const lines = [];

    while ( lineIter.eot() === false ) {
        lines.push(lineIter.next());
    }

    if ( lineto === undefined ) {
        lineto = lines.length;
    }

    for ( let i = lines.length; i > 0; i-- ) {
        if ( i > lineto ) { continue; }
        toProgressString(i);

        let line = lines[i-1];

        parser.analyze(line);

        if ( parser.shouldIgnore() ) { continue; }

        let hostnames;
        if ( parser.category !== parser.CATStaticNetFilter ) {
            hostnames = processExt(parser);
        } else if ( parser.patternHasUnicode() === false || parser.toASCII() ) {
            hostnames = processNet(parser);
        }
        const badHostnames = [];
        for ( const hn of hostnames ) {
            if ( hn.endsWith('.onion') ) { continue; }
            if ( /^\d+\.\d+\.\d+\.\d+$/.test(hn) ) { continue; }
            let result = validatedHostnames.get(hn);
            if ( result === undefined ) {
                toProgressString(i, hn);
                result = await validateHostname(hn);
                validatedHostnames.set(hn, result);
            }
            const diagnostic = checkHostname(hn, result);
            if ( diagnostic === undefined ) { continue; }
            badHostnames.push(diagnostic);
        }
        if ( badHostnames.length !== 0 ) {
            toProgressString(0);
            const lineno = i;
            badHostnames.forEach(v => {
                log(`${lineno}  ${v}`);
            });
            writeFile(fpath, stdOutput.join('\n'));
        }
    }
    toProgressString(0);
}

const validatedHostnames = new Map();

/******************************************************************************/

async function main() {
    const infile = commandLineArgs.get('in');
    if ( infile === undefined || infile === '' ) { return; }
    const outdir = commandLineArgs.get('out');
    if ( outdir === undefined || outdir === '' ) { return; }

    const infileParts = path.parse(infile);
    const lineto = commandLineArgs.get('line') !== undefined
        ? parseInt(commandLineArgs.get('line'), 10)
        : undefined;

    const partialResultPath = `${outdir}/${infileParts.name}.results.partial.txt`;
    const parser = new StaticFilteringParser();

    const text = await fs.readFile(infile, { encoding: 'utf8' });
    await processList(parser, text, lineto, partialResultPath);

    writeFile(`${outdir}/${infileParts.name}.results.txt`, stdOutput.join('\n'));
    writeFile(`${outdir}/${infileParts.name}.dns.results.txt`, JSON.stringify(validatedHostnames, jsonSetMapReplacer, 1));

    fs.rm(partialResultPath);

    await Promise.all(writeOps);
}

main();

/******************************************************************************/
