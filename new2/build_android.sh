#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(dirname "$0")

source "$ROOT_DIR/common.sh"
source "$ROOT_DIR/common_build.sh"
source "$ROOT_DIR/common_odin.sh"
source "$ROOT_DIR/common_android.sh"

ANDROID_HOME=${ANDROID_HOME-}
ANDROID_API_VERSION=${ANDROID_API_VERSION-}

if [[ ! ${ANDROID_PLATFORM:=} && ${ANDROID_API_VERSION-} ]]; then
    ANDROID_PLATFORM=$ANDROID_HOME/platforms/android-$ANDROID_API_VERSION
fi

if [[ ! ${ANDROID_PLATFORM_TOOLS:=} ]]; then
    ANDROID_PLATFORM_TOOLS=$ANDROID_HOME/platform-tools
fi

if [[ ! ${ANDROID_BUILD_TOOLS:=} && ${ANDROID_BUILD_TOOLS_VERSION-} ]]; then
    ANDROID_BUILD_TOOLS=$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION
fi

if [[ ! ${ANDROID_NDK:=} && ${ANDROID_NDK_VERSION-} ]]; then
    ANDROID_NDK=$ANDROID_HOME/ndk/$ANDROID_NDK_VERSION
fi

ANDROID_TOOLCHAIN=${ANDROID_TOOLCHAIN:-"$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64"}

if [[ ! -v ANDROID_ABIS[@] ]]; then
    # odin build fails for armeabi-v7a due to some weird LLVM error
    # ANDROID_ABIS=(arm64-v8a armeabi-v7a x86 x86_64)
    ANDROID_ABIS=(arm64-v8a x86 x86_64)
fi

ANDROID_MIN_SDK_VERSION=${ANDROID_MIN_SDK_VERSION:-"29"}
ANDROID_TARGET_SDK_VERSION=${ANDROID_TARGET_SDK_VERSION:-"$ANDROID_API_VERSION"}

JAVA_TARGET_VERSION=11

check_var_is_dir ANDROID_HOME
check_var_is_set ANDROID_API_VERSION
check_var_is_dir ANDROID_PLATFORM
check_var_is_dir ANDROID_PLATFORM_TOOLS
check_var_is_dir ANDROID_BUILD_TOOLS
check_var_is_dir ANDROID_NDK
check_var_is_dir ANDROID_TOOLCHAIN

print_var ANDROID_HOME
print_var ANDROID_API_VERSION
print_var ANDROID_PLATFORM
print_var ANDROID_PLATFORM_TOOLS
print_var ANDROID_BUILD_TOOLS
print_var ANDROID_NDK
print_var ANDROID_TOOLCHAIN
print_arr ANDROID_ABIS

print_var ANDROID_MIN_SDK_VERSION
print_var ANDROID_TARGET_SDK_VERSION

check_var_is_file ANDROID_MANIFEST
check_var_is_file ANDROID_ICON

# Keystore configuration
KEYSTORE_FILE=${KEYSTORE_FILE:-".keystore"}
KEYSTORE_DAYS=${KEYSTORE_DAYS:-1000}
KEYSTORE_ALIAS=${KEYSTORE_ALIAS:-$APP_CODE}
KEYSTORE_PASS=${KEYSTORE_PASS:-"$APP_CODE-123456"} # Must be at leas 6 characters

# Keystore distinguished name attributes
# See https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ldap/distinguished-names
KEYSTORE_COMMON_NAME=${KEYSTORE_COMMON_NAME:-$APP_CODE}

check_var_is_set KEYSTORE_FILE
check_var_is_set KEYSTORE_DAYS
check_var_is_set KEYSTORE_PASS
check_var_is_set KEYSTORE_ALIAS
check_var_is_set KEYSTORE_COMMON_NAME

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
    -lraylib
    -lm
)

run mkdir -p "$ANDROID_OUT_DIR/obj"

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

    run mkdir -p "$ANDROID_OUT_DIR/raw/lib/$ABI"

    run "$ODIN" build "$SRC_DIR" "${ODIN_FLAGS[@]}" -target:"$ODIN_TARGET" -out:"$ANDROID_OUT_DIR/obj/$ABI.o"

    run "$ANDROID_TOOLCHAIN/bin/${CC_PREFIX}$ANDROID_API_VERSION-clang" \
        "$ANDROID_OUT_DIR/obj/$ABI.o" -o "$ANDROID_OUT_DIR/raw/lib/$ABI/libmain.so" "${LDFLAGS[@]}" "${LDLIBS[@]}" \
            -L"$ODIN_ROOT/vendor/raylib/android/$RAYLIB_DIR"
done

# Export build tool binaries
export PATH=$PATH:$ANDROID_BUILD_TOOLS

