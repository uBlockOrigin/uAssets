#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e

# To be executed at the root of uAssetsCDN repo
#
# It's not being hosted at uAssetsCDN because that
# repo is also used as a website


# Keep only the most recent (5-day x 4-per-day) patches
OBSOLETE_PATCHES=( $(ls -1v patches/*.patch | head -n -20) )
for FILE in "${OBSOLETE_PATCHES[@]}"; do
    echo "Removing obsolete patch $FILE"
    git rm $FILE
done


# Revisit all patch files except the most recent one
PATCH_FILES=( $(ls -1v patches/*.patch | head -n -1) )

NEW_PATCH_FILE=$(mktemp)
DIFF_FILE=$(mktemp)

for PATCH_FILE in "${PATCH_FILES[@]}"; do

    # Extract tag from patch file name
    [[ ${PATCH_FILE} =~ ^patches/([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)\.patch$ ]] && \
        PREVIOUS_VERSION=${BASH_REMATCH[1]}

    # This will receive a clone of an old version of the current repo
    echo "Fetching repo at $PREVIOUS_VERSION version"
    OLD_REPO=$(mktemp -d)
    git clone -q --single-branch --branch $PREVIOUS_VERSION --depth=1 https://github.com/uBlockOrigin/uAssetsCDN.git "$OLD_REPO" 2>/dev/null

    > "$NEW_PATCH_FILE"

    FILTER_LISTS=( $(ls -1 filters/*.min.txt) $(ls -1 thirdparties/*) )
    for FILTER_LIST in "${FILTER_LISTS[@]}"; do

        if [ ! -f $OLD_REPO/$FILTER_LIST ]; then continue; fi

        # Patches are for filter lists supporting differential updates
        if [[ -z $(grep '^! Diff-Path: ' <(head $OLD_REPO/$FILTER_LIST)) ]]; then
            continue
        fi

        # Reference:
        # https://github.com/ameshkov/diffupdates

        # Extract patch name
        DIFF_NAME=$(grep -m 1 -oP '^! Diff-Name: \K.+' $OLD_REPO/$FILTER_LIST)

        # We need a patch name to generate a valid patch
        if [[ -z $DIFF_NAME ]]; then
            echo "Info: $FILTER_LIST was missing a patch name, skipping"
            continue
        fi

        # Compute the RCS diff between current version and new version
        diff -n $OLD_REPO/$FILTER_LIST $FILTER_LIST > "$DIFF_FILE" || true

        FILE_CHECKSUM=$(sha1sum $FILTER_LIST)
        FILE_CHECKSUM=${FILE_CHECKSUM:0:10}

        DIFF_LINE_COUNT=$(cat "$DIFF_FILE" | wc -l)

        # Patch header
        DIFF_HEAD="diff name:$DIFF_NAME lines:$DIFF_LINE_COUNT checksum:$FILE_CHECKSUM"
        echo "\tAdding diff: $DIFF_HEAD"
        echo "$DIFF_HEAD" >> "$NEW_PATCH_FILE"
        # Patch data
        cat "$DIFF_FILE" >> "$NEW_PATCH_FILE"

    done

    rm -rf "$OLD_REPO"

    # Stage changed patch file
    mv -f "$NEW_PATCH_FILE" "$PATCH_FILE"
    ls -l "$PATCH_FILE"
    echo "Info: Staging ${PATCH_FILE}"
    git add -u $PATCH_FILE

done

rm -f "$DIFF_FILE"
rm -f "$NEW_PATCH_FILE"
