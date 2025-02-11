# shellcheck shell=bash

WEB_OUT_DIR=${WEB_OUT_DIR:-"$OUT_DIR/web"}
WEB_SHELL=${WEB_SHELL:-"$SCRIPTS_DIR/web/shell.html"}
WEB_TEMP_ALLOCATOR_SIZE=${WEB_TEMP_ALLOCATOR_SIZE:-1048576} # 1MB
WEB_PORT=${WEB_PORT:-8080}
# shellcheck disable=SC2034
WEB_URL=http://127.0.0.1:$WEB_PORT

print_var WEB_OUT_DIR
print_var WEB_SHELL
print_var WEB_TEMP_ALLOCATOR_SIZE
print_var WEB_PORT
print_var WEB_URL
