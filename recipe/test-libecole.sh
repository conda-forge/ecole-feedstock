#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# For using C++17 symbols on Apple before they are officially released
if [ "${MACOSX_DEPLOYMENT_TARGET-}" ]; then
	export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

cmake -B build -G Ninja -S examples/libecole
cmake --build build --parallel ${CPU_COUNT}
./build/branching
