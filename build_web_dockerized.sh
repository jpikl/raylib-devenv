#!/usr/bin/env bash

set -euo pipefail

SCRIPTS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
readonly SCRIPTS_DIR=$SCRIPTS_DIR

"$SCRIPTS_DIR/run_image.sh" web build_web.sh

if [[ "${1-}" == -r ]]; then
    "$SCRIPTS_DIR/run_web.sh"
fi
