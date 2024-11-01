#!/usr/bin/env bash

declare -A filters=(
    ["filters.txt"]="ublock-filters.template"
    ["quick-fixes.txt"]="ublock-quick-fixes.template"
    ["privacy.txt"]="ublock-privacy.template"
    ["unbreak.txt"]="ublock-unbreak.template"
    ["badware.txt"]="ublock-badware.template"
    ["annoyances.txt"]="ublock-annoyances.template"
)

for filter in "${!filters[@]}"; do
    echo "*** uAssets: Assembling filters/$filter"
    node ./tools/make-easylist.mjs in="templates/${filters[$filter]}" out="filters/$filter" minify=1
done
