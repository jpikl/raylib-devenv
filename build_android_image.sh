#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

source "$ROOT_DIR/build_linux_image.sh"

run "$DOCKER" build --tag "$DOCKER_IMAGE:android" \
                    --build-arg BASE_DOCKER_IMAGE="$DOCKER_IMAGE:linux" \
                    --file "$ROOT_DIR/docker/android.dockerfile" \
                    "$@"
