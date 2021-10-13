#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

mkdir -p "${PREFIX}"  # Make cp predictable
cp -a ecole-install/* "${PREFIX}"
