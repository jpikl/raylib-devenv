#!/usr/bin/env sh

set -eu

# Rerun itself in containerized environment if not already there
if [ ! "${INSIDE_RAYLIB_DEVENV-}" ]; then
    ROOT_DIR=$(dirname "$0")/../..
    SCRIPT_PATH=$(realpath --relative-to "$ROOT_DIR" "$0")
    MOUNT_DIR=$ROOT_DIR exec "$ROOT_DIR/run.sh" "$SCRIPT_PATH"
fi

# Execute all commands relative to this script directory
cd "$(dirname -- "$0")"

# To see what commands are being executed
set -x

# Clean output directory
rm -rf out
mkdir -p out

# Build executable
x86_64-w64-mingw32-gcc main.c \
    -I/usr/local/include \
    -L"$RAYLIB_LIB_PATH/win64-shared" \
    -lraylib \
    -lgdi32 \
    -lwinmm \
    -o out/game

# Copy assets and shared libraries
cp -a "$RAYLIB_LIB_PATH"/win64-shared/*.dll out
cp -r ../common/assets out
