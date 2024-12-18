#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(dirname -- "$0")
OUTPUT_DIR="$SCRIPT_DIR/out"

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

"$SCRIPT_DIR/../../run.sh" \
    emcc \
    "$SCRIPT_DIR/main.c" \
    -sUSE_GLFW=3 \
    -I/usr/local/include \
    -L/usr/local/lib \
    -lraylib_web \
    --shell-file "$SCRIPT_DIR/shell.html" \
    -o "$OUTPUT_DIR/index.html"

if [ "${TEST-}" ]; then
    assert() { sh -c "$1" || ( printf "\n\e[31mAssertion failed: \e[0m%s\n" "$1"; exit 1 ) }>&2
    assert "[ -f '$OUTPUT_DIR/index.html' ]"
    assert "[ -f '$OUTPUT_DIR/index.wasm' ]"
    assert "[ -f '$OUTPUT_DIR/index.js' ]"
fi
