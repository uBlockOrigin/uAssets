#!/usr/bin/env bash
#
# This script assumes a linux environment

TEMPFILE=(mktemp)

echo "*** uAssets: updating remote assets..."

declare -A assets
assets=(
    ['thirdparties/easylist-downloads.adblockplus.org/easylist.txt']='https://easylist.to/easylist/easylist.txt'
    ['thirdparties/easylist-downloads.adblockplus.org/easyprivacy.txt']='https://easylist.to/easylist/easyprivacy.txt'
    ['thirdparties/pgl.yoyo.org/as/serverlist']='https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=1&startdate%5Bday%5D=&startdate%5Bmonth%5D=&startdate%5Byear%5D=&mimetype=plaintext'
    ['thirdparties/publicsuffix.org/list/effective_tld_names.dat']='https://publicsuffix.org/list/public_suffix_list.dat'
    ['thirdparties/urlhaus-filter/urlhaus-filter-online.txt']='https://curben.gitlab.io/urlhaus-filter/urlhaus-filter-online.txt'
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
