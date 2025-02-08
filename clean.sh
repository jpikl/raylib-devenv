#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

source "$ROOT_DIR/common.sh"
source "$ROOT_DIR/config_app.sh"
source "$ROOT_DIR/common_build.sh"

run rm -rf "$OUT_DIR"
