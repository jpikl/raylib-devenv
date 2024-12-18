#!/usr/bin/env sh

shellcheck \
    --check-sourced \
    --external-sources \
    build.sh \
    check.sh \
    entrypoint.sh \
    run.sh \
    examples/*/*.sh
