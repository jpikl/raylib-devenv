#!/usr/bin/env sh

set -eu

shellcheck \
    --check-sourced \
    --external-sources \
    build.sh \
    check.sh \
    clean.sh \
    entrypoint.sh \
    run.sh \
    test.sh \
    examples/*/*.sh

printf "\e[32m%s\e[0m\n" "Check OK"
