#!/usr/bin/env bash

set -euo pipefail

SCRIPTS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

source "$SCRIPTS_DIR/config_base.sh"
source "$SCRIPTS_DIR/config_app.sh"
source "$SCRIPTS_DIR/config_dirs.sh"
source "$SCRIPTS_DIR/config_build.sh"
source "$SCRIPTS_DIR/config_odin.sh"
source "$SCRIPTS_DIR/config_windows.sh"
source "$SCRIPTS_DIR/config_windows_sdk.sh"

run rm -rf "$WINDOWS_OUT_DIR"
run mkdir -p "$WINDOWS_OUT_DIR"

ODIN_FLAGS+=(
    -target:windows_amd64
    -build-mode:obj
    -define:IS_WINDOWS=true
)

LINK_FLAGS=(
    /libpath:"$ODIN_ROOT/vendor/raylib/windows"
    # Should match libs from $ODIN_ROOT/vendor/raylib/raylib.odin
    /nodefaultlib:libcmt
    user32.lib
    gdi32.lib
    shell32.lib
    winmm.lib
    raylib.lib
)

if [[ "$RAYGUI" == true ]]; then
    LINK_FLAGS+=(raygui.lib)
fi

LIB_PATHS=(
    "$XWIN_HOME/crt/lib/x86_64"
    "$XWIN_HOME/sdk/lib/ucrt/x86_64"
    "$XWIN_HOME/sdk/lib/um/x86_64"
)

for LIB_PATH in "${LIB_PATHS[@]}"; do
    if [[ -d "$LIB_PATH" ]]; then
        LINK_FLAGS+=("/libpath:$LIB_PATH")
    else
        die "$LIB_PATH is not a directory"
    fi
done

run "$ODIN" build "$ODIN_MAIN" -file "${ODIN_FLAGS[@]}" -out:"$WINDOWS_OUT_DIR/$APP_CODE.obj"

run "$LINK" "$WINDOWS_OUT_DIR/$APP_CODE.obj" "${LINK_FLAGS[@]}" /out:"$WINDOWS_OUT_DIR/$WINDOWS_BINARY"

run rm "$WINDOWS_OUT_DIR/$APP_CODE.obj"

if [[ -d "$ASSETS_DIR" ]]; then
    # Create cheap symlink instead of copy
    run mkdir -p "$(dirname "$WINDOWS_OUT_DIR/$ASSETS_DIR_RELATIVE")"
    run ln -Ts "$(realpath --relative-to="$WINDOWS_OUT_DIR" "$ASSETS_DIR")" "$WINDOWS_OUT_DIR/$ASSETS_DIR_RELATIVE"
else
    skip "No ASSETS_DIR='$ASSETS_DIR' to link"
fi

if [[ "${1-}" == -r ]]; then
    "$SCRIPTS_DIR/run_windows.sh"
fi
