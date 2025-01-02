#!/usr/bin/env sh

set -eu

cd "$(dirname -- "$0")"

# shellcheck source=./examples/common/test.sh
. ../common/test.sh

assert "[ -x out/game.exe ]"
assert "[ -f out/assets/raylib.png ]"
assert "[ -f out/assets/coin.wav ]"
assert_if_display "TEST=1 ./run.sh | grep 'PLATFORM.*DESKTOP.*GLFW.*Win32' >/dev/null"
