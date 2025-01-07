#!/usr/bin/env sh

set -eu

# Rerun itself in containerized environment if ADB is not installed locally
if [ ! "$(command -v adb)" ] && [ ! "${INSIDE_RAYLIB_DEVENV-}" ]; then
    ROOT_DIR=$(dirname "$0")/../..
    SCRIPT_PATH=$(realpath --relative-to "$ROOT_DIR" "$0")
    MOUNT_DIR=$ROOT_DIR exec "$ROOT_DIR/run.sh" "$SCRIPT_PATH"
fi

adb install "$(dirname -- "$0")/out/apk/game.apk"
adb shell am start -n com.example/.NativeLoader
