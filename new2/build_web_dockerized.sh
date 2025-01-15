#!/usr/bin/env bash

set -euo pipefail

"$(dirname "$0")/run_image.sh" web /mnt/scripts/build_web.sh

if [[ "${1-}" == -r ]]; then
    "$(dirname "$0")/run_web.sh"
fi
