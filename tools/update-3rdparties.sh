#!/usr/bin/env bash
#
# This script assumes a linux environment

TEMPFILE=/tmp/uAsset

if [ -z "${BASH_VERSINFO}" ] || [ -z "${BASH_VERSINFO[0]}" ] || [ ${BASH_VERSINFO[0]} -lt 4 ];
then
  echo "Fatal: script requires Bash version >= 4";
  echo "You have ${BASH_VERSION}";
  exit 1;
fi
hash wget 2>/dev/null || { echo >&2 "Fatal: script requires 'wget' but it's not installed.  Aborting."; exit 1; }
hash cmp 2>/dev/null || { echo >&2 "Fatal: scrip requires 'cmp' but it's not installed.  Aborting."; exit 1; }

echo "*** uAssets: updating remote assets..."

declare -A assets
assets=(
    ['thirdparties/easylist-downloads.adblockplus.org/easylist.txt']='https://easylist.to/easylist/easylist.txt'
    ['thirdparties/easylist-downloads.adblockplus.org/easyprivacy.txt']='https://easylist.to/easylist/easyprivacy.txt'
    ['thirdparties/mirror1.malwaredomains.com/files/justdomains']='http://mirror1.malwaredomains.com/files/justdomains'
    #['thirdparties/pgl.yoyo.org/as/serverlist']='https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=1&startdate%5Bday%5D=&startdate%5Bmonth%5D=&startdate%5Byear%5D=&mimetype=plaintext'
    ['thirdparties/publicsuffix.org/list/effective_tld_names.dat']='https://publicsuffix.org/list/effective_tld_names.dat'
    ['thirdparties/www.malwaredomainlist.com/hostslist/hosts.txt']='https://www.malwaredomainlist.com/hostslist/hosts.txt'
    ['thirdparties/www.eff.org/files/effdntlist.txt']='https://www.eff.org/files/effdntlist.txt'
)

for i in "${!assets[@]}"; do
    localURL="$i"
    remoteURL="${assets[$i]}"
    echo "*** Downloading ${remoteURL}"
    if wget -q -T 30 -O $TEMPFILE -- $remoteURL; then
        if [ -s $TEMPFILE ]; then
            if ! cmp -s $TEMPFILE $localURL; then
                echo "    New version found: ${localURL}"
                if [ "$1" != "dry" ]; then
                    mv $TEMPFILE $localURL
                fi
            fi
        fi
    fi
done

bash ./tools/update-ublock0.sh
