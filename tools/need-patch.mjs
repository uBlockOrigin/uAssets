/*******************************************************************************

    uBlock Origin - a browser extension to block requests.
    Copyright (C) 2023-present Raymond Hill

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

async function main() {
    const MS_PER_HOUR = 60 * 60 * 1000;
    const targetDelayInHours = parseInt(commandLineArgs.get('delay') || '5', 10);

    const hoursSinceEpoch = Math.floor(Date.now() / MS_PER_HOUR);
    if ( (hoursSinceEpoch % targetDelayInHours) === 0 ) {
        console.log('yes');
        process.exit(0);
    }

    const version = await fs.readFile('version', { encoding: 'utf8' });
    const match = /^(\d+)\.(\d+)\.(\d+)\.(\d+)$/.exec(version);
    if ( match === null ) {
        console.log('yes');
        process.exit(0);
    }

    const date = new Date();
    date.setUTCFullYear(
        parseInt(match[1], 10),
        parseInt(match[2], 10) - 1,
        parseInt(match[3], 10)
    );
    date.setUTCHours(0, parseInt(match[4], 10), 0, 0);
    const expiredTimeInHours = (Date.now() - date.getTime()) / MS_PER_HOUR;
    console.log(expiredTimeInHours >= targetDelayInHours ? 'yes' : 'no');
}

main();
