#!/usr/bin/env sh
# shellcheck disable=SC2086

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
            -alias projectKey \
            -keyalg RSA
fi

# Supported ABIs
ABIS="arm64-v8a armeabi-v7a x86 x86_64"

for ABI in $ABIS; do
    case "$ABI" in
        "armeabi-v7a")
            ARCH="arm"
            CC_TYPE="armv7a-linux-androideabi"
            LIB_PATH="arm-linux-androideabi"
            ABI_FLAGS="-std=c99 -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
            ;;

        "arm64-v8a")
            ARCH="aarch64"
            CC_TYPE="aarch64-linux-android"
            LIB_PATH="aarch64-linux-android"
            ABI_FLAGS="-std=c99 -target aarch64 -mfix-cortex-a53-835769"
            ;;

        "x86")
            ARCH="i386"
            CC_TYPE="i686-linux-android"
            LIB_PATH="i686-linux-android"
            ABI_FLAGS=""
            ;;

        "x86_64")
            ARCH="x86_64"
            CC_TYPE="x86_64-linux-android"
            LIB_PATH="x86_64-linux-android"
            ABI_FLAGS=""
            ;;
    esac

    # NDK inner directories
    NDK_TOOLCHAIN_DIR=$ANDROID_NDK_DIR/toolchains/llvm/prebuilt/linux-x86_64
    NATIVE_APP_GLUE_C=$ANDROID_NDK_DIR/sources/android/native_app_glue/android_native_app_glue.c

    # NDK toolchain binaries
    CC="$NDK_TOOLCHAIN_DIR/bin/${CC_TYPE}$ANDROID_PLATFORM_VERSION-clang"
    LLD=$NDK_TOOLCHAIN_DIR/bin/ld.lld

    # Prepare output directories
    mkdir -p "out/lib/$ABI"

    # Compile project (and also native app glue)
    for FILE in main.c "$NATIVE_APP_GLUE_C"; do
        $CC -c "$FILE" \
            -o "out/lib/$ABI/$(basename "$FILE" .c).o" \
            -I/usr/local/include \
            -I"$NDK_TOOLCHAIN_DIR/sysroot/usr/include" \
            -I"$NDK_TOOLCHAIN_DIR/sysroot/usr/include/$CC_TYPE" \
            -ffunction-sections \
            -funwind-tables \
            -fstack-protector-strong \
            -fPIC \
            -Wall \
            -Wformat \
            -Werror=format-security \
            -no-canonical-prefixes \
            -DANDROID \
            -DPLATFORM_ANDROID \
            -D__ANDROID_API__="$ANDROID_PLATFORM_VERSION" \
            $ABI_FLAGS
    done

    # Link project (together with native app glue)
    "$LLD" "out/lib/$ABI"/*.o  \
        -o "out/lib/$ABI/libmain.so" \
        --shared \
        --exclude-libs libatomic.a \
        --build-id \
        -z noexecstack \
        -z relro \
        -z now \
        --warn-shared-textrel \
        --fatal-warnings \
        --undefined ANativeActivity_onCreate \
        -L"/usr/local/lib/raylib/android-$ABI" \
        -L"$NDK_TOOLCHAIN_DIR/sysroot/usr/lib/$LIB_PATH/$ANDROID_PLATFORM_VERSION" \
        -L"$NDK_TOOLCHAIN_DIR/lib/clang/18/lib/linux/$ARCH" \
        -lraylib \
        -llog \
        -landroid \
        -lEGL \
        -lGLESv2 \
        -lOpenSLES \
        -latomic \
        -lc \
        -lm \
        -ldl
done

# Build tool binaries
AAPT=$ANDROID_BUILD_TOOLS_DIR/aapt
D8=$ANDROID_BUILD_TOOLS_DIR/d8
ZIPALIGN=$ANDROID_BUILD_TOOLS_DIR/zipalign
APKSIGNER=$ANDROID_BUILD_TOOLS_DIR/apksigner

# Generate resources `R.java` file
"$AAPT" package \
    -fm \
    -S res \
    -J java \
    -M AndroidManifest.xml \
    -I "$ANDROID_PLATFORM_DIR/android.jar"

# Compile java source files to classes
javac \
    -source 1.8 \
    -target 1.8 \
    -d out/class \
    -bootclasspath jre/lib/rt.jar \
    -classpath "out:$ANDROID_PLATFORM_DIR/android.jar" \
    -sourcepath java \
    java/com/example/*.java

# Prepare output directories
mkdir out/dex out/apk

# Compile classes to dex
"$D8" --output out/dex out/class/com/example/*.class

# TODO --min-sdk-version VAL] [--target-sdk-version VAL] [--app-version VAL] [--app-version-name TEXT]  [--rename-manifest-package PACKAGE] [--error-on-failed-insert]
# Bundle APK
"$AAPT" package \
    -f \
    -S res \
    -M AndroidManifest.xml \
    -A ../common/assets \
    -I "$ANDROID_PLATFORM_DIR/android.jar" \
    -F out/apk/game.apk \
    out/dex

# Add libraries to APK
for ABI in $ABIS; do
    # Run in the output dir, so we create `lib/..` paths inside APK instead of `out/lib/...`
	(cd out && "$AAPT" add apk/game.apk "lib/$ABI/libmain.so")
done

# Zipalign APK
"$ZIPALIGN" -f 4 out/apk/game.apk out/apk/game.aligned.apk

# Sign APK
"$APKSIGNER" sign  \
    --ks "$KEYSTORE_FILE" \
    --ks-pass pass:$KEYSTORE_PASS \
    --out out/apk/game.signed.apk \
    out/apk/game.aligned.apk
