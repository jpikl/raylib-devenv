#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

"$ROOT_DIR/run_image.sh" android /mnt/scripts/build_android.sh

if [[ "${1-}" == -r ]]; then
    "$ROOT_DIR/run_android.sh"
fi
