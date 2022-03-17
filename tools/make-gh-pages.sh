#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e

DES=$(mktemp -d)
echo "*** Created temporary directory: $DES"

echo "*** Clone repo to $DES"
git clone --depth=1 https://github.com/uBlockOrigin/uAssets.git $DES

echo "*** Copying files from $DES/filters"
cp $DES/filters/*.txt .

if [[ -n $(git diff) ]]; then
  echo "*** Committing changes to gh-pages"
  git config user.email "rhill@raymondhill.net"
  git config user.name "Raymond Hill"
  git add -u
  git commit -m 'Update all lists'
  git push origin gh-pages
else
  echo "*** No changes to commit"
fi
