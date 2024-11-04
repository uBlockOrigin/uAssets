#!/usr/bin/env bash
#
# This script assumes a linux environment

# https://stackoverflow.com/a/52526704
echo "*** Importing required uBO files"
mkdir -p build/validate
git clone --filter=blob:none --no-checkout https://github.com/gorhill/uBlock.git build/validate/uBlock
cd build/validate/uBlock
git sparse-checkout init --cone
git sparse-checkout set src/js src/lib
cd -
