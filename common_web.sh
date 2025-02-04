# shellcheck shell=bash

ROOT_DIR=$(dirname "$0")

WEB_OUT_DIR=${WEB_OUT_DIR:-"$OUT_DIR/web"}
WEB_SHELL=${WEB_SHELL:-"$ROOT_DIR/web/shell.html"}
WEB_TEMP_ALLOCATOR_SIZE=${WEB_TEMP_ALLOCATOR_SIZE:-1048576} # 1MB

print_var WEB_OUT_DIR
print_var WEB_SHELL
print_var WEB_TEMP_ALLOCATOR_SIZE
