# shellcheck shell=bash

WEB_OUT_DIR=${LINUX_OUT_DIR:-"$OUT_DIR/web"}
WEB_SHELL="$(dirname "$0")/web/shell.html"
WEB_TEMP_ALLOCATOR_SIZE=${WEB_TEMP_ALLOCATOR_SIZE:-1048576} # 1MB
