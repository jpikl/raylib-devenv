#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(dirname -- "$0")
EXIT_CODE=0

for EXAMPLE_DIR in "$SCRIPT_DIR"/examples/*; do
    if [ ! -f "$EXAMPLE_DIR/build.sh" ]; then
        continue
    fi
    printf "\e[1m%s\e[0m\n\n" "====================[ $EXAMPLE_DIR ] ===================="
    if TEST=1 "$EXAMPLE_DIR/build.sh"; then
        printf "\n\e[32m%s\e[0m\n\n" "SUCCESS"
    else
        printf "\n\e[31m%s\e[0m\n\n" "FAILURE"
        EXIT_CODE=1
    fi
done

exit $EXIT_CODE
