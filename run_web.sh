#!/usr/bin/env bash

set -euo pipefail

SCRIPTS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
readonly SCRIPTS_DIR=$SCRIPTS_DIR

source "$SCRIPTS_DIR/common.sh"
source "$SCRIPTS_DIR/config_dirs.sh"
source "$SCRIPTS_DIR/config_web.sh"

if [[ -x "$(command -v emrun)" ]]; then
    run emrun --port "$WEB_PORT" "$WEB_OUT_DIR"
elif [[ -x "$(command -v python)" ]]; then
    if [[ -x "$(command -v xdg-open)" ]]; then
        (
            sleep 1
            run xdg-open "$WEB_URL"
        ) &
    else
        echo "Open the following URL in your browser: $WEB_URL"
    fi
    run python -m http.server -b 0.0.0.0 -d "$WEB_OUT_DIR" "$WEB_PORT"
elif [[ -x "$(command -v npx)" ]]; then
    run npx http-server -c-1 -o -p "$WEB_PORT" "$WEB_OUT_DIR"
else
    die "Unable to start HTTP server to serve files from '$WEB_OUT_DIR'"
fi
