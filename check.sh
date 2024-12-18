#!/usr/bin/env sh

shellcheck \
    --check-sourced \
    --external-sources \
    build.sh \
    check.sh \
    entrypoint.sh \
    run.sh \
    test.sh \
    examples/*/*.sh
