#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/common.sh"
source "$(dirname "$0")/common_linux.sh"

cd "$LINUX_OUT_DIR" && "./$LINUX_BINARY"
