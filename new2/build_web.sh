#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/common.sh"
source "$(dirname "$0")/common_web.sh"
source "$(dirname "$0")/common_odin.sh"

run rm -rf "$WEB_OUT_DIR"
run mkdir -p "$WEB_OUT_DIR"

EMCC=${EMCC-}
EMSDK_HOME=${EMSDK_HOME-}

if [[ "$EMCC" && ! -x "$EMCC" ]]; then
    die "EMCC='$EMCC' is not executable"
fi

if [[ "$EMSDK_HOME" && ! -d "$EMSDK_HOME" ]]; then
    die "EMSDK_HOME='$EMSDK_HOME' is not a directory"
fi

if [[ ! "$EMCC" ]]; then
    if [[ "$EMSDK_HOME" ]]; then
        run source "$EMSDK_HOME/emsdk_env.sh"
    fi
    if [[ -x "$(command -v emcc)" ]]; then
        EMCC=emcc
    else
        die "Could not find emcc binary"
    fi
fi

ODIN_FLAGS+=(
    -target:freestanding_wasm32
    -build-mode:obj
    -define:TEMP_ALLOCATOR_SIZE="$WEB_TEMP_ALLOCATOR_SIZE"

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

if [[ -v EMCC_EXTRA_FLAGS[@] ]]; then
    EMCC_FLAGS+=("${EMCC_EXTRA_FLAGS[@]}")
fi

run "$EMCC" "${EMCC_INPUTS[@]}" "${EMCC_FLAGS[@]}" -o "$WEB_OUT_DIR/index.html"

run rm "$WEB_OUT_DIR/$APP_CODE.wasm.o"

if [[ "${1-}" == -r ]]; then
    "$(dirname "$0")/run_web.sh"
fi
