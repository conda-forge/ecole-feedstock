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


# Install the Python extension using the pre-install libecole
# Install locally and then use a script to move file, as we could not find a way to select
# the files in the outputs.files section of meta.yaml (dynamic Python version in path).
if [[ "${PKG_NAME}" == "ecole" ]]; then

	"${PYTHON}" -m pip install -vvv --no-deps --no-build-isolation --prefix ecole-install .

	mkdir -p "${PREFIX}"  # Make cp predictable
	cp -a ecole-install/* "${PREFIX}"
fi
