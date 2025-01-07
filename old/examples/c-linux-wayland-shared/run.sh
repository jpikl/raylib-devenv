#!/usr/bin/env sh

set -eu

OUTPUT_DIR="$(dirname -- "$0")/out"

LD_LIBRARY_PATH=$OUTPUT_DIR exec "$OUTPUT_DIR/game"
