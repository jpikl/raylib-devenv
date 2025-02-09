#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

source "$ROOT_DIR/common.sh"
source "$ROOT_DIR/config_app.sh"
source "$ROOT_DIR/config_dirs.sh"
source "$ROOT_DIR/config_build.sh"
source "$ROOT_DIR/config_odin.sh"
source "$ROOT_DIR/common_web.sh"

if [[ "${EMSDK:=}" ]]; then
    assert_var_is_dir EMSDK
    run source "$EMSDK/emsdk_env.sh"
fi

if [[ "${EMCC:=}" ]]; then
    assert_var_is_executable EMCC
else
    EMCC=$(find_executable emcc)
fi

print_var EMSDK
print_var EMCC
print_arr EMCC_EXTRA_FLAGS

assert_var_is_dir SRC_DIR
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
    \
    -define:RAYLIB_WASM_LIB=env.o
    -define:RAYGUI_WASM_LIB=env.o
)

run "$ODIN" build "$SRC_DIR" "${ODIN_FLAGS[@]}" -out:"$WEB_OUT_DIR/$APP_CODE"

EMCC_INPUTS=(
    "$ROOT_DIR/web/main.c"
    "$WEB_OUT_DIR/$APP_CODE.wasm.o"
)

EMCC_FLAGS=(
    -sUSE_GLFW=3
    -sASYNCIFY
    -L"$ODIN_ROOT/vendor/raylib/wasm"
    -lraylib
    -lraygui
)

if [[ -d "$ASSETS_DIR" ]]; then
    EMCC_FLAGS+=(--preload-file "$ASSETS_DIR")
else
    warn "No ASSETS_DIR='$ASSETS_DIR' to bundle"
fi

if [[ $DEBUG ]]; then
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
    "$ROOT_DIR/run_web.sh"
fi
