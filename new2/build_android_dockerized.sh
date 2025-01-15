#!/usr/bin/env bash

set -euo pipefail

"$(dirname "$0")/run_image.sh" android /mnt/scripts/build_android.sh

if [[ "${1-}" == -r ]]; then
    "$(dirname "$0")/run_android.sh"
fi
