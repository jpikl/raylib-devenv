# shellcheck shell=bash

assert_var_is_dir XWIN_HOME

# shellcheck disable=SC2034
LINK=$(find_executable lld-link)

print_var XWIN_HOME
print_var LINK
