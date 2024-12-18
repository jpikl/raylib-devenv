#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(dirname -- "$0")

# shellcheck source=./config.sh
. "$SCRIPT_DIR/config.sh"

"$DOCKER" run \
    --rm \
    --tty \
    --interactive \
    --volume "$PWD:/mnt" \
    --workdir /mnt \
    "$TAG" \
    "$@"
