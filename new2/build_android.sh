#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

source "$ROOT_DIR/common.sh"
source "$ROOT_DIR/common_build.sh"
source "$ROOT_DIR/common_odin.sh"
source "$ROOT_DIR/common_android.sh"

check_var_is_dir SRC_DIR

run rm -rf "$ANDROID_OUT_DIR"
run mkdir -p "$ANDROID_OUT_DIR"

abi_to_odin_target() {
    case "$1" in
        x86) echo linux_i386 ;;
        x86_64) echo linux_amd64 ;;
        armeabi-v7a) echo linux_arm32 ;;
        arm64-v8a) echo linux_arm64 ;;
    esac
}

ODIN_FLAGS+=(
    -build-mode:obj
    -reloc-mode:pic
    -define:IS_ANDROID=true
)

for ABI in "${ANDROID_ABIS[@]}"; do
    run "$ODIN" build "$SRC_DIR" "${ODIN_FLAGS[@]}" -target:"$(abi_to_odin_target "$ABI")" -out:"$ANDROID_OUT_DIR/$APP_CODE.$ABI.o"
done

if [[ -d "$ASSETS_DIR" ]]; then
    run mkdir -p "$ANDROID_OUT_DIR/$ASSETS_DIR"
    run cp -rT "$ASSETS_DIR" "$ANDROID_OUT_DIR/$ASSETS_DIR"
else
    skip "No ASSETS_DIR='$ASSETS_DIR' to copy"
fi

#run rm "$ANDROID_OUT_DIR"/*.o

if [[ "${1-}" == -r ]]; then
    "$ROOT_DIR/run_android.sh"
fi
