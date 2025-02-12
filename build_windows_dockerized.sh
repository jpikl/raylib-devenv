#!/usr/bin/env bash

set -euo pipefail

SCRIPTS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

"$SCRIPTS_DIR/run_image.sh" windows build_windows.sh

if [[ "${1-}" == -r ]]; then
    "$SCRIPTS_DIR/run_windows.sh"
fi
