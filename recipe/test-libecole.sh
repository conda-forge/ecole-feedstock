#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

cmake -B build -G Ninja -S examples/libecole
cmake --build build --parallel ${CPU_COUNT}
./build/branching
