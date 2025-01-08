#!/usr/bin/env bash

set -euo pipefail

"$(dirname "$0")/run_image.sh" android /mnt/scripts/build_android.sh
