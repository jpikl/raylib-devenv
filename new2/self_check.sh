#!/usr/bin/env sh

set -eu

cd "$(dirname "$0")"

find . -name '*.sh' -print0 | xargs --verbose --no-run-if-empty --null shellcheck --external-sources --
