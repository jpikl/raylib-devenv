#!/usr/bin/env bash

# shellcheck disable=SC1091
source /opt/emsdk/emsdk_env.sh &>/dev/null

exec "$@"
