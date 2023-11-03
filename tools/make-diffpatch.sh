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

PREVIOUS_VERSION=$(<version)
PREVIOUS_PATCH_FILE="patches/${PREVIOUS_VERSION}.patch"
> "${PREVIOUS_PATCH_FILE}"

NEXT_PATCH_FILE="patches/${VERSION}.patch"

# Temporary file to receive the RCS patch data
DIFF=$(mktemp)

FILES=( $(git diff --name-only) )
for FILE in "${FILES[@]}"; do

    # Reference:
    # https://github.com/ameshkov/diffupdates

    if [[ -n $(grep '^! Version: ' <(head $FILE)) ]]; then
        sed -Ei "1,10s;^! Version: .+$;! Version: $VERSION;" $FILE
    fi

    # Patches are for filter lists supporting differential updates
    if [[ -n $(grep '^! Diff-Path: ' <(head $FILE)) ]]; then

        # Extract diff name from `! Diff-Path:` field
        DIFF_NAME=$(grep -m 1 -oP '^! Diff-Path: [^#]+#?\K.*' $FILE)
        # Fall back to `! Diff-Name:` field if no name found
        # Remove once `! Diff-Name:` is no longer needed after transition
        if [[ -z $DIFF_NAME ]]; then
            DIFF_NAME=$(grep -m 1 -oP '^! Diff-Name: \K.+' $FILE)
        fi
        echo "Info: Diff name for ${FILE} is ${DIFF_NAME}"

        # We need a patch name to generate a valid patch
        if [[ -n $DIFF_NAME ]]; then

            # Compute relative patch path
            PATCH_PATH=$(realpath --relative-to=$(dirname $FILE) $NEXT_PATCH_FILE)

            # Fill in patch path to next version (do not clobber hash portion)
            sed -Ei "1,10s;^! Diff-Path: [^#]+(#.+)?$;! Diff-Path: $PATCH_PATH\1;" $FILE

            # Compute the RCS diff between current version and new version
            git show HEAD:$FILE | diff -n - $FILE > $DIFF || true

            FILE_CHECKSUM=$(sha1sum $FILE)
            FILE_CHECKSUM=${FILE_CHECKSUM:0:10}

            DIFF_LINES=$(wc -l < $DIFF)
            echo "Info: Computed patch for ${FILE} has ${DIFF_LINES} lines"

            # Populate output file with patch information
            echo "Info: Adding patch data of ${FILE} to ${PREVIOUS_PATCH_FILE}"
            echo "diff name:$DIFF_NAME lines:$DIFF_LINES checksum:$FILE_CHECKSUM" >> $PREVIOUS_PATCH_FILE
            cat $DIFF >> $PREVIOUS_PATCH_FILE

        else

            echo "Error: Diff name not found, skipping"

        fi
    fi

    # Stage changed file
    echo "Info: Staging ${FILE}"
    git add -u $FILE

done

echo "Info: Staging ${PREVIOUS_PATCH_FILE}"
git add $PREVIOUS_PATCH_FILE

echo -n "$VERSION" > version
git add version

rm -f $DIFF
