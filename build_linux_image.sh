#!/usr/bin/env bash

set -euo pipefail

SCRIPTS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

source "$SCRIPTS_DIR/config_base.sh"
source "$SCRIPTS_DIR/config_app.sh"
source "$SCRIPTS_DIR/config_docker.sh"

run "$DOCKER" build \
    --tag "$DOCKER_IMAGE:linux" \
    --file "$SCRIPTS_DIR/docker/linux.dockerfile" \
    --build-arg SCRIPTS_DIR="$DOCKER_SCRIPTS_DIR" \
    "$@"
