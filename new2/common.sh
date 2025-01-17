# shellcheck shell=bash

# Project specific configuration overrides
if [[ -f config.sh ]]; then
    source config.sh
fi

APP_CODE=${APP_CODE:-"app"}
APP_NAME=${APP_NAME:-"App"}
APP_VERSION=${APP_VERSION:-"1.0.0"}

SRC_DIR=${SRC_DIR:-"src"}
OUT_DIR=${OUT_DIR:-"out"}
ASSETS_DIR=${ASSETS_DIR:-"assets"}

RUN_COUNTER=0

run() {
    RUN_COUNTER=$((RUN_COUNTER+1))
    printf "\033[1m[Step %d]" "$RUN_COUNTER"
    printf " %q" "$@"
    printf "\033[0m\n"
    "$@"
}

die() {
    printf "\033[1;31m"
    echo >&2 "$@"
    printf "\033[0m"
    exit 1
}
