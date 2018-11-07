#!/bin/bash

# export PATH="/home/a/code/chromium_git/chromium/src/third_party/llvm-build/Release+Asserts/bin:$PATH"
# cmake -DCMAKE_TOOLCHAIN_FILE=./toolchains
# make -j2 VERBOSE=1

set -e

export MLSDK=${MLSDK:-/mnt/c/Users/avaer/MagicLeap/mlsdk/v0.16.0}

# pushd ..
# npm install native-video-deps
# popd

if [ ! -d magicleap-js ]; then
  git clone https://github.com/webmixedreality/magicleap-js
else
  pushd magicleap-js
  git pull --rebase
  popd
fi

./magicleap-js/hack-toolchain.js

cmake -D CMAKE_TOOLCHAIN_FILE=.\\toolchains -D LUMIN=1 .
# make clean
make -j4