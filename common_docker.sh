# shellcheck shell=bash

if [[ "${DOCKER:=}" ]]; then
    assert_var_is_executable DOCKER
else
    DOCKER=$(find_executable podman docker)
fi

# shellcheck disable=SC2034
DOCKER_TYPE=$(basename "$DOCKER")
DOCKER_IMAGE=${DOCKER_IMAGE:-"$APP_CODE-build-env"}

DOCKER_PROJECT_DIR=${DOCKER_PROJECT_DIR:-"/mnt/project"}
DOCKER_SCRIPTS_DIR=${DOCKER_SCRIPTS_DIR:-"/mnt/scripts"}

print_var DOCKER
print_var DOCKER_TYPE
print_var DOCKER_IMAGE
print_var DOCKER_PROJECT_DIR
print_var DOCKER_SCRIPTS_DIR
