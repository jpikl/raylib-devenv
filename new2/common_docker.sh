# shellcheck shell=bash

DOCKER_IMAGE=${DOCKER_IMAGE:-"$APP_CODE-devenv"}

if [ ! "${DOCKER-}" ]; then
    if [ -x "$(command -v podman)" ]; then
        DOCKER=podman
    elif [ -x "$(command -v docker)" ]; then
        DOCKER=docker
    else
        echo >&2 "$0: neither podman or docker is installed"
        exit 1
    fi
fi
