#!/usr/bin/env bash

TEMPFILE=$(mktemp)

echo "*** uAssets: Updating remote assets..."

declare -A assets=(
    ['thirdparties/pgl.yoyo.org/as/serverlist']='https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=1&startdate%5Bday%5D=&startdate%5Bmonth%5D=&startdate%5Byear%5D=&mimetype=plaintext'
    ['thirdparties/publicsuffix.org/list/effective_tld_names.dat']='https://publicsuffix.org/list/public_suffix_list.dat'
    ['thirdparties/urlhaus-filter/urlhaus-filter-online.txt']='https://malware-filter.gitlab.io/urlhaus-filter/urlhaus-filter-online.txt'
)

for localURL in "${!assets[@]}"; do
    remoteURL="${assets[$localURL]}"
    echo "*** Downloading ${remoteURL}"
    if wget -q -T 30 -O "$TEMPFILE" -- "$remoteURL"; then
        if [ -s "$TEMPFILE" ]; then
            if ! cmp -s "$TEMPFILE" "$localURL"; then
                echo "New version found: ${localURL}"
                if [ "$1" != "dry" ]; then
                    mv "$TEMPFILE" "$localURL"
                fi
            fi
        fi
    fi
done
