#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(dirname -- "$0")

# shellcheck source=./config.sh
. "$SCRIPT_DIR/config.sh"

# Prepend default `docker run` options
set -- \
    --rm \
    --volume "$PWD:/mnt" \
    --workdir /mnt \
    "$TAG" \
    "$@"

# Enable interactivity only when run from terminal and not on CI
if [ -t 0 ] && [ -t 1 ] && [ ! "${CI-}" ]; then
    set -- --tty --interactive "$@"
fi

echo "$DOCKER" run "$@"
