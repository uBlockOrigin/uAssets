#!/usr/bin/env bash

echo "*** uAssets: Assembling filters/filters.txt"
node ./tools/make-easylist.mjs in=templates/ublock-filters.template out=filters/filters.min.txt minify=1

echo "*** uAssets: Assembling filters/quick-fixes.txt"
node ./tools/make-easylist.mjs in=templates/ublock-quick-fixes.template out=filters/quick-fixes.min.txt minify=1

echo "*** uAssets: Assembling filters/privacy.txt"
node ./tools/make-easylist.mjs in=templates/ublock-privacy.template out=filters/privacy.min.txt minify=1

echo "*** uAssets: Assembling filters/unbreak.txt"
node ./tools/make-easylist.mjs in=templates/ublock-unbreak.template out=filters/unbreak.min.txt minify=1

echo "*** uAssets: Assembling filters/badware.txt"
node ./tools/make-easylist.mjs in=templates/ublock-badware.template out=filters/badware.min.txt minify=1

echo "*** uAssets: Assembling filters/annoyances.txt"
node ./tools/make-easylist.mjs in=templates/ublock-annoyances.template out=filters/annoyances.min.txt minify=1
