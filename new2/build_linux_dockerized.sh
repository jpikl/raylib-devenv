#!/usr/bin/env bash

set -euo pipefail

"$(dirname "$0")/run_image.sh" linux /mnt/scripts/build_linux.sh
