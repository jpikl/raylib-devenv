#!/usr/bin/env bash

set -euo pipefail

SCRIPTS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

"$SCRIPTS_DIR/build_linux_image.sh"

source "$SCRIPTS_DIR/config_base.sh"
source "$SCRIPTS_DIR/config_app.sh"
source "$SCRIPTS_DIR/config_docker.sh"

run "$DOCKER" build \
    --tag "$DOCKER_IMAGE:android" \
    --build-arg BASE_DOCKER_IMAGE="$DOCKER_IMAGE:linux" \
    --file "$SCRIPTS_DIR/docker/android.dockerfile" \
    "$@"
