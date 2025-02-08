#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")
PROJECT_DIR=$PWD
PLATFORM=$1
shift

source "$ROOT_DIR/common.sh"
source "$ROOT_DIR/config_app.sh"
source "$ROOT_DIR/common_build.sh"
source "$ROOT_DIR/common_docker.sh"

DOCKER_RUN_FLAGS=(
    --rm
    --volume "$PROJECT_DIR:$DOCKER_PROJECT_DIR"
    --volume "$ROOT_DIR:$DOCKER_SCRIPTS_DIR"
    --workdir "$DOCKER_PROJECT_DIR"
    --env "DEBUG=$DEBUG"
)

if [[ $# -eq 0 ]]; then
    DOCKER_RUN_FLAGS+=(--interactive --tty)
fi

if [[ $DOCKER_TYPE == docker ]]; then
    DOCKER_RUN_FLAGS+=(--user="$(id -u):$(id -g)")
fi

run "$DOCKER" run "${DOCKER_RUN_FLAGS[@]}" "$DOCKER_IMAGE:$PLATFORM" "$@"
