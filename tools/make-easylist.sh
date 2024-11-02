#!/usr/bin/env bash

echo "*** uAssets: Assembling EasyList lists"

TMPDIR=$(mktemp -d)
mkdir -p "$TMPDIR/easylist"
git clone --depth 1 https://github.com/easylist/easylist.git "$TMPDIR/easylist"
cp -R templates/easy*.template "$TMPDIR/easylist/"

declare -A filters=(
    ["easylist.txt"]="easylist.template"
    ["easyprivacy.txt"]="easyprivacy.template"
    ["easylist-annoyances.txt"]="easylist-annoyances.template"
    ["easylist-cookies.txt"]="easylist-cookies.template"
    ["easylist-social.txt"]="easylist-social.template"
    ["easylist-newsletters.txt"]="easylist-newsletters.template"
    ["easylist-notifications.txt"]="easylist-notifications.template"
    ["easylist-chat.txt"]="easylist-chat.template"
)

for filter in "${!filters[@]}"; do
    echo "*** uAssets: Assembling $filter"
    node ./tools/make-easylist.mjs dir="$TMPDIR/easylist" in="${filters[$filter]}" out="thirdparties/easylist/$filter"
done

rm -rf "$TMPDIR"
