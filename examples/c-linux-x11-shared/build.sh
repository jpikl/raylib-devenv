#!/usr/bin/env sh

set -eu

cd "$(dirname -- "$0")"

rm -rf out
mkdir -p out

cc main.c \
    -L/usr/local/lib/raylib/linux-x11-shared \
    -lraylib \
    -lGL \
    -lm \
    -lpthread \
    -ldl \
    -lrt \
    -lX11 \
    -o out/game

cp -a /usr/local/lib/raylib/linux-x11-shared/*.so* out
cp ../assets/* out
