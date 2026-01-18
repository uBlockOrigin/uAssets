#!/usr/bin/env bash
#
# This script assumes a linux environment

echo "*** uAssets: Assembling EasyList lists"
TMPDIR=$(mktemp -d)
mkdir -p $TMPDIR/easylist
git clone --depth 1 https://github.com/easylist/easylist.git $TMPDIR/easylist
cp -R templates/easy*.template $TMPDIR/easylist/

echo "*** uAssets: Assembling easylist.txt"
node ./tools/make-easylist.mjs dir=$TMPDIR/easylist in=easylist.template out=thirdparties/easylist/easylist.txt

echo "*** uAssets: Assembling easyprivacy.txt"
node ./tools/make-easylist.mjs dir=$TMPDIR/easylist in=easyprivacy.template out=thirdparties/easylist/easyprivacy.txt

echo "*** uAssets: Assembling easylist-annoyances.txt"
node ./tools/make-easylist.mjs dir=$TMPDIR/easylist in=easylist-annoyances.template out=thirdparties/easylist/easylist-annoyances.txt

echo "*** uAssets: Assembling easylist-cookies.txt"
node ./tools/make-easylist.mjs dir=$TMPDIR/easylist in=easylist-cookies.template out=thirdparties/easylist/easylist-cookies.txt

echo "*** uAssets: Assembling easylist-social.txt"
node ./tools/make-easylist.mjs dir=$TMPDIR/easylist in=easylist-social.template out=thirdparties/easylist/easylist-social.txt

echo "*** uAssets: Assembling easylist-newsletters.txt"
node ./tools/make-easylist.mjs dir=$TMPDIR/easylist in=easylist-newsletters.template out=thirdparties/easylist/easylist-newsletters.txt

echo "*** uAssets: Assembling easylist-notifications.txt"
node ./tools/make-easylist.mjs dir=$TMPDIR/easylist in=easylist-notifications.template out=thirdparties/easylist/easylist-notifications.txt

echo "*** uAssets: Assembling easylist-chat.txt"
node ./tools/make-easylist.mjs dir=$TMPDIR/easylist in=easylist-chat.template out=thirdparties/easylist/easylist-chat.txt

echo "*** uAssets: Assembling easylist-ai.txt"
node ./tools/make-easylist.mjs dir=$TMPDIR/easylist in=easylist-ai.template out=thirdparties/easylist/easylist-ai.txt

rm -rf $TMPDIR
