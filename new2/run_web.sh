#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

source "$ROOT_DIR/common.sh"
source "$ROOT_DIR/common_build.sh"
source "$ROOT_DIR/common_web.sh"

URL=http://127.0.0.1:8000

if [ -x "$(command -v python)" ]; then
    if [ -x "$(command -v xdg-open)" ]; then
        (sleep 1; xdg-open "$URL") &
    else
        echo "Open the following URL in your browser"
        echo
        echo "    $URL"
        echo
    fi
    python -m http.server -b 0.0.0.0 -d "$WEB_OUT_DIR"
else
    echo >&2 "Could not start python http server!"
    echo >&2
    echo >&2 "Install python first or use some other command to serve files from '$WEB_OUT_DIR' via http."
fi
