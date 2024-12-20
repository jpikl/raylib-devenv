#!/usr/bin/env sh

set -eu

MOUNT_DIR=$(realpath "${MOUNT_DIR:-$PWD}")

cd "$(dirname -- "$0")"

. ./config.sh

echo "Mount dir: $MOUNT_DIR"

# Default run options
set -- \
    --rm \
    --volume "$MOUNT_DIR:/mnt" \
    --workdir /mnt \
    "$TAG" \
    "$@"

# Enable interactivity only when run from terminal and not on CI.
if [ -t 0 ] && [ -t 1 ] && [ ! "${CI-}" ]; then
    set -- --tty --interactive "$@"
fi

# Map the current user to the user within the container.
if [ "$ENGINE" = docker ]; then
    set -- --user="$(id -u):$(id -g)" "$@"
elif [ "$ENGINE" = podman ]; then
    set -- --userns="keep-id:uid=1000,gid=1000" "$@"
fi

"$ENGINE" run "$@"
