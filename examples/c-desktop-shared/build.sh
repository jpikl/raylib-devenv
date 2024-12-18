#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(dirname -- "$0")
OUTPUT_DIR="$SCRIPT_DIR/out"

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

"$SCRIPT_DIR/../../run.sh" \
    cc \
    "$SCRIPT_DIR/main.c" \
    -lraylib \
    -lGL \
    -lm \
    -lpthread \
    -ldl \
    -lrt \
    -lX11 \
    -o "$OUTPUT_DIR/game"

"$SCRIPT_DIR/../../run.sh" \
    sh -c "cp -a /usr/local/lib/libraylib.so* '$OUTPUT_DIR'"
