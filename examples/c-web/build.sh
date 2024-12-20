#!/usr/bin/env sh

set -eu

# Rerun itself in containerized environment if not already there
if [ ! "${INSIDE_RAYLIB_DEVENV-}" ]; then
    ROOT_DIR=$(dirname "$0")/../..
    SCRIPT_PATH=$(realpath --relative-to "$ROOT_DIR" "$0")
    MOUNT_DIR=$ROOT_DIR exec "$ROOT_DIR/run.sh" "$SCRIPT_PATH"
fi

cd "$(dirname -- "$0")"
set -x

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
