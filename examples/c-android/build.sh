#!/usr/bin/env sh
# shellcheck disable=SC2086

# See https://github.com/raysan5/raylib-game-template/blob/main/src/Makefile.Android

set -eu

# Rerun itself in containerized environment if not already there
if [ ! "${INSIDE_RAYLIB_DEVENV-}" ]; then
    ROOT_DIR=$(dirname "$0")/../..
    SCRIPT_PATH=$(realpath --relative-to "$ROOT_DIR" "$0")
    MOUNT_DIR=$ROOT_DIR exec "$ROOT_DIR/run.sh" "$SCRIPT_PATH"
fi

# Execute all commands relative to this script directory
cd "$(dirname -- "$0")"

# To see what commands are being executed
set -x

# Clean output directory
rm -rf out
mkdir -p out

# Keystore configuration
KEYSTORE_FILE=example.keystore
KEYSTORE_PASS=example # This should not be saved in Git in real project!
KEYSTORE_DAYS=1000
KEYSTORE_ALIAS=exampleKey

# Keystore distinguished name attributes
# See https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ldap/distinguished-names
KEYSTORE_COMMON_NAME=example.com
KEYSTORE_COUNTRY=US

# Setup keystore if not already done
if [ ! -f "$KEYSTORE_FILE" ]; then
    keytool -genkeypair \
            -validity "$KEYSTORE_DAYS" \
            -dname "CN=$KEYSTORE_COMMON_NAME,C=$KEYSTORE_COUNTRY" \
            -keystore "$KEYSTORE_FILE" \
            -storepass "$KEYSTORE_PASS" \
            -keypass "$KEYSTORE_PASS" \
            -alias "$KEYSTORE_ALIAS" \
            -keyalg RSA
fi

# Supported ABIs
ABIS="arm64-v8a armeabi-v7a x86 x86_64"

for ABI in $ABIS; do
    case "$ABI" in
        "armeabi-v7a")
            CC_TYPE="armv7a-linux-androideabi"
            ABI_FLAGS="-std=c99 -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
            ;;

        "arm64-v8a")
            CC_TYPE="aarch64-linux-android"
            ABI_FLAGS="-std=c99 -march=armv8-a -mfix-cortex-a53-835769"
            ;;

        "x86")
            CC_TYPE="i686-linux-android"
            ABI_FLAGS=""
            ;;

        "x86_64")
            CC_TYPE="x86_64-linux-android"
            ABI_FLAGS=""
            ;;
    esac

    # NDK toolchain binaries
    CC="$ANDROID_TOOLCHAIN/bin/${CC_TYPE}$ANDROID_API_VERSION-clang"

    # Prepare output directories
    mkdir -p "out/obj/$ABI"
    mkdir -p "out/lib/$ABI"

    # Compile project
    $CC -c main.c \
        -o "out/obj/$ABI/main.o" \
        -I"$RAYLIB_INCLUDE_PATH" \
        --sysroot="$ANDROID_TOOLCHAIN/sysroot"  \
        -ffunction-sections -funwind-tables -fstack-protector-strong -fPIC \
        -Wall -Wa,--noexecstack -Wformat -Werror=format-security -no-canonical-prefixes \
        -D__ANDROID__ -DPLATFORM_ANDROID -D__ANDROID_API__=$ANDROID_API_VERSION \
        $ABI_FLAGS

    # Link project
    "$CC" "out/obj/$ABI"/main.o  \
        -o "out/lib/$ABI/libmain.so" \
        -L"$RAYLIB_LIB_PATH/android-$ABI" \
        -Wl,-soname,libmain.so -Wl,--exclude-libs,libatomic.a \
        -Wl,--build-id -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -Wl,--warn-shared-textrel -Wl,--fatal-warnings \
        -u ANativeActivity_onCreate \
        -lm -lc -lraylib -llog -landroid -lEGL -lGLESv2 -lOpenSLES -ldl \
        -shared
done

# Export build tool binaries
export PATH=$PATH:$ANDROID_BUILD_TOOLS

# Generate resources `R.java` file
aapt package \
    -fm \
    -S res \
    -J java \
    -M AndroidManifest.xml \
    -I "$ANDROID_PLATFORM/android.jar"

# Compile java source files to classes
javac \
    -verbose \
    --release 11 \
    -d out/class \
    -classpath "out:$ANDROID_PLATFORM/android.jar" \
    -sourcepath java \
    java/com/example/*.java

# Prepare output directories
mkdir out/dex out/apk

# Compile classes to dex
d8 \
    --release \
    --output out/dex \
    --lib "$ANDROID_PLATFORM/android.jar" \
    out/class/com/example/*.class

# TODO --min-sdk-version VAL] [--target-sdk-version VAL] [--app-version VAL] [--app-version-name TEXT]  [--rename-manifest-package PACKAGE] [--error-on-failed-insert]
# Bundle APK
aapt package \
    -f \
    -S res \
    -M AndroidManifest.xml \
    -A ../common/assets \
    -I "$ANDROID_PLATFORM/android.jar" \
    -F out/apk/game.unaligned.apk \
    out/dex

# Add libraries to APK
for ABI in $ABIS; do
    # Run in the output dir, so we create `lib/..` paths inside APK instead of `out/lib/...`
	(cd out && aapt add apk/game.unaligned.apk "lib/$ABI/libmain.so")
done

# Zipalign APK
zipalign -p -f 4 out/apk/game.unaligned.apk out/apk/game.unsigned.apk

# Sign APK
apksigner sign \
    --ks "$KEYSTORE_FILE" \
    --ks-pass pass:$KEYSTORE_PASS \
    --ks-key-alias "$KEYSTORE_ALIAS" \
    --out out/apk/game.apk \
    out/apk/game.unsigned.apk
