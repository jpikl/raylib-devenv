#!/usr/bin/env bash

set -euo pipefail

SCRIPTS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
readonly SCRIPTS_DIR=$SCRIPTS_DIR

source "$SCRIPTS_DIR/common.sh"
source "$SCRIPTS_DIR/config_dirs.sh"

run rm -rf "$OUT_DIR"
