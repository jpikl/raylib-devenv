#!/usr/bin/env bash

set -euo pipefail

SCRIPTS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

source "$SCRIPTS_DIR/config_base.sh"
source "$SCRIPTS_DIR/config_app.sh"
source "$SCRIPTS_DIR/config_dirs.sh"
source "$SCRIPTS_DIR/config_build.sh"
source "$SCRIPTS_DIR/config_odin.sh"
source "$SCRIPTS_DIR/config_linux.sh"

run rm -rf "$LINUX_OUT_DIR"
run mkdir -p "$LINUX_OUT_DIR"

# TODO link src

ODIN_FLAGS+=(
    -target:linux_amd64
    -define:IS_LINUX=true
)

run "$ODIN" build "$ODIN_MAIN" -file "${ODIN_FLAGS[@]}" -out:"$LINUX_OUT_DIR/$LINUX_BINARY"

if [[ -d "$ASSETS_DIR" ]]; then
    # Create cheap symlink instead of copy
    run mkdir -p "$(dirname "$LINUX_OUT_DIR/$ASSETS_DIR_RELATIVE")"
    run ln -Ts "$(realpath --relative-to="$LINUX_OUT_DIR" "$ASSETS_DIR")" "$LINUX_OUT_DIR/$ASSETS_DIR_RELATIVE"
else
    skip "No ASSETS_DIR='$ASSETS_DIR' to link"
fi

if [[ "${1-}" == -r ]]; then
    "$SCRIPTS_DIR/run_linux.sh"
fi
