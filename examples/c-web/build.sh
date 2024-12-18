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
