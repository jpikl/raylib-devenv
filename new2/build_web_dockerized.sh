#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

"$ROOT_DIR/run_image.sh" web /mnt/scripts/build_web.sh

if [[ "${1-}" == -r ]]; then
    "$ROOT_DIR/run_web.sh"
fi
