#!/usr/bin/env bash
#
# This script assumes you are on OS X with bash 4.x installed
# - you cloned the repo https://github.com/dhowe/uAssets
# - you cloned the repo https://github.com/dhowe/AdNauseam
# - the script is launched from ./dhowe/uAssets

die() { echo "$@" 1>&2 ; exit 1; }

if [ -z "${BASH_VERSINFO}" ] || [ -z "${BASH_VERSINFO[0]}" ] || [ ${BASH_VERSINFO[0]} -lt 4 ]; 
then 
  echo "Fatal: script requires Bash version >= 4"; 
  echo "You have ${BASH_VERSION}";
  exit 1; 
fi

hash md5 2>/dev/null || { echo >&2 "Fatal: script requires 'md5' but it's not installed.  Aborting."; exit 1; }
hash truncate 2>/dev/null || { echo >&2 "Fatal: scrip requires 'truncate' but it's not installed.  Aborting."; exit 1; }

# ok, we're ready with a proper bash, truncate, and md5sum

echo "*** Generating checksums.txt file..."

truncate -s 0 ./checksums/ublock0.txt 

echo "`md5 -q ../AdNauseam/assets/ublock/filter-lists.json` assets/ublock/filter-lists.json"  >> ./checksums/ublock0.txt

filters=(
    './filters/badware.txt'
    './filters/experimental.txt'
    './filters/filters.txt'
    './filters/privacy.txt'
    './filters/resources.txt'
    './filters/unbreak.txt'
    './filters/adnauseam.txt'
)
for repoPath in "${filters[@]}"; do
    repoPath2=`echo $repoPath | sed 's/\.\/filters/assets\/ublock/'`
    echo `md5 -q $repoPath` $repoPath2 >> ./checksums/ublock0.txt
done

thirdparties=(
    './thirdparties/easylist-downloads.adblockplus.org/easylist.txt'
    './thirdparties/easylist-downloads.adblockplus.org/easyprivacy.txt'
    './thirdparties/mirror1.malwaredomains.com/files/justdomains'
    #'./thirdparties/pgl.yoyo.org/as/serverlist'
    './thirdparties/publicsuffix.org/list/effective_tld_names.dat'
    './thirdparties/www.malwaredomainlist.com/hostslist/hosts.txt'
    './thirdparties/www.eff.org/files/effdntlist.txt'
)
for repoPath in "${thirdparties[@]}"; do
    repoPath2=`echo $repoPath | sed 's/\.\/thirdparties/assets\/thirdparties/'`
    echo `md5 -q $repoPath` $repoPath2 >> ./checksums/ublock0.txt
done

echo "*** Checksums updated."
cat ./checksums/ublock0.txt

