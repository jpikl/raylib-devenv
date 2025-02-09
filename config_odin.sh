# shellcheck shell=bash

ROOT_DIR=$(dirname "$0")

if [[ "${ODIN_ROOT:=}" ]]; then
    assert_var_is_dir ODIN_ROOT
    export PATH=$ODIN_ROOT:$PATH
fi

if [[ "${ODIN:=}" ]]; then
    assert_var_is_executable ODIN
else
    ODIN=$(find_executable odin)
fi

if [[ ! "$ODIN_ROOT" ]]; then
    ODIN_ROOT=$("$ODIN" root)
fi

ODIN_STRICT=${ODIN_STRICT:-true}
ODIN_STRICT=$(normalize_bool ODIN_STRICT)
ODIN_OPTIMIZATION=${ODIN_OPTIMIZATION:-speed}

ODIN_FLAGS=(
    -define:APP_CODE="$APP_CODE"
    -define:APP_NAME="$APP_NAME"
    -define:APP_VERSION="$APP_VERSION"
    -define:ASSETS_DIR="$ASSETS_DIR"
    -collection:build="$ROOT_DIR/odin"
    -show-system-calls
)

if [[ $ODIN_STRICT == true ]]; then
    ODIN_FLAGS+=(
        -vet
        -strict-style
    )
fi

if [[ $DEBUG == true ]]; then
    ODIN_FLAGS+=(-debug)
else
    ODIN_FLAGS+=(-o:"$ODIN_OPTIMIZATION")
fi

if [[ -v ODIN_EXTRA_FLAGS[@] ]]; then
    ODIN_FLAGS+=("${ODIN_EXTRA_FLAGS[@]}")
fi

print_var ODIN
print_var ODIN_ROOT
print_var ODIN_STRICT
print_var ODIN_OPTIMIZATION
print_arr ODIN_EXTRA_FLAGS
