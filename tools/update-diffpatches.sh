#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e

# To be executed at the root of CDN repo
#
# It's not being hosted at CDN because that
# repo is also used as a website

REPO_DIR=$1
if [[ -z $REPO_DIR ]]; then
    echo "Error: repo directory is not provided, aborting"
    exit 1
fi

PATCHES_DIR=$2
if [[ -z $PATCHES_DIR ]]; then
    echo "Error: patches directory is not provided, aborting"
    exit 1
fi

FILTER_FILES=$3
if [[ -z $FILTER_FILES ]]; then
    echo "Error: filter lists are not provided, aborting"
    exit 1
fi
FILTER_FILES=( "$FILTER_FILES" )

# Keep only the most recent (5-day x 4-per-day) patches
OBSOLETE_PATCHES=( $(ls -1v "$PATCHES_DIR"/*.patch | head -n -20) )
for FILE in "${OBSOLETE_PATCHES[@]}"; do
    echo "Removing obsolete patch $FILE"
    git rm "$FILE"
done

PATCH_FILES=( $(ls -1v "$PATCHES_DIR"/*.patch | head -n -1) )

NEW_PATCH_FILE=$(mktemp)
DIFF_FILE=$(mktemp)

for PATCH_FILE in "${PATCH_FILES[@]}"; do

    # Extract tag from patch file name
    [[ ${PATCH_FILE} =~ ^$PATCHES_DIR/([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)\.patch$ ]] && \
        PREVIOUS_VERSION=${BASH_REMATCH[1]}

    # This will receive a clone of an old version of the current repo
    echo "Fetching repo at $PREVIOUS_VERSION version"
    OLD_REPO=$(mktemp -d)
    git clone -q --single-branch --branch "$PREVIOUS_VERSION" --depth=1 "https://github.com/$REPO_DIR.git" "$OLD_REPO" 2>/dev/null || true

    # Skip if version doesn't exist
    if [ -z "$(ls -A "$OLD_REPO" 2>/dev/null)" ]; then
        continue;
    fi

    : > "$NEW_PATCH_FILE"

    for FILTER_LIST in ${FILTER_FILES[@]}; do

        if [ ! -f "$OLD_REPO/$FILTER_LIST" ]; then continue; fi

        # Patches are for filter lists supporting differential updates
        if ! (head "$OLD_REPO/$FILTER_LIST" | grep -q '^! Diff-Path: '); then
            continue
        fi

        # Reference:
        # https://github.com/ameshkov/diffupdates

        # Extract diff name from `! Diff-Path:` field
        DIFF_NAME=$(grep -m 1 -oP '^! Diff-Path: [^#]+#?\K.*' "$FILTER_LIST")
        # Fall back to `! Diff-Name:` field if no name found
        # Remove once `! Diff-Name:` is no longer needed after transition
        if [[ -z $DIFF_NAME ]]; then
            DIFF_NAME=$(grep -m 1 -oP '^! Diff-Name: \K.+' "$FILTER_LIST")
        fi

        # We need a patch name to generate a valid patch
        if [[ -z $DIFF_NAME ]]; then
            echo "Info: $FILTER_LIST is missing a patch name, skipping"
            continue
        fi

        # Compute the RCS diff between current version and new version
        diff -n "$OLD_REPO/$FILTER_LIST" "$FILTER_LIST" > "$DIFF_FILE" || true

        FILE_CHECKSUM=$(sha1sum "$FILTER_LIST")
        FILE_CHECKSUM=${FILE_CHECKSUM:0:10}

        DIFF_LINE_COUNT=$(wc -l < "$DIFF_FILE")

        # Patch header
        DIFF_HEAD="diff name:$DIFF_NAME lines:$DIFF_LINE_COUNT checksum:$FILE_CHECKSUM"
        printf "\tAdding diff: %s\n" "$DIFF_HEAD"
        echo "$DIFF_HEAD" >> "$NEW_PATCH_FILE"
        # Patch data
        cat "$DIFF_FILE" >> "$NEW_PATCH_FILE"

    done

    rm -rf "$OLD_REPO"

    # Stage changed patch file
    mv -f "$NEW_PATCH_FILE" "$PATCH_FILE"
    ls -l "$PATCH_FILE"
    echo "Info: Staging ${PATCH_FILE}"
    git add -u "$PATCH_FILE"

done

rm -f "$DIFF_FILE"
rm -f "$NEW_PATCH_FILE"
