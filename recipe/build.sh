#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset


# For using C++17 symbols on Apple before they are officially released
if [[ "$target_platform" == osx-* ]]; then
	export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

# Remove install locations from Conda's CMAKE_ARGS. FIXME remove in 0.6.2
OLD_CMAKE_ARGS="${CMAKE_ARGS}"
CMAKE_ARGS=""
for arg in $OLD_CMAKE_ARGS; do
	if ! ( echo "${arg}" | grep -E -q -- '-D\s*CMAKE_INSTALL' ); then
		CMAKE_ARGS+=" ${arg}"
	fi
done

"${PYTHON}" -m pip install --no-deps --no-build-isolation .
