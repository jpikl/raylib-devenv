# shellcheck shell=bash

LINUX_OUT_DIR=${LINUX_OUT_DIR:-"$OUT_DIR/linux"}
LINUX_BINARY=${LINUX_BINARY:-"$APP_CODE"}

print_linux_vars() {
    print_var LINUX_OUT_DIR
    print_var LINUX_BINARY
}
