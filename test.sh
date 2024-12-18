#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(dirname -- "$0")

for EXAMPLE_DIR in "$SCRIPT_DIR"/examples/*; do
    printf "\e[1m%s\e[0m\n\n" "====================[ $EXAMPLE_DIR ] ===================="
    if "$EXAMPLE_DIR/build.sh"; then
        printf "\n\e[32m%s\e[0m\n\n" "SUCCESS"
    else
        printf "\n\e[31m%s\e[0m\n\n" "FAILURE"
    fi
done
