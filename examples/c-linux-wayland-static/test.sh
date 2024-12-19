#!/usr/bin/env sh

set -eu

cd "$(dirname -- "$0")"
. ../common/test.sh

assert "[ -x out/game ]"
assert "[ -f out/raylib.png ]"
assert "! ldd out/game | grep libraylib.so >/dev/null"
assert_if_display "TEST=1 ./run.sh | grep 'PLATFORM.*DESKTOP.*GLFW.*Wayland' >/dev/null"
