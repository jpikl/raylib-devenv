#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")
PROJECT_DIR=$PWD
PLATFORM=$1
shift

source "$ROOT_DIR/common.sh"
source "$ROOT_DIR/common_build.sh"
source "$ROOT_DIR/common_docker.sh"

print_docker_vars

DOCKER_RUN_FLAGS=(
    --rm
    --volume "$PROJECT_DIR:/mnt/project"
    --volume "$ROOT_DIR:/mnt/scripts"
    --workdir /mnt/project
    --env "DEBUG=$DEBUG"
)

if [[ $DOCKER_TYPE == docker ]]; then
    DOCKER_RUN_FLAGS+=(--user="$(id -u):$(id -g)")
fi

"$DOCKER" run "${DOCKER_RUN_FLAGS[@]}" "$DOCKER_IMAGE:$PLATFORM" "$@"
