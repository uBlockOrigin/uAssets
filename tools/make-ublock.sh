#!/usr/bin/env bash
#
# This script assumes a linux environment

TEMPFILE=(mktemp)

echo "*** uAssets: Assembling filters/filters.txt"
node ./tools/easylist/make-easylist.js in=templates/ublock-filters.template out=filters/filters-all.txt

echo "*** uAssets: Assembling filters/privacy.txt"
node ./tools/easylist/make-easylist.js in=templates/ublock-privacy.template out=filters/privacy-all.txt
