#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/common.sh"
source "$(dirname "$0")/common_linux.sh"
source "$(dirname "$0")/common_odin.sh"

run rm -rf "$LINUX_OUT_DIR"
run mkdir -p "$LINUX_OUT_DIR"

ODIN_FLAGS+=(-target:linux_amd64)

run "$ODIN" build "$SRC_DIR" "${ODIN_FLAGS[@]}" -out:"$LINUX_OUT_DIR/$LINUX_BINARY"

run cp -r "$ASSETS_DIR" "$LINUX_OUT_DIR/$ASSETS_DIR"

if [[ "${1-}" == -r ]]; then
    "$(dirname "$0")/run_linux.sh"
fi
