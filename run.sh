#!/usr/bin/env sh

. ./config.sh

"$DOCKER" run --rm --tty --interactive "$TAG" "$@"
