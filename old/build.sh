#!/usr/bin/env sh

set -eu

cd "$(dirname -- "$0")"

. ./config.sh

echo

"$ENGINE" build --tag "$TAG" .
