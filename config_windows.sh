# shellcheck shell=bash

WINDOWS_OUT_DIR=${WINDOWS_OUT_DIR:-"$OUT_DIR/windows"}
WINDOWS_BINARY=${WINDOWS_BINARY:-"$APP_CODE.exe"}

print_var WINDOWS_OUT_DIR
print_var WINDOWS_BINARY
