# shellcheck shell=bash

ROOT_DIR=$(dirname "$0")

if [[ "${ODIN:=}" && ! -x "$ODIN" ]]; then
    die "ODIN='$ODIN' is not executable"
fi

if [[ "${ODIN_ROOT:=}" && ! -d "$ODIN_ROOT" ]]; then
    die "ODIN_ROOT='$ODIN_ROOT' is not a directory"
fi

if [[ ! "$ODIN" ]]; then
    if [[ "$ODIN_ROOT" && -x "$ODIN_ROOT/odin" ]]; then
        ODIN=$ODIN_ROOT/odin
    elif [[ -x "$(command -v odin)" ]]; then
        ODIN=odin
    else
        die "Could not find odin binary"
    fi
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
