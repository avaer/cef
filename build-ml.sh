#!/bin/bash

export GYP_DEFINES=target_arch=arm64
export GN_DEFINES="is_official_build=true use_sysroot=true use_allocator=none symbol_level=1 arm_float_abi=hard"
export PATH=/home/a/code/depot_tools:$PATH

lib=./out/Release_GN_arm64/obj/cef/libcef2.a
rm -f $lib
ninja -C out/Release_GN_arm64 libcef2 cefsimple

lib=./out/Release_GN_arm64/obj/cef/libcef2.a; ar -t $lib | xargs ar rvs $lib.new && mv -v $lib.new $lib;

# ar r ./out/Release_GN_arm64/obj/cef/libcef_static.a ./out/Release_GN_arm64/obj/base/base/lazy_instance_helpers.o
# ar r ./out/Release_GN_arm64/obj/cef/libcef_static.a ./out/Release_GN_arm64/obj/base/base/ref_counted.o
aarch64-linux-gnu-objcopy --redefine-sym powf@GLIBC_2.17=powf ./obj/cef/libcef2.a
aarch64-linux-gnu-objcopy --redefine-sym logf@GLIBC_2.17=powf ./obj/cef/libcef2.a
aarch64-linux-gnu-objcopy --redefine-sym log2f@GLIBC_2.17=powf ./obj/cef/libcef2.a
aarch64-linux-gnu-objcopy --redefine-sym expf@GLIBC_2.17=powf ./obj/cef/libcef2.a
aarch64-linux-gnu-objcopy --redefine-sym exp2f@GLIBC_2.17=powf ./obj/cef/libcef2.a
aarch64-linux-gnu-objcopy --prefix-symbols=libcef_ ./obj/cef/libcef2.a

aarch64-linux-gnu-objcopy --redefine-syms=<(nm -go -fposix ./obj/cef/libcef2.a | grep -v ' U ' | grep -v ' ? ' | grep -v 'libcef_' | sed 's/^.*\[\(.*\)\]: \(.*\)/\1:\2/' |
 grep '\
^ssl_\|names.o\|^evp.o\|^evp_asn1.o\|^rsa_pmeth.o\|^aes_cbc.o\|^bcm.o\|^bn_mont.o\|^bn_exp.o\|^ec_lib.o\|^ec_curve.o\|^ec_cvt.o\|^ec_key.o\|^ec_oct.o\|\
^rsa_pk1.o\|^rsa_pss.o\|^ecp_mont.o\|^ecp_smpl.o\|^p8_pkey.o\|^pkcs8_x509.o\|^tls_method.o\|^logging.o\|^err.o\|^item-parallel-job.o\|^objects-printer.o\|\
^x509_vfy.o\|^x_x509.o\|^x509_lu.o\|^bio_mem.o\|^bss_mem.o\|\
:_ZN2v8\|:_ZNK2v8\|:_ZTVN2v8\
' | sed 's/^.*:\([^ ]*\).*$/\1/' | sort | uniq -u | sed 's/\(.*\)/\1 libcef_\1/') ./obj/cef/libcef2.a

nm -gC -fposix ./out/Release_GN_arm64/obj/cef/libcef2.a | grep -v ':$' | cut -d" " -f1 | sort | uniq -u | grep '^libcef_cef' | sed 's/^\(libcef_\)\(.*\)/\1\2 \2/' >replacements.txt
echo "libcef___dso_handle __dso_handle" >>replacements.txt
aarch64-linux-gnu-objcopy --redefine-syms=replacements.txt ./out/Release_GN_arm64/obj/cef/libcef2.a

ls=$(readelf -d ./out/Release_GN_arm64/libcef.so | grep Shared | sed 's/.*library: \[\(.*\)\]/\1/g')
for l in $ls
do
  l2=$(basename $(readlink -f $(find ./build/linux/debian_sid_arm64-sysroot -name "$l")));
  patchelf --replace-needed "$l" "$l2" ./out/Release_GN_arm64/libcef.so
done
