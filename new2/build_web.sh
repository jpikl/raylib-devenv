#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/common.sh"
source "$(dirname "$0")/common_web.sh"
source "$(dirname "$0")/common_odin.sh"

rm -rf "$WEB_OUT_DIR"
mkdir -p "$WEB_OUT_DIR"

source "$EMSDK_HOME/emsdk_env.sh"

ODIN_FLAGS+=(
    -target:freestanding_wasm32
    -build-mode:obj

    # This env.o thing is the object file that contains things linked into the WASM binary.
    # You can see how RAYLIB_WASM_LIB is used inside <odin>/vendor/raylib/raylib.odin.
    #
    # We have to do it this way because the emscripten compiler (emcc) needs to be fed the precompiled raylib library file.
    # That stuff will end up in env.o, which our Odin code is instructed to link to.

   -define:RAYLIB_WASM_LIB=env.o
   -define:RAYGUI_WASM_LIB=env.o
)

odin build "$SRC_DIR" "${ODIN_FLAGS[@]}" -out:"$WEB_OUT_DIR/$APP_CODE"

EMCC_INPUTS=(
   "$(dirname "$0")/web/main.c"
   "$WEB_OUT_DIR/$APP_CODE.wasm.o"
)

EMCC_FLAGS=(
    -sUSE_GLFW=3
    -sASYNCIFY
    -L"$ODIN_ROOT/vendor/raylib/wasm"
    -lraylib
    -lraygui
    --preload-file "$ASSETS_DIR"
)

if [[ ${DEBUG-} = 1 || ${DEBUG-} == true ]]; then
    : # Use the default shell in debug mode
else
    EMCC_FLAGS+=(--shell-file "$WEB_SHELL")
fi

emcc "${EMCC_INPUTS[@]}" "${EMCC_FLAGS[@]}" -o "$WEB_OUT_DIR/index.html"

rm "$WEB_OUT_DIR/$APP_CODE.wasm.o"

if [[ "${1-}" == -r ]]; then
    "$(dirname "$0")/run_web.sh"
fi
