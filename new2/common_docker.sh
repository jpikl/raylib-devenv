# shellcheck shell=bash

if [[ "${DOCKER:=}" ]]; then
    check_var_is_executable DOCKER
else
    DOCKER=$(find_executable podman docker)
fi

# shellcheck disable=SC2034
DOCKER_TYPE=$(basename "$DOCKER")
DOCKER_IMAGE=${DOCKER_IMAGE:-"$APP_CODE-build-env"}

print_var DOCKER
print_var DOCKER_TYPE
print_var DOCKER_IMAGE
