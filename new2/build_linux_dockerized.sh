#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

"$ROOT_DIR/run_image.sh" linux /mnt/scripts/build_linux.sh

if [[ "${1-}" == -r ]]; then
    "$ROOT_DIR/run_linux.sh"
fi