run mkdir -p "$ANDROID_OUT_DIR/java/$ANDROID_PACKAGE_DIR"
run mkdir -p "$ANDROID_OUT_DIR/classes/$ANDROID_PACKAGE_DIR"

"$ROOT_DIR/process_template.sh" "$ANDROID_MANIFEST" "$ANDROID_OUT_DIR/AndroidManifest.xml" \
    LABEL="$ANDROID_LABEL" \
    VERSION_CODE="$ANDROID_VERSION_CODE" \
    VERSION_NAME="$ANDROID_VERSION_NAME" \
    PACKAGE="$ANDROID_PACKAGE" \
    MIN_SDK_VERSION="$ANDROID_MIN_SDK_VERSION" \
    TARGET_SDK_VERSION="$ANDROID_TARGET_SDK_VERSION" \
    ORIENTATION="$ANDROID_ORIENTATION"

"$ROOT_DIR/process_template.sh" "$ROOT_DIR/android/MainActivity.java" "$ANDROID_OUT_DIR/java/$ANDROID_PACKAGE_DIR/MainActivity.java" \
    PACKAGE="$ANDROID_PACKAGE" \

# Compile java source files to classes
run javac \
    -verbose \
    --release "$JAVA_TARGET_VERSION" \
    -d "$ANDROID_OUT_DIR/classes" \
    -classpath "out:$ANDROID_PLATFORM/android.jar" \
    -sourcepath "$ANDROID_OUT_DIR/java" \
    "$ANDROID_OUT_DIR/java/$ANDROID_PACKAGE_DIR/MainActivity.java"

# Compile classes to dex
run d8 \
    --release \
    --output "$ANDROID_OUT_DIR/raw" \
    --lib "$ANDROID_PLATFORM/android.jar" \
    "$ANDROID_OUT_DIR/classes/$ANDROID_PACKAGE_DIR/MainActivity.class"

run mkdir -p "$ANDROID_OUT_DIR/res/drawable-ldpi"
run mkdir -p "$ANDROID_OUT_DIR/res/drawable-mdpi"
run mkdir -p "$ANDROID_OUT_DIR/res/drawable-hdpi"
run mkdir -p "$ANDROID_OUT_DIR/res/drawable-xhdpi"
run mkdir -p "$ANDROID_OUT_DIR/res/drawable-xxhdpi"
run mkdir -p "$ANDROID_OUT_DIR/res/drawable-xxxhdpi"

run convert "$ANDROID_ICON" -resize 36x36 "$ANDROID_OUT_DIR/res/drawable-ldpi/icon.png"
run convert "$ANDROID_ICON" -resize 48x48 "$ANDROID_OUT_DIR/res/drawable-mdpi/icon.png"
run convert "$ANDROID_ICON" -resize 72x72 "$ANDROID_OUT_DIR/res/drawable-hdpi/icon.png"
run convert "$ANDROID_ICON" -resize 96x96 "$ANDROID_OUT_DIR/res/drawable-xhdpi/icon.png"
run convert "$ANDROID_ICON" -resize 144x144 "$ANDROID_OUT_DIR/res/drawable-xxhdpi/icon.png"
run convert "$ANDROID_ICON" -resize 192x192 "$ANDROID_OUT_DIR/res/drawable-xxxhdpi/icon.png"

# Bundle APK
run aapt package \
    -f \
    -A "$ASSETS_DIR" \
    -I "$ANDROID_PLATFORM/android.jar" \
    -S "$ANDROID_OUT_DIR/res" \
    -M "$ANDROID_OUT_DIR/AndroidManifest.xml" \
    -F "$ANDROID_OUT_DIR/$APP_CODE.unaligned.apk" \
    "$ANDROID_OUT_DIR/raw"

# Zipalign APK
run zipalign -p -f 4 "$ANDROID_OUT_DIR/$APP_CODE.unaligned.apk" "$ANDROID_OUT_DIR/$APP_CODE.unsigned.apk"

# Setup keystore if not already done
if [ ! -f "$KEYSTORE_FILE" ]; then
    run keytool -genkeypair \
                -validity "$KEYSTORE_DAYS" \
                -dname "CN=$KEYSTORE_COMMON_NAME" \
                -keystore "$KEYSTORE_FILE" \
                -storepass "$KEYSTORE_PASS" \
                -keypass "$KEYSTORE_PASS" \
                -alias "$KEYSTORE_ALIAS" \
                -keyalg RSA
fi

# Sign APK
run apksigner sign \
    --ks "$KEYSTORE_FILE" \
    --ks-pass "pass:$KEYSTORE_PASS" \
    --ks-key-alias "$KEYSTORE_ALIAS" \
    --out "$ANDROID_OUT_DIR/$APP_CODE.apk" \
    "$ANDROID_OUT_DIR/$APP_CODE.unsigned.apk"

if [[ "${1-}" == -r ]]; then
    "$ROOT_DIR/run_android.sh"
fi
