#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(dirname -- "$0")
OUTPUT_DIR="$SCRIPT_DIR/out"

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

"$SCRIPT_DIR/../../run.sh" \
    cc \
    "$SCRIPT_DIR/main.c" \
    -L/usr/local/lib/raylib/linux-wayland-shared \
    -lraylib \
    -lGL \
    -lm \
    -lpthread \
    -ldl \
    -lrt \
    -lX11 \
    -o "$OUTPUT_DIR/game"

# Copy raylib dynamic libraries to the output directory
"$SCRIPT_DIR/../../run.sh" \
    sh -c "cp -a /usr/local/lib/raylib/linux-wayland-shared/*.so* '$OUTPUT_DIR'"

if [ "${TEST-}" ]; then
    assert() { sh -c "$1" || ( printf "\n\e[31mAssertion failed: \e[0m%s\n" "$1"; exit 1 ) }>&2
    assert "[ -x '$OUTPUT_DIR/game' ]"
    assert "ldd '$OUTPUT_DIR/game' | grep libraylib.so >/dev/null"
    assert "[ \$(find '$OUTPUT_DIR' -name '*.so*' | wc -l) -eq 3 ]"
fi
