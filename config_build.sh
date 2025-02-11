# shellcheck shell=bash

DEBUG=${DEBUG:-false}
DEBUG=$(normalize_bool DEBUG)

RAYGUI=${RAYGUI:-true}
RAYGUI=$(normalize_bool RAYGUI)

print_var DEBUG
print_var RAYGUI

assert_var_is_dir SRC_DIR
