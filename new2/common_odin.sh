# shellcheck shell=bash

ODIN_FLAGS=(
    -vet
    -strict-style
    -define:APP_CODE="${APP_CODE}"
    -define:APP_NAME="${APP_NAME}"
    -define:APP_VERSION="${APP_VERSION}"
)

if [[ ${DEBUG-} = 1 || ${DEBUG-} = true ]]; then
    ODIN_FLAGS+=(-debug)
else
    ODIN_FLAGS+=(-o:speed)
fi
