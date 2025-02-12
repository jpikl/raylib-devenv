# shellcheck shell=bash

if [[ ! "${SCRIPTS_DIR-}" ]]; then
    echo >&2 "$0 did not declare SCRIPTS_DIR variable"
    exit 1
fi

readonly SCRIPTS_DIR=$SCRIPTS_DIR

if [[ ! -d "${SCRIPTS_DIR-}" ]]; then
    echo >&2 "$0 declared SCRIPTS_DIR='$SCRIPTS_DIR' which is not a directory"
    exit 1
fi

source "$SCRIPTS_DIR/utils.sh"

if [[ "${PROJECT_DIR-}" ]]; then
    assert_var_is_dir PROJECT_DIR
    PROJECT_DIR=$(realpath "$PROJECT_DIR")
    readonly PROJECT_DIR=$PROJECT_DIR
else
    readonly PROJECT_DIR=$PWD
fi

print_var PROJECT_DIR
print_var SCRIPTS_DIR

# shellcheck disable=SC1091
if [[ -f config.sh ]]; then
    source config.sh
fi

# shellcheck disable=SC1091
if [[ -f .env ]]; then
    source .env
fi
