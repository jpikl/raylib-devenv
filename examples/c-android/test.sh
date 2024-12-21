#!/usr/bin/env sh

set -eu

cd "$(dirname -- "$0")"

# shellcheck source=./examples/common/test.sh
. ../common/test.sh

assert "[ -f out/apk/game.apk ]"
