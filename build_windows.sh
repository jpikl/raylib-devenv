#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

source "$ROOT_DIR/common.sh"
source "$ROOT_DIR/config_app.sh"
source "$ROOT_DIR/common_build.sh"
source "$ROOT_DIR/config_odin.sh"
source "$ROOT_DIR/common_windows.sh"

assert_var_is_dir SRC_DIR

run rm -rf "$WINDOWS_OUT_DIR"
run mkdir -p "$WINDOWS_OUT_DIR"

ODIN_FLAGS+=(
    -target:windows_amd64
    -build-mode:obj
    -define:IS_WINDOWS=true
)

LINK_FLAGS+=(
    /libpath:"$XWIN_HOME/crt/lib/x86_64"
    /libpath:"$XWIN_HOME/sdk/lib/ucrt/x86_64"
    /libpath:"$XWIN_HOME/sdk/lib/um/x86_64"
    /libpath:"$ODIN_ROOT/vendor/raylib/windows"
    # Should match libs from $ODIN_ROOT/vendor/raylib/raylib.odin
    /nodefaultlib:libcmt
    user32.lib
    gdi32.lib
    shell32.lib
    winmm.lib
    raylib.lib
    raygui.lib
)

run "$ODIN" build "$SRC_DIR" "${ODIN_FLAGS[@]}" -out:"$WINDOWS_OUT_DIR/$APP_CODE.obj"

run lld-link "$WINDOWS_OUT_DIR/$APP_CODE.obj" "${LINK_FLAGS[@]}" /out:"$WINDOWS_OUT_DIR/$WINDOWS_BINARY"

if [[ -d "$ASSETS_DIR" ]]; then
    # Create cheap symlink instead of copy
    run mkdir -p "$WINDOWS_OUT_DIR/$(dirname "$ASSETS_DIR")"
    run ln -Ts "$PWD/$ASSETS_DIR" "$WINDOWS_OUT_DIR/$ASSETS_DIR"
else
    skip "No ASSETS_DIR='$ASSETS_DIR' to link"
fi

if [[ "${1-}" == -r ]]; then
    "$ROOT_DIR/run_windows.sh"
fi
