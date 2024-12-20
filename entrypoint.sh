#!/usr/bin/env bash

# shellcheck disable=SC1091
source /opt/emsdk/emsdk_env.sh &>/dev/null

# Print executed command for easier debugging
printf "Command: "
printf "%q " "$@"
printf "\n\n"

exec "$@"
