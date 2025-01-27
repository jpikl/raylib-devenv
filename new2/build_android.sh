#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

source "$ROOT_DIR/common.sh"
source "$ROOT_DIR/common_build.sh"
source "$ROOT_DIR/common_odin.sh"
source "$ROOT_DIR/common_android.sh"

# Keystore configuration
KEYSTORE_FILE=${KEYSTORE_FILE:-".keystore"}
KEYSTORE_DAYS=${KEYSTORE_DAYS:-1000}
KEYSTORE_ALIAS=${KEYSTORE_ALIAS:-$APP_CODE}

# Keystore distinguished name attributes
# See https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ldap/distinguished-names
KEYSTORE_COMMON_NAME=${KEYSTORE_COMMON_NAME:-$APP_CODE}
KEYSTORE_COUNTRY=${KEYSTORE_COUNTRY:-US}

check_var_is_set KEYSTORE_FILE
check_var_is_set KEYSTORE_DAYS
check_var_is_set KEYSTORE_PASS
check_var_is_set KEYSTORE_ALIAS
check_var_is_set KEYSTORE_COMMON_NAME
check_var_is_set KEYSTORE_COUNTRY

check_var_is_dir SRC_DIR

run rm -rf "$ANDROID_OUT_DIR"
run mkdir -p "$ANDROID_OUT_DIR"

ODIN_FLAGS+=(
    -build-mode:obj
    -reloc-mode:pic
    -define:IS_ANDROID=true
)

LDFLAGS=(
    -shared
    -u ANativeActivity_onCreate
)

LDLIBS=(
    -landroid
    -llog
    -lEGL
    -lGLESv3
    -lm
)

for ABI in "${ANDROID_ABIS[@]}"; do
    case "$ABI" in
        x86)
            ODIN_TARGET=linux_i386
            CC_PREFIX="i686-linux-android"
            RAYLIB_DIR=x86
            ;;

        x86_64)
            ODIN_TARGET=linux_amd64
            CC_PREFIX="x86_64-linux-android"
            RAYLIB_DIR=x86_64

            ;;

        armeabi-v7a)
            ODIN_TARGET=linux_arm32
            CC_PREFIX="armv7a-linux-androideabi"
            RAYLIB_DIR=arm
            ;;

        arm64-v8a)
            ODIN_TARGET=linux_arm64
            CC_PREFIX="aarch64-linux-android"
            RAYLIB_DIR=arm64
            ;;
    esac

    run "$ODIN" build "$SRC_DIR" "${ODIN_FLAGS[@]}" -target:"$ODIN_TARGET" -out:"$ANDROID_OUT_DIR/$APP_CODE.$ABI.o"

    run mkdir -p "$ANDROID_OUT_DIR/lib/$ABI"

    run "$ANDROID_TOOLCHAIN/bin/${CC_PREFIX}$ANDROID_API_VERSION-clang" \
        "$ANDROID_OUT_DIR/$APP_CODE.$ABI.o" -o "$ANDROID_OUT_DIR/lib/$ABI/libmain.so" "${LDFLAGS[@]}" "${LDLIBS[@]}" \
            -L"$ODIN_ROOT/vendor/raylib/android/$RAYLIB_DIR" -lraylib

    run rm "$ANDROID_OUT_DIR/$APP_CODE.$ABI.o"
done

# Setup keystore if not already done
if [ ! -f "$KEYSTORE_FILE" ]; then
    run keytool -genkeypair \
                -validity "$KEYSTORE_DAYS" \
                -dname "CN=$KEYSTORE_COMMON_NAME,C=$KEYSTORE_COUNTRY" \
                -keystore "$KEYSTORE_FILE" \
                -storepass "$KEYSTORE_PASS" \
                -keypass "$KEYSTORE_PASS" \
                -alias "$KEYSTORE_ALIAS" \
                -keyalg RSA
fi

# Export build tool binaries
export PATH=$PATH:$ANDROID_BUILD_TOOLS

# Generate resources `R.java` file
run aapt package \
    -fm \
    -S res \
    -J java \
    -M AndroidManifest.xml \
    -I "$ANDROID_PLATFORM/android.jar"

# Compile java source files to classes
run javac \
    -verbose \
    --release 11 \
    -d "$ANDROID_OUT_DIR" \
    -classpath "out:$ANDROID_PLATFORM/android.jar" \
    -sourcepath java \
    java/com/example/*.java

# Compile classes to dex
run d8 \
    --release \
    --output "$ANDROID_OUT_DIR" \
    --lib "$ANDROID_PLATFORM/android.jar" \
    "$ANDROID_OUT_DIR"/com/example/*.class

# Bundle APK
run aapt package \
    -f \
    -S res \
    -M AndroidManifest.xml \
    -A "$ASSETS_DIR" \
    -I "$ANDROID_PLATFORM/android.jar" \
    -F "$ANDROID_OUT_DIR/game.unaligned.apk" \
    --min-sdk-version 29 \
    --target-sdk-version "$ANDROID_API_VERSION" \
    --version-code 1 \
    --version-name 1.0 \
    --error-on-failed-insert \
    "$ANDROID_OUT_DIR"

# Add libraries to APK
# for ABI in "${ANDROID_ABIS[@]}"; do
#     # Run in the output dir, so we create `lib/..` paths inside APK instead of `out/lib/...`
# 	(run cd "$ANDROID_OUT_DIR" && run aapt add "game.unaligned.apk" "lib/$ABI/libmain.so")
# done

# Zipalign APK
run zipalign -p -f 4 "$ANDROID_OUT_DIR/game.unaligned.apk" "$ANDROID_OUT_DIR/game.unsigned.apk"

# Sign APK
run apksigner sign \
    --ks "$KEYSTORE_FILE" \
    --ks-pass "pass:$KEYSTORE_PASS" \
    --ks-key-alias "$KEYSTORE_ALIAS" \
    --out "$ANDROID_OUT_DIR/game.apk" \
    "$ANDROID_OUT_DIR/game.unsigned.apk"

if [[ "${1-}" == -r ]]; then
    "$ROOT_DIR/run_android.sh"
fi
