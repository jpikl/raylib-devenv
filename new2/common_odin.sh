# shellcheck shell=bash

if [[ ! "${ODIN_ROOT-}" ]]; then
    ODIN_ROOT=$(dirname "$(command -v odin)")
fi

ODIN_FLAGS=(
    -vet
    -strict-style
    -define:APP_CODE="${APP_CODE}"
    -define:APP_NAME="${APP_NAME}"
    -define:APP_VERSION="${APP_VERSION}"
    -define:ASSETS_DIR="${ASSETS_DIR}"
    -collection:helpers="$(dirname "$0")/helpers"
)

if [[ ${DEBUG-} = 1 || ${DEBUG-} = true ]]; then
    ODIN_FLAGS+=(-debug)
else
    ODIN_FLAGS+=(-o:speed)
fi

if [[ -v ODIN_EXTRA_FLAGS[@] ]]; then
    ODIN_FLAGS+=("${ODIN_EXTRA_FLAGS[@]}")
fi
