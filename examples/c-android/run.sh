#!/usr/bin/env sh

set -eu

adb install "$(dirname -- "$0")/out/apk/game.signed.apk"
adb shell am start -n com.example/.NativeLoader
