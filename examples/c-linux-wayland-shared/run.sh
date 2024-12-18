#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(dirname -- "$0")
OUTPUT_DIR="$SCRIPT_DIR/out"

# Use raylib dynamic libraries in the output directory
LD_LIBRARY_PATH=$OUTPUT_DIR "$OUTPUT_DIR/game"
