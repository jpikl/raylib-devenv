# shellcheck shell=bash

SRC_DIR=${SRC_DIR:-"$PROJECT_DIR/src"}
OUT_DIR=${OUT_DIR:-"$PROJECT_DIR/out"}
ASSETS_DIR=${ASSETS_DIR:-"$PROJECT_DIR/assets"}

# shellcheck disable=SC2034
ASSETS_DIR_RELATIVE=$(realpath --relative-to="$PROJECT_DIR" "$ASSETS_DIR")

print_var SRC_DIR
print_var OUT_DIR
print_var ASSETS_DIR
print_var ASSETS_DIR_RELATIVE
