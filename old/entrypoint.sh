#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$EMSDK_HOME/emsdk_env.sh" &>/dev/null

# Print debugging info
printf "Working dir: %s\n" "$PWD"
printf "User: "
id
printf "Command: "
printf "%q " "$@"
printf "\n\n"

exec "$@"
