# shellcheck shell=bash

SRC_DIR=${SRC_DIR:-"src"}
OUT_DIR=${OUT_DIR:-"out"}
ASSETS_DIR=${ASSETS_DIR:-"assets"}

DEBUG=$(normalize_bool DEBUG)

print_build_vars() {
    print_var SRC_DIR
    print_var OUT_DIR
    print_var ASSETS_DIR
    print_var DEBUG
}
