#!/usr/bin/env bash
#
# This script assumes a linux environment

TEMPFILE=(mktemp)

echo "*** uAssets: Assembling EasyList lists"
TMPDIR=$(mktemp -d)
mkdir -p $TMPDIR/easylist
git clone --depth 1 https://github.com/easylist/easylist.git $TMPDIR/easylist

echo "*** uAssets: Assembling easylist.txt"
node ./tools/easylist/make-easylist.js in=$TMPDIR/easylist/easylist.template out=thirdparties/easylist-downloads.adblockplus.org/easylist.txt

echo "*** uAssets: Assembling easyprivacy.txt"
node ./tools/easylist/make-easylist.js in=$TMPDIR/easylist/easyprivacy.template out=thirdparties/easylist-downloads.adblockplus.org/easyprivacy.txt

rm -rf $TMPDIR
