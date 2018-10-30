#!/bin/bash

export GYP_DEFINES=target_arch=arm
export GN_DEFINES="is_official_build=true use_sysroot=true use_allocator=none symbol_level=1 arm_float_abi=hard"

