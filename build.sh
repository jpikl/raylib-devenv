#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(dirname -- "$0")

# shellcheck source=./config.sh
. "$SCRIPT_DIR/config.sh"

"$DOCKER" build --tag "$TAG" .
