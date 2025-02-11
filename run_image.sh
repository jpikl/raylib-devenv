#!/usr/bin/env bash

set -euo pipefail

SCRIPTS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
readonly SCRIPTS_DIR=$SCRIPTS_DIR

source "$SCRIPTS_DIR/common.sh"
source "$SCRIPTS_DIR/config_app.sh"
source "$SCRIPTS_DIR/config_docker.sh"

PLATFORM=$1
shift

DOCKER_RUN_FLAGS=(
    --rm
    --volume "$PROJECT_DIR:$DOCKER_PROJECT_DIR"
    --volume "$SCRIPTS_DIR:$DOCKER_SCRIPTS_DIR"
    --workdir "$DOCKER_PROJECT_DIR"
    --env "DEBUG=${DEBUG-}"
)

if [[ $# -eq 0 ]]; then
    DOCKER_RUN_FLAGS+=(--interactive --tty)
fi

if [[ $DOCKER_TYPE == docker ]]; then
    DOCKER_RUN_FLAGS+=(--user="$(id -u):$(id -g)")
fi

run "$DOCKER" run "${DOCKER_RUN_FLAGS[@]}" "$DOCKER_IMAGE:$PLATFORM" "$@"
