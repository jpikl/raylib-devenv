#!/usr/bin/env bash

set -euo pipefail

"$(dirname "$0")/run_image.sh" linux /mnt/scripts/build_linux.sh

if [[ "${1-}" == -r ]]; then
    "$(dirname "$0")/run_linux.sh"
fi
