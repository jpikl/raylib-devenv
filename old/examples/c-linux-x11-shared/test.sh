#!/usr/bin/env sh

set -eu

cd "$(dirname -- "$0")"

# shellcheck source=./examples/common/test.sh
. ../common/test.sh

assert "[ -x out/game ]"
assert "[ -f out/assets/raylib.png ]"
assert "[ -f out/assets/coin.wav ]"
assert "ldd out/game | grep libraylib.so >/dev/null"
assert "[ \$(find out -name '*.so*' | wc -l) -eq 3 ]"
assert_if_display "TEST=1 ./run.sh | grep 'PLATFORM.*DESKTOP.*GLFW.*X11' >/dev/null"
