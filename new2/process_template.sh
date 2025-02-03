#!/usr/bin/env bash

set -euo pipefail

INPUT=$1
OUTPUT=$2
shift 2

EXPR=""

for ITEM; do
    if [[ "$EXPR" ]]; then
        EXPR+=";"
    fi
    # 1. Escape special characters in 'X=Y'
    # 2. Turn 'X=Y' into sed replacement expression 's/{{ X }}/Y/g'
    EXPR+=$(echo "$ITEM" | sed -Ee 's/[]\/$*.^[]/\\&/g;s|^(.*)=(.*)$|s/{{\\s*\1\\s*}}/\2/g|')
done

sed -e "$EXPR" "$INPUT" >"$OUTPUT"
