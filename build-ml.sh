#!/bin/bash

export GYP_DEFINES=target_arch=arm64
export GN_DEFINES="is_official_build=true use_sysroot=true use_allocator=none symbol_level=1 arm_float_abi=hard"
export PATH=/home/a/code/depot_tools:$PATH

lib=./out/Release_GN_arm64/obj/cef/libcef2.a
rm -f $lib
ninja -C out/Release_GN_arm64 libcef2 cefsimple

lib=./out/Release_GN_arm64/obj/cef/libcef2.a
ar -t $lib | xargs ar rvs $lib.new && mv -v $lib.new $lib

# ar r ./out/Release_GN_arm64/obj/cef/libcef_static.a ./out/Release_GN_arm64/obj/base/base/lazy_instance_helpers.o
# ar r ./out/Release_GN_arm64/obj/cef/libcef_static.a ./out/Release_GN_arm64/obj/base/base/ref_counted.o
aarch64-linux-gnu-objcopy --redefine-sym powf@GLIBC_2.17=powf ./out/Release_GN_arm64/obj/cef/libcef2.a
aarch64-linux-gnu-objcopy --redefine-sym logf@GLIBC_2.17=powf ./out/Release_GN_arm64/obj/cef/libcef2.a
aarch64-linux-gnu-objcopy --redefine-sym log2f@GLIBC_2.17=powf ./out/Release_GN_arm64/obj/cef/libcef2.a
aarch64-linux-gnu-objcopy --redefine-sym expf@GLIBC_2.17=powf ./out/Release_GN_arm64/obj/cef/libcef2.a
aarch64-linux-gnu-objcopy --redefine-sym exp2f@GLIBC_2.17=powf ./out/Release_GN_arm64/obj/cef/libcef2.a
aarch64-linux-gnu-objcopy --prefix-symbols=libcef_ ./out/Release_GN_arm64/obj/cef/libcef2.a
nm -gC -fposix ./out/Release_GN_arm64/obj/cef/libcef2.a | grep -v ':$' | cut -d" " -f1 | sort | uniq -u | grep '^libcef_cef' | sed 's/^\(libcef_\)\(.*\)/\1\2 \2/' >replacements.txt
echo "libcef___dso_handle __dso_handle" >>replacements.txt
aarch64-linux-gnu-objcopy --redefine-syms=replacements.txt ./out/Release_GN_arm64/obj/cef/libcef2.a
