# shellcheck shell=bash

DOCKER_IMAGE=${DOCKER_IMAGE:-"$APP_CODE-build-env"}

if [ ! "${DOCKER-}" ]; then
    if [ -x "$(command -v podman)" ]; then
        DOCKER=podman
    elif [ -x "$(command -v docker)" ]; then
        DOCKER=docker
    else
        die "Neither podman or docker is installed"
    fi
fi
