ARG BASE_DOCKER_IMAGE

FROM $BASE_DOCKER_IMAGE

# =============================================================================
# System packages
# =============================================================================

ARG JDK_VERSION=24

ENV JAVA_HOME=/usr/lib/jvm/java-$JDK_VERSION-openjdk-amd64

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
        git \
        build-essential \
        openjdk-$JDK_VERSION-jdk-headless \
        sdkmanager \
        && \
    # Clean apt cache to reduce image size
    rm -rf /var/lib/apt/lists/*

# =============================================================================
# Android SDK
# =============================================================================

ARG ANDROID_API_VERSION=35
ARG ANDROID_BUILD_TOOLS_VERSION=35.0.0
ARG ANDROID_PLATFORM_TOOLS_VERSION=35.0.2
ARG ANDROID_NDK_VERSION=27.2.12479018

RUN sdkmanager --install "platforms;android-$ANDROID_API_VERSION" && \
    sdkmanager --install "build-tools;$ANDROID_BUILD_TOOLS_VERSION" && \
    sdkmanager --install "platform-tools;$ANDROID_PLATFORM_TOOLS_VERSION" && \
    sdkmanager --install "ndk;$ANDROID_NDK_VERSION"

ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_API_VERSION=$ANDROID_API_VERSION
ENV ANDROID_PLATFORM=$ANDROID_HOME/platforms/android-$ANDROID_API_VERSION
ENV ANDROID_PLATFORM_TOOLS=$ANDROID_HOME/platform-tools
ENV ANDROID_BUILD_TOOLS=$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION
ENV ANDROID_NDK=$ANDROID_HOME/ndk/$ANDROID_NDK_VERSION
ENV ANDROID_TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64

# =============================================================================
# Raylib
# =============================================================================

ARG RAYLIB_VERSION=5.5

ENV RAYLIB_INCLUDE_PATH=/usr/local/include
ENV RAYLIB_LIB_PATH=/usr/local/lib/raylib

RUN git clone --depth 1 --branch "$RAYLIB_VERSION" https://github.com/raysan5/raylib.git /tmp/raylib && \
    cd /tmp/raylib/src && \
    # Android armeabi-v7a
    make clean && \
    make PLATFORM=PLATFORM_ANDROID ANDROID_ARCH=arm && \
    make install PLATFORM=PLATFORM_ANDROID RAYLIB_INSTALL_PATH=$RAYLIB_LIB_PATH/android-armeabi-v7a && \
    # Android arm64-v8a
    make clean && \
    make PLATFORM=PLATFORM_ANDROID ANDROID_ARCH=arm64 && \
    make install PLATFORM=PLATFORM_ANDROID RAYLIB_INSTALL_PATH=$RAYLIB_LIB_PATH/android-arm64-v8a && \
    # Android x86
    make clean && \
    make PLATFORM=PLATFORM_ANDROID ANDROID_ARCH=x86 && \
    make install PLATFORM=PLATFORM_ANDROID RAYLIB_INSTALL_PATH=$RAYLIB_LIB_PATH/android-x86 && \
    # Android x86_64
    make clean && \
    make PLATFORM=PLATFORM_ANDROID ANDROID_ARCH=x86_64 && \
    make install PLATFORM=PLATFORM_ANDROID RAYLIB_INSTALL_PATH=$RAYLIB_LIB_PATH/android-x86_64 && \
    # Get rid of the cloned repo
    rm -r /tmp/raylib
