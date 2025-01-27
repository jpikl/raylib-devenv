ARG BASE_DOCKER_IMAGE

FROM $BASE_DOCKER_IMAGE

# =============================================================================
# System packages
# =============================================================================

ARG JDK_VERSION=24

ENV JAVA_HOME=/usr/lib/jvm/java-$JDK_VERSION-openjdk-amd64

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
        ed \
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
ARG RAYGUI_VERSION=4.0

# We build raylib + raygui together into a single static library.
# Building separate static libraries (as Odin vendor package expects) is too much complicated.
RUN git clone --depth 1 --branch "$RAYLIB_VERSION" https://github.com/raysan5/raylib.git /tmp/raylib && \
    git clone --depth 1 --branch "$RAYGUI_VERSION" https://github.com/raysan5/raygui.git /tmp/raygui && \
    cd /tmp/raylib/src && \
    # ARM 32
    make clean && \
    make PLATFORM=PLATFORM_ANDROID ANDROID_ARCH=arm RAYLIB_MODULE_RAYGUI=TRUE && \
    make install PLATFORM=PLATFORM_ANDROID RAYLIB_INSTALL_PATH=$ODIN_ROOT/vendor/raylib/android/arm && \
    # ARM 64
    make clean && \
    make PLATFORM=PLATFORM_ANDROID ANDROID_ARCH=arm64 RAYLIB_MODULE_RAYGUI=TRUE && \
    make install PLATFORM=PLATFORM_ANDROID RAYLIB_INSTALL_PATH=$ODIN_ROOT/vendor/raylib/android/arm64 && \
    # x86
    make clean && \
    make PLATFORM=PLATFORM_ANDROID ANDROID_ARCH=x86 RAYLIB_MODULE_RAYGUI=TRUE && \
    make install PLATFORM=PLATFORM_ANDROID RAYLIB_INSTALL_PATH=$ODIN_ROOT/vendor/raylib/android/x86 && \
    # x86_64
    make clean && \
    make PLATFORM=PLATFORM_ANDROID ANDROID_ARCH=x86_64 RAYLIB_MODULE_RAYGUI=TRUE && \
    make install PLATFORM=PLATFORM_ANDROID RAYLIB_INSTALL_PATH=$ODIN_ROOT/vendor/raylib/android/x86_64 && \
    # Get rid of the cloned repo
    rm -r /tmp/raylib /tmp/raygui

# =============================================================================
# Odin
# =============================================================================

COPY android_raylib.ed /tmp
COPY android_raygui.ed /tmp

# Patch odin raylib bindings to use our custom raylib build
RUN ed -s $ODIN_ROOT/vendor/raylib/raylib.odin </tmp/android_raylib.ed && \
    ed -s $ODIN_ROOT/vendor/raylib/raygui.odin </tmp/android_raygui.ed && \
    rm /tmp/android_raylib.ed && \
    rm /tmp/android_raygui.ed
