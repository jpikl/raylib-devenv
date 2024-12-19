#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(dirname -- "$0")
EXIT_CODE=0

for EXAMPLE_DIR in "$SCRIPT_DIR"/examples/*; do
    if [ ! -f "$EXAMPLE_DIR/build.sh" ]; then
        continue
    fi

    printf "\n\e[1m%s\e[0m\n\n" "====================[ $EXAMPLE_DIR ] ===================="

    if "$SCRIPT_DIR/run.sh" "$EXAMPLE_DIR/build.sh"; then
        printf "\n\e[32m%s\e[0m\n" "Build OK"
    else
        printf "\n\e[31m%s\e[0m\n" "Build failed"
        EXIT_CODE=1
    fi

    if [ ! -f "$EXAMPLE_DIR/test.sh" ]; then
        printf "\e[33m%s\e[0m\n" "Tests missing"
    elif ! "$EXAMPLE_DIR/test.sh"; then
        EXIT_CODE=1
    fi
done

exit $EXIT_CODE
