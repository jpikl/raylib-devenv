#!/usr/bin/env sh

set -eu

cd "$(dirname -- "$0")"

rm -rf out
mkdir -p out

cc main.c \
    -L/usr/local/lib/raylib/linux-wayland-shared \
    -lraylib \
    -lGL \
    -lm \
    -lpthread \
    -ldl \
    -lrt \
    -o out/game

cp -a /usr/local/lib/raylib/linux-wayland-shared/*.so* out
cp ../assets/* out
