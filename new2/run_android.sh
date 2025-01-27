#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

source "$ROOT_DIR/common.sh"
source "$ROOT_DIR/common_build.sh"
#source "$ROOT_DIR/common_android.sh"

adb install "out/android/game.apk"
adb shell am start -n com.example/.NativeLoader
