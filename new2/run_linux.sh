#!/usr/bin/env bash

set -eu

source "$(dirname "$0")/common.sh"
source "$(dirname "$0")/common_linux.sh"

cd "$LINUX_OUT_DIR" && "./$LINUX_BINARY"
