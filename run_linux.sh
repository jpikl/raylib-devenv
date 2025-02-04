#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

source "$ROOT_DIR/common.sh"
source "$ROOT_DIR/common_build.sh"
source "$ROOT_DIR/common_linux.sh"

run cd "$LINUX_OUT_DIR"
run "./$LINUX_BINARY"
