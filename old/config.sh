#!/usr/bin/env sh
# shellcheck disable=SC2034

set -eu

IMAGE=raylib-devenv
VERSION=latest
TAG=$IMAGE:$VERSION

if [ ! "${ENGINE-}" ]; then
    if [ -x "$(command -v podman)" ]; then
        ENGINE=podman
    elif [ -x "$(command -v docker)" ]; then
        ENGINE=docker
    else
        echo >&2 "Neither podman or docker is installed!"
        exit 1
    fi
fi

echo "Image: $IMAGE"
echo "Version: $VERSION"
echo "Engine: $ENGINE"
