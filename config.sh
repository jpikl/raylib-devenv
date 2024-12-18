#!/usr/bin/env sh

set -eu

IMAGE=raylib-devenv
VERSION=latest
TAG=$IMAGE:$VERSION

if [ -x "$(command -v podman)" ]; then
    DOCKER=podman
elif [ -x "$(command -v docker)" ]; then
    DOCKER=docker
else
    echo >&2 "Neither podman or docker is installed!"
    exit 1
fi
