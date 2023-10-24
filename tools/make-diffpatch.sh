#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e

# To be executed at the root of uAssetsCDN repo
#
# It's not being hosted at uAssetsCDN because that
# repo is also used as a website

VERSION=$1
if [[ -z $VERSION ]]; then
    echo "Error: No version provided, aborting"
    exit 1
fi

PREVIOUS_VERSION=$(git describe --tags --abbrev=0)
PREVIOUS_PATCH_FILE="patches/${PREVIOUS_VERSION}.patch"
: > "${PREVIOUS_PATCH_FILE}"

NEXT_PATCH_FILE="patches/${VERSION}.patch"

# Temporary file to receive the RCS patch data
PATCH=$(mktemp)

FILES=( $(git diff --name-only) )
for FILE in "${FILES[@]}"; do

    # Reference:
    # https://github.com/ameshkov/diffupdates

    # Skip if the only changes are the Diff-Path and/or Version fields
    if [[ -z $(git diff -I '^! (Diff-Path|Version): ' $FILE) ]]; then
        echo "Info: No change detected in $FILE, skipping"
        continue
    fi

    if [[ -n $(grep '^! Version: ' <(head $FILE)) ]]; then
        sed -Ei "1,10s;^! Version: .+$;! Version: $VERSION;" $FILE
    fi

    if [[ -n $(grep '^! Diff-Path: ' <(head $FILE)) ]]; then

        # Extract patch name
        PATCH_NAME=$(grep -m 1 -oP '^! Diff-Name: \K.+' $FILE)
        echo "Info: Patch name for ${FILE} is ${PATCH_NAME}"

        # We need to patch name to generate a valid patch
        if [[ -n $PATCH_NAME ]]; then

            # Compute relative patch path
            PATCH_PATH=$(realpath --relative-to=$(dirname $FILE) $NEXT_PATCH_FILE)

            # Fill in patch path to next version
            sed -Ei "1,10s;^! Diff-Path: .+$;! Diff-Path: $PATCH_PATH;" $FILE

            # Compute the RCS diff between current version and new version
            git show HEAD:$FILE | diff -n - $FILE > $PATCH || true

            FILE_CHECKSUM=$(sha1sum $FILE)
            FILE_CHECKSUM=${FILE_CHECKSUM:0:10}

            PATCH_LINE_COUNT=$(wc -l < $PATCH)
            echo "Info: Computed patch for ${FILE} has ${PATCH_LINE_COUNT} lines"

            # Populate output file with patch information
            echo "Info: Adding patch data of ${FILE} to ${PREVIOUS_PATCH_FILE}"

            # Patch header
            echo "diff name:$PATCH_NAME lines:$PATCH_LINE_COUNT checksum:$FILE_CHECKSUM" >> $PREVIOUS_PATCH_FILE
            # Patch data
            cat $PATCH >> $PREVIOUS_PATCH_FILE

        else

            echo "Error: Patch name not found, skipping"

        fi
    fi

    # Stage changed file
    echo "Info: Staging ${FILE}"
    git add -u $FILE

done

echo "Info: Staging ${PREVIOUS_PATCH_FILE}"
git add $PREVIOUS_PATCH_FILE

rm -f $PATCH
