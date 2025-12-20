#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset


# For using C++17 symbols on Apple before they are officially released
if [[ "$target_platform" == osx-* ]]; then
	export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

# Install libecole (without extension) independently
if [[ "${PKG_NAME}" == "libecole" ]]; then

	cmake -B libecole-build -G Ninja \
		${CMAKE_ARGS} \
		-D CMAKE_BUILD_TYPE=Release \
		-D BUILD_SHARED_LIBS=ON \
		-D ECOLE_BUILD_PY_EXT=OFF
	cmake --build libecole-build --parallel ${CPU_COUNT}
	cmake --install libecole-build --prefix "${PREFIX}"

fi

# Install ecole Python binding, finding libecole already installed
if [[ "${PKG_NAME}" == "ecole" ]]; then

	export CMAKE_ARGS="${CMAKE_ARGS} -DECOLE_BUILD_PY_EXT=Yes -DECOLE_BUILD_LIB=No"
	"${PYTHON}" -m pip install -vvv --no-deps --no-build-isolation .

fi
