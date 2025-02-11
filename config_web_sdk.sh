# shellcheck shell=bash

if [[ "${EMSDK:=}" ]]; then
    assert_var_is_dir EMSDK
    run source "$EMSDK/emsdk_env.sh"
fi

if [[ "${EMCC:=}" ]]; then
    assert_var_is_executable EMCC
else
    EMCC=$(find_executable emcc)
fi

print_var EMSDK
print_var EMCC
print_arr EMCC_EXTRA_FLAGS
