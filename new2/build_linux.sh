#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

source "$ROOT_DIR/common.sh"
source "$ROOT_DIR/common_build.sh"
source "$ROOT_DIR/common_linux.sh"
source "$ROOT_DIR/common_odin.sh"

run rm -rf "$LINUX_OUT_DIR"
run mkdir -p "$LINUX_OUT_DIR"

ODIN_FLAGS+=(-target:linux_amd64)

run "$ODIN" build "$SRC_DIR" "${ODIN_FLAGS[@]}" -out:"$LINUX_OUT_DIR/$LINUX_BINARY"

if [[ -d "$ASSETS_DIR" ]]; then
    run mkdir -p "$LINUX_OUT_DIR/$ASSETS_DIR"
    run cp -rT "$ASSETS_DIR" "$LINUX_OUT_DIR/$ASSETS_DIR"
else
    skip "No ASSETS_DIR='$ASSETS_DIR' to copy"
fi

if [[ "${1-}" == -r ]]; then
    "$ROOT_DIR/run_linux.sh"
fi
