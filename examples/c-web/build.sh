#!/usr/bin/env sh

set -eu

cd "$(dirname -- "$0")"

rm -rf out
mkdir -p out

emcc main.c \
    -sUSE_GLFW=3 \
    -I/usr/local/include \
    -L/usr/local/lib/raylib/web \
    -lraylib \
    --preload-file ../assets@. \
    --shell-file shell.html \
    -o out/index.html
