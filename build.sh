#!/usr/bin/env sh

set -eu

cd "$(dirname -- "$0")"

. ./config.sh

"$DOCKER" build --tag "$TAG" .
