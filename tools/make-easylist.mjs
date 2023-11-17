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

// jshint node:true, esversion:9

'use strict';

/******************************************************************************/

import fs from 'fs/promises';
import path from 'path';
import process from 'process';

/******************************************************************************/

const expandedParts = new Set();

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
            value = arg.slice(pos+1);
        }
        args.set(name, value);
    }
    return args;
})();

/******************************************************************************/

function expandTemplate(wd, parts) {
    const out = [];
    const reInclude = /^%include +(.+):(.+)%\s+/gm;
    const trim = text => trimSublist(text);
    for ( const part of parts ) {
        if ( typeof part !== 'string' ) {
            out.push(part);
            continue;
        }
        let lastIndex = 0;
        for (;;) {
            const match = reInclude.exec(part);
            if ( match === null ) { break; }
            out.push(part.slice(lastIndex, match.index).trim());
            const repo = match[1].trim();
            const fpath = `${match[2].trim()}`;
            if ( expandedParts.has(fpath) === false ) {
                console.info(`  Inserting ${fpath}`);
                out.push(
                    out.push({ file: `${fpath}` }),
                    `! *** ${repo}:${fpath} ***`,
                    fs.readFile(`${wd}/${fpath}`, { encoding: 'utf8' })
                        .then(text => fpath.includes('header') ? text : trim(text)),
                );
                expandedParts.add(fpath);
            }
            lastIndex = reInclude.lastIndex;
        }
        out.push(part.slice(lastIndex).trim());
    }
    return out;
}

/******************************************************************************/

function expandIncludeDirectives(wd, parts) {
    const out = [];
    const reInclude = /^!#include (.+)\s*/gm;
    const trim = text => trimSublist(text);
    let parentPath = '';
    for ( const part of parts ) {
        if ( typeof part !== 'string' ) {
            if ( typeof part === 'object' && part.file !== undefined ) {
                parentPath = part.file;
            }
            out.push(part);
            continue;
        }
        let lastIndex = 0;
        for (;;) {
            const match = reInclude.exec(part);
            if ( match === null ) { break; }
            out.push(part.slice(lastIndex, match.index).trim());
            const fpath = `${path.dirname(parentPath)}/${match[1].trim()}`;
            if ( expandedParts.has(fpath) === false ) {
                console.info(`  Inserting ${fpath}`);
                out.push(
                    { file: fpath },
                    `! *** ${fpath} ***`,
                    fs.readFile(`${wd}/${fpath}`, { encoding: 'utf8' })
                        .then(text => fpath.includes('header') ? text : trim(text)),
                );
                expandedParts.add(fpath);
            }
            lastIndex = reInclude.lastIndex;
        }
        out.push(part.slice(lastIndex).trim());
    }
    return out;
}

/******************************************************************************/

function trimSublist(text) {
    // Remove empty comment lines
    text = text.replace(/^!\s*$(?:\r\n|\n)/gm, '');
    // Remove sublist header information: the importing list will provide its
    // own header.
    text = text.trim().replace(/^(?:!\s+[^\r\n]+?(?:\r\n|\n))+/s, '');
    return text;
}

/******************************************************************************/

function minify(text) {
    // remove issue-related comments
    text = text.replace(/^! https:\/\/.*?[\n\r]+/gm, '');
    // remove empty lines
    text = text.replace(/^[\n\r]+/gm, '');
    // convert potentially present Windows-style newlines
    text = text.replace(/\r\n/g, '\n');
    return text;
}

/******************************************************************************/

function assemble(parts) {
    const out = [];
    for ( const part of parts ) {
        if ( typeof part !== 'string' ) { continue; }
        out.push(part);
    }
    return out.join('\n').trim() + '\n';
}

/******************************************************************************/

async function main() {
    const workingDir = commandLineArgs.get('dir') || '.';
    const inFile = commandLineArgs.get('in');
    if ( typeof inFile !== 'string' || inFile === '' ) {
        process.exit(1);
    }
    const outFile = commandLineArgs.get('out');
    if ( typeof outFile !== 'string' || outFile === '' ) {
        process.exit(1);
    }

    console.info(`  Using template at ${inFile}`);

    const inText = fs.readFile(`${workingDir}/${inFile}`, { encoding: 'utf8' });

    let parts = [ inText ];
    do {
        parts = await Promise.all(parts);
        parts = expandTemplate(workingDir, parts);
    } while ( parts.some(v => v instanceof Promise) );

    do {
        parts = await Promise.all(parts);
        parts = expandIncludeDirectives(workingDir, parts);
    } while ( parts.some(v => v instanceof Promise));

    let afterText = assemble(parts);

    if ( commandLineArgs.get('minify') !== undefined ) {
        afterText = minify(afterText);
    }

    console.info(`  Creating ${outFile}`);

    fs.writeFile(outFile, afterText);
}

main();
