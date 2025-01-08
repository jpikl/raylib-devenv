#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/build_linux_image.sh"

"$DOCKER" build --tag "$DOCKER_IMAGE:android" \
                --build-arg BASE_DOCKER_IMAGE="$DOCKER_IMAGE:linux" \
                --file docker/android.dockerfile
