#!/usr/bin/env sh

. ./config.sh

"$DOCKER" build --tag "$TAG" .
