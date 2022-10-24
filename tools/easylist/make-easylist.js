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

// jshint node:true, esversion:8

'use strict';

/******************************************************************************/

import fs from 'fs/promises';
import path from 'path';
import process from 'process';

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

function expandIncludes(dirname, parts) {
    const out = [];
    const reInclude = /^%include +(.+):(.+)%\s+/gm;
    for ( const part of parts ) {
        let lastIndex = 0;
        for (;;) {
            const match = reInclude.exec(part);
            if ( match === null ) { break; }
            const repo = match[1].trim();
            const fpath = match[2].trim();
            out.push(
                part.slice(lastIndex, match.index).trim(),
                `! *** ${repo}:${fpath} ***`,
                fs.readFile(`${dirname}/${fpath}`, { encoding: 'utf8' })
                    .then(text => text.trim()),
            );
            lastIndex = reInclude.lastIndex;
        }
        out.push(part.slice(lastIndex).trim());
    }
    return out;
}

/******************************************************************************/

async function main() {
    const inFile = commandLineArgs.get('in');
    if ( typeof inFile !== 'string' || inFile === '' ) {
        process.exit(1);
    }
    const outFile = commandLineArgs.get('out');
    if ( typeof outFile !== 'string' || outFile === '' ) {
        process.exit(1);
    }

    const beforeText = await fs.readFile(outFile, { encoding: 'utf8' });
    const dirname = path.dirname(inFile);
    const inText = fs.readFile(inFile, { encoding: 'utf8' });

    let parts = [ inText ];
    do {
        parts = await Promise.all(parts);
        parts = expandIncludes(dirname, parts);
    } while ( parts.some(v => typeof v !== 'string'));

    const afterText = parts
        .filter(chunk => chunk.trim() !== '')
        .join('\n') + '\n';
    if ( afterText === beforeText ) { return; }

    fs.writeFile(outFile, afterText);
}

main();
