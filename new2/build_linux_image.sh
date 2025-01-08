#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/common.sh"
source "$(dirname "$0")/common_docker.sh"

"$DOCKER" build --tag "$DOCKER_IMAGE:linux" \
                --file docker/linux.dockerfile
