# shellcheck shell=bash

if [[ "${DOCKER:=}" && ! -x "$DOCKER" ]]; then
    die "DOCKER='$DOCKER' is not executable"
fi

if [ ! "$DOCKER" ]; then
    if [ -x "$(command -v podman)" ]; then
        DOCKER=podman
    elif [ -x "$(command -v docker)" ]; then
        DOCKER=docker
    else
        die "Neither podman or docker is installed"
    fi
fi

# shellcheck disable=SC2034
DOCKER_TYPE=$(basename "$DOCKER")
DOCKER_IMAGE=${DOCKER_IMAGE:-"$APP_CODE-build-env"}

print_var DOCKER
print_var DOCKER_TYPE
print_var DOCKER_IMAGE
