#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(dirname -- "$0")
OUTPUT_DIR="$SCRIPT_DIR/out"

if [ -x "$(command -v python)" ]; then
    echo "Open the following URL in your browser"
    echo
    echo "    http://127.0.0.1:8000"
    echo
    python -m http.server -d "$OUTPUT_DIR"
else
    echo >&2 "Could not start python http server!"
    echo >&2
    echo >&2 "Either:"
    echo >&2 "    a) Install python first"
    echo >&2 "    b) Use some other command to serve files from '$OUTPUT_DIR' via http"
fi
