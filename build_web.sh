#!/usr/bin/env bash

set -euo pipefail

SCRIPTS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
readonly SCRIPTS_DIR=$SCRIPTS_DIR

source "$SCRIPTS_DIR/common.sh"
source "$SCRIPTS_DIR/config_app.sh"
source "$SCRIPTS_DIR/config_dirs.sh"
source "$SCRIPTS_DIR/config_build.sh"
source "$SCRIPTS_DIR/config_odin.sh"
source "$SCRIPTS_DIR/config_web.sh"
source "$SCRIPTS_DIR/config_web_sdk.sh"

assert_var_is_file WEB_SHELL

run rm -rf "$WEB_OUT_DIR"
run mkdir -p "$WEB_OUT_DIR"

ODIN_FLAGS+=(
    -target:freestanding_wasm32
    -build-mode:obj
    -define:TEMP_ALLOCATOR_SIZE="$WEB_TEMP_ALLOCATOR_SIZE"
    -define:IS_WEB=true

    # This env.o thing is the object file that contains things linked into the WASM binary.
    # You can see how RAYLIB_WASM_LIB is used inside <odin>/vendor/raylib/raylib.odin.
    #
    # We have to do it this way because the emscripten compiler (emcc) needs to be fed the precompiled raylib library file.
    # That stuff will end up in env.o, which our Odin code is instructed to link to.
    -define:RAYLIB_WASM_LIB=env.o
    -define:RAYGUI_WASM_LIB=env.o
)

run "$ODIN" build "$SRC_DIR" "${ODIN_FLAGS[@]}" -out:"$WEB_OUT_DIR/$APP_CODE"

EMCC_INPUTS=(
    "$SCRIPTS_DIR/web/main.c"
    "$WEB_OUT_DIR/$APP_CODE.wasm.o"
)

EMCC_FLAGS=(
    -sUSE_GLFW=3
    -sASYNCIFY
    -L"$ODIN_ROOT/vendor/raylib/wasm"
    -lraylib
)

if [[ "$RAYGUI" == true ]]; then
    EMCC_FLAGS+=(-lraygui)
fi

if [[ -d "$ASSETS_DIR" ]]; then
    EMCC_FLAGS+=(--preload-file "$ASSETS_DIR")
else
    warn "No ASSETS_DIR='$ASSETS_DIR' to bundle"
fi

if [[ $DEBUG == true ]]; then
    : # Use the default Emscripten shell for debug mode
else
    EMCC_FLAGS+=(--shell-file "$WEB_SHELL")
fi

if [[ -v EMCC_EXTRA_FLAGS[@] ]]; then
    EMCC_FLAGS+=("${EMCC_EXTRA_FLAGS[@]}")
fi

run "$EMCC" "${EMCC_INPUTS[@]}" "${EMCC_FLAGS[@]}" -o "$WEB_OUT_DIR/index.html"

run rm "$WEB_OUT_DIR/$APP_CODE.wasm.o"

if [[ "${1-}" == -r ]]; then
    "$SCRIPTS_DIR/run_web.sh"
fi
