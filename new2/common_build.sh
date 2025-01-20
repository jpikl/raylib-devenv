# shellcheck shell=bash

SRC_DIR=${SRC_DIR:-"src"}
OUT_DIR=${OUT_DIR:-"out"}
ASSETS_DIR=${ASSETS_DIR:-"assets"}

# shellcheck disable=SC2034
DEBUG=$(normalize_bool DEBUG)

print_var SRC_DIR
print_var OUT_DIR
print_var ASSETS_DIR
print_var DEBUG
