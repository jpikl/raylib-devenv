# shellcheck shell=bash

ROOT_DIR=$(dirname "$0")

if [[ "${ODIN_ROOT:=}" ]]; then
    check_var_is_dir ODIN_ROOT
    export PATH=$PATH:$ODIN_ROOT
fi

if [[ "${ODIN:=}" ]]; then
    check_var_is_executable ODIN
else
    ODIN=$(find_executable odin)
fi

if [[ ! "$ODIN_ROOT" ]]; then
    ODIN_ROOT=$(dirname "$(command -v "$ODIN")")
fi

ODIN_FLAGS=(
    -vet
    -strict-style
    -define:APP_CODE="${APP_CODE}"
    -define:APP_NAME="${APP_NAME}"
    -define:APP_VERSION="${APP_VERSION}"
    -define:ASSETS_DIR="${ASSETS_DIR}"
    -collection:helpers="$ROOT_DIR/helpers"
)

if [[ $DEBUG ]]; then
    ODIN_FLAGS+=(-debug)
else
    ODIN_FLAGS+=(-o:speed)
fi

if [[ -v ODIN_EXTRA_FLAGS[@] ]]; then
    ODIN_FLAGS+=("${ODIN_EXTRA_FLAGS[@]}")
fi

print_var ODIN
print_arr ODIN_EXTRA_FLAGS
