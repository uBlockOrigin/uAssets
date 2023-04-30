#!/usr/bin/env bash
#
# This script assumes a linux environment

echo "*** uAssets: Assembling filters/filters.txt"
node ./tools/easylist/make-easylist.js in=templates/ublock-filters.template out=filters/filters.min.txt minify=1

echo "*** uAssets: Assembling filters/privacy.txt"
node ./tools/easylist/make-easylist.js in=templates/ublock-privacy.template out=filters/privacy.min.txt minify=1
