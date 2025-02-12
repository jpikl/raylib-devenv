#!/usr/bin/env bash

set -eu

SCRIPTS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

source "$SCRIPTS_DIR/config_base.sh"

# ================================================================================
# Runtime
# ================================================================================

CASES=()
RESULTS=()

header() {
    echo
    info "================================================================================"
    info " $1"
    info "================================================================================"
    echo
}

index_to_case_id() {
    printf "TC-%02d" $(($1 + 1))
}

assert() {
    INDEX=${#CASES[@]}
    ID=$(index_to_case_id "$INDEX")
    header "[$ID] $1"

    RESULT=0
    sh -c "$1" || RESULT=$?

    CASES+=("$1")
    RESULTS+=("$RESULT")
}

cd "$SCRIPTS_DIR/example"

# ================================================================================
# Linux
# ================================================================================

assert "../build_linux_image.sh"
assert "../build_linux_dockerized.sh"
assert "test -x out/linux/raylib-app"
assert "test -f out/linux/assets/coin.wav"
assert "test -f out/linux/assets/raylib.png"

# ================================================================================
# Windows
# ================================================================================

assert "../build_windows_image.sh"
assert "../build_windows_dockerized.sh"
assert "test -x out/windows/raylib-app.exe"
assert "test -f out/windows/assets/coin.wav"
assert "test -f out/windows/assets/raylib.png"

# ================================================================================
# Web
# ================================================================================

assert "../build_web_image.sh"
assert "../build_web_dockerized.sh"
assert "test -f out/web/index.data"
assert "test -f out/web/index.html"
assert "test -f out/web/index.js"
assert "test -f out/web/index.wasm"

# ================================================================================
# Android
# ================================================================================

assert "../build_android_image.sh"
assert "../build_android_dockerized.sh"
assert "test -f out/android/raylib-app.apk"

# ================================================================================
# Clean
# ================================================================================

assert "../clean.sh"
assert "test ! -e out"

# ================================================================================
# Results
# ================================================================================

header "TEST RESULTS"

FINAL_RESULT=0

for INDEX in "${!CASES[@]}"; do
    ID=$(index_to_case_id "$INDEX")
    CASE=${CASES[$INDEX]}
    RESULT=${RESULTS[$INDEX]}

    if [[ $RESULT -eq 0 ]]; then
        success "$ID [OK] $CASE"
    else
        error "$ID [ERR] $CASE"
        FINAL_RESULT=1
    fi
done

exit $FINAL_RESULT
