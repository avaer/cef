#!/bin/bash

export PATH="/home/a/code/chromium_git/chromium/src/third_party/llvm-build/Release+Asserts/bin:$PATH"
cmake -DCMAKE_TOOLCHAIN_FILE=./toolchains
make -j2 VERBOSE=1
