#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

source "$ROOT_DIR/common.sh"
source "$ROOT_DIR/common_build.sh"
source "$ROOT_DIR/common_windows.sh"

run cd "$WINDOWS_OUT_DIR"
run wine "$WINDOWS_BINARY"
