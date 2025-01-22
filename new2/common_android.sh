# shellcheck shell=bash

ANDROID_OUT_DIR=${ANDROID_OUT_DIR:-"$OUT_DIR/android"}
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

check_var_is_dir ANDROID_HOME
check_var_is_set ANDROID_API_VERSION
check_var_is_dir ANDROID_PLATFORM
check_var_is_dir ANDROID_PLATFORM_TOOLS
check_var_is_dir ANDROID_BUILD_TOOLS
check_var_is_dir ANDROID_NDK
check_var_is_dir ANDROID_TOOLCHAIN

print_var ANDROID_OUT_DIR
print_var ANDROID_HOME
print_var ANDROID_API_VERSION
print_var ANDROID_PLATFORM
print_var ANDROID_PLATFORM_TOOLS
print_var ANDROID_BUILD_TOOLS
print_var ANDROID_NDK
print_var ANDROID_TOOLCHAIN
print_arr ANDROID_ABIS
