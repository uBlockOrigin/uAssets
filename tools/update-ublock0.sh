#!/usr/bin/env bash
#
# This script assumes...
# - you have a linux environment
# - you cloned the repo https://github.com/uBlockOrigin/uAssets
# - you cloned the repo https://github.com/gorhill/uBlock
# - the script is launched from ./uBlockOrigin/uAssets

echo "*** uBlock Origin: generating checksums.txt file..."

truncate -s 0 ./checksums/ublock0.txt

echo `md5sum ../ublock/assets/ublock/filter-lists.json | sed 's/\.\.\/ublock\///'` >> ./checksums/ublock0.txt

filters=(
    './filters/badware.txt'
    './filters/experimental.txt'
    './filters/filters.txt'
    './filters/privacy.txt'
    './filters/resources.txt'
    './filters/unbreak.txt'
)
for repoPath in "${filters[@]}"; do
    echo `md5sum $repoPath | sed 's/\.\/filters/assets\/ublock/'` >> ./checksums/ublock0.txt
done

thirdparties=(
    './thirdparties/easylist-downloads.adblockplus.org/easylist.txt'
    './thirdparties/easylist-downloads.adblockplus.org/easyprivacy.txt'
    './thirdparties/mirror1.malwaredomains.com/files/justdomains'
    './thirdparties/pgl.yoyo.org/as/serverlist'
    './thirdparties/publicsuffix.org/list/effective_tld_names.dat'
    './thirdparties/www.malwaredomainlist.com/hostslist/hosts.txt'
)
for repoPath in "${thirdparties[@]}"; do
    echo `md5sum $repoPath | sed 's/\.\/thirdparties/assets\/thirdparties/'` >> ./checksums/ublock0.txt
done

echo "*** uBlock Origin: checksums updated."

git status
