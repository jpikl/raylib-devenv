#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

source "$ROOT_DIR/common.sh"
source "$ROOT_DIR/config_app.sh"
source "$ROOT_DIR/common_build.sh"
source "$ROOT_DIR/common_android.sh"

adb install "$ANDROID_OUT_DIR/$ANDROID_APK"
adb shell am start -n "$ANDROID_PACKAGE/.MainActivity"
