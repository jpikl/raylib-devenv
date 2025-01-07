#!/usr/bin/env sh

set -eu

OUTPUT_DIR="$(dirname -- "$0")/out"
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
    python -m http.server -d "$OUTPUT_DIR"
else
    echo >&2 "Could not start python http server!"
    echo >&2
    echo >&2 "Either:"
    echo >&2 "    a) Install python first."
    echo >&2 "    b) Use some other command to serve files from '$OUTPUT_DIR' via http."
fi
