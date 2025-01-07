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
    --publish 8080:8080 \
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

# For Android ADB to be able to access USB devices
if [ -d /dev/bus/usb ]; then
    set -- --volume /dev/bus/usb/:/dev/bus/usb "$@"
fi

"$ENGINE" run "$@"
