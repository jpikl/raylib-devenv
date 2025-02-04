#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

"$ROOT_DIR/run_image.sh" windows build_windows.sh

if [[ "${1-}" == -r ]]; then
    "$ROOT_DIR/run_windows.sh"
fi
