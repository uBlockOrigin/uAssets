#!/usr/bin/env bash

echo "*** uAssets: Assembling EasyList lists"

TMPDIR=$(mktemp -d)
mkdir -p "$TMPDIR/easylist"
git clone --depth 1 https://github.com/easylist/easylist.git "$TMPDIR/easylist"
cp -R templates/easy*.template "$TMPDIR/easylist/"

declare -A files=(
    ["easylist.txt"]="easylist.template"
    ["easyprivacy.txt"]="easyprivacy.template"
    ["easylist-annoyances.txt"]="easylist-annoyances.template"
    ["easylist-cookies.txt"]="easylist-cookies.template"
    ["easylist-social.txt"]="easylist-social.template"
    ["easylist-newsletters.txt"]="easylist-newsletters.template"
    ["easylist-notifications.txt"]="easylist-notifications.template"
    ["easylist-chat.txt"]="easylist-chat.template"
)

for file in "${!files[@]}"; do
    echo "*** uAssets: Assembling $file"
    node ./tools/make-easylist.mjs dir="$TMPDIR/easylist" in="${files[$file]}" out="thirdparties/easylist/$file"
done

rm -rf "$TMPDIR"
