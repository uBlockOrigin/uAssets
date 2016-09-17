#!/usr/bin/env bash
#
# This script assumes...
# - you have a linux environment
# - you cloned the repo https://github.com/uBlockOrigin/uAssets
# - you cloned the repo https://github.com/gorhill/uBlock
# - the script is launched from ./uBlockOrigin/uAssets

echo "*** AdNauseam: generating checksums.txt file..."

truncate -s 0 ./checksums/ublock0.txt

echo "`md5sum -q ../AdNauseam/assets/ublock/filter-lists.json` assets/ublock/filter-lists.json"  >> ./checksums/ublock0.txt

filters=(
    './filters/badware.txt'
    './filters/experimental.txt'
    './filters/filters.txt'
    './filters/privacy.txt'
    './filters/resources.txt'
    './filters/unbreak.txt'
)
for repoPath in "${filters[@]}"; do
    repoPath2=`echo $repoPath | sed 's/\.\/filters/assets\/ublock/'`
    echo `md5sum -q $repoPath` $repoPath2 >> ./checksums/ublock0.txt
done

thirdparties=(
    './thirdparties/easylist-downloads.adblockplus.org/easylist.txt'
    './thirdparties/easylist-downloads.adblockplus.org/easyprivacy.txt'
    './thirdparties/mirror1.malwaredomains.com/files/justdomains'
    './thirdparties/pgl.yoyo.org/as/serverlist'
    './thirdparties/publicsuffix.org/list/effective_tld_names.dat'
    './thirdparties/www.malwaredomainlist.com/hostslist/hosts.txt'
    './thirdparties/www.eff.org/files/effdntlist.txt'
)
for repoPath in "${thirdparties[@]}"; do
    repoPath2=`echo $repoPath | sed 's/\.\/thirdparties/assets\/thirdparties/'`
    echo `md5sum -q $repoPath` $repoPath2 >> ./checksums/ublock0.txt
done

echo "*** AdNauseam checksums updated."
cat ./checksums/ublock0.txt
