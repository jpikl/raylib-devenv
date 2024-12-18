#!/usr/bin/env sh

set -eu

cd "$(dirname -- "$0")"

# shellcheck source=./examples/common/test.sh
. ../common/test.sh

assert "[ -f out/index.html ]"
assert "[ -f out/index.wasm ]"
assert "[ -f out/index.data ]"
assert "[ -f out/index.js ]"
