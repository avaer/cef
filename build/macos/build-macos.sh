#!/bin/bash

# install_name_tool -id '@rpath/Chromium Embedded Framework.framework/Chromium Embedded Framework' node_modules/native-browser-deps/lib3/macos/Chromium\ Embedded\ Framework.framework/Chromium\ Embedded\ Framework

cmake .
make -j3
