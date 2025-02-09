#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

source "$ROOT_DIR/common.sh"
source "$ROOT_DIR/config_app.sh"
source "$ROOT_DIR/config_docker.sh"

run "$DOCKER" build --tag "$DOCKER_IMAGE:linux" \
    --file "$ROOT_DIR/docker/linux.dockerfile" \
    --build-arg SCRIPTS_DIR="$DOCKER_SCRIPTS_DIR" \
    "$@"
