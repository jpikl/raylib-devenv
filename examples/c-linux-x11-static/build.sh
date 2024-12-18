#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(dirname -- "$0")
OUTPUT_DIR="$SCRIPT_DIR/out"

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

"$SCRIPT_DIR/../../run.sh" \
    cc \
    "$SCRIPT_DIR/main.c" \
    -L/usr/local/lib/raylib/linux-x11-static \
    -lraylib \
    -lGL \
    -lm \
    -lpthread \
    -ldl \
    -lrt \
    -lX11 \
    -o "$OUTPUT_DIR/game"

if [ "${TEST-}" ]; then
    assert() { sh -c "$1" || ( printf "\n\e[31mAssertion failed: \e[0m%s\n" "$1"; exit 1 ) }>&2
    assert "[ -x '$OUTPUT_DIR/game' ]"
    assert "! ldd '$OUTPUT_DIR/game' | grep libraylib.so >/dev/null"
fi
