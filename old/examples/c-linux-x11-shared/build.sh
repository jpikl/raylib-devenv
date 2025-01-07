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
cc main.c \
    -L"$RAYLIB_LIB_PATH/linux-x11-shared" \
    -lraylib \
    -lGL \
    -lm \
    -lpthread \
    -ldl \
    -lrt \
    -lX11 \
    -o out/game

# Copy assets and shared libraries
cp -a "$RAYLIB_LIB_PATH"/linux-x11-shared/*.so* out
cp -r ../common/assets out
