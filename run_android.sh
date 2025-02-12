#!/usr/bin/env bash

set -euo pipefail

SCRIPTS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

source "$SCRIPTS_DIR/config_base.sh"
source "$SCRIPTS_DIR/config_app.sh"
source "$SCRIPTS_DIR/config_dirs.sh"
source "$SCRIPTS_DIR/config_android.sh"

adb install "$ANDROID_OUT_DIR/$ANDROID_APK"
adb shell am start -n "$ANDROID_PACKAGE/.MainActivity"
