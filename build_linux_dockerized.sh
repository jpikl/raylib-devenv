#!/usr/bin/env bash

set -euo pipefail

SCRIPTS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
readonly SCRIPTS_DIR=$SCRIPTS_DIR

"$SCRIPTS_DIR/run_image.sh" linux build_linux.sh

if [[ "${1-}" == -r ]]; then
    "$SCRIPTS_DIR/run_linux.sh"
fi
