#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

source "$ROOT_DIR/common.sh"
source "$ROOT_DIR/config_app.sh"
source "$ROOT_DIR/common_build.sh"
source "$ROOT_DIR/common_web.sh"

PORT=8000
URL=http://127.0.0.1:$PORT

if [[ -x "$(command -v emrun)" ]]; then
    run emrun --port "$PORT" "$WEB_OUT_DIR"
elif [[ -x "$(command -v python)" ]]; then
    if [[ -x "$(command -v xdg-open)" ]]; then
        (
            sleep 1
            run xdg-open "$URL"
        ) &
    else
        echo "Open the following URL in your browser: $URL"
    fi
    run python -m http.server -b 0.0.0.0 -d "$WEB_OUT_DIR" "$PORT"
elif [[ -x "$(command -v npx)" ]]; then
    run npx http-server -c-1 -o -p "$PORT" "$WEB_OUT_DIR"
else
    die "Unable to start HTTP server to serve files from '$WEB_OUT_DIR'"
fi
