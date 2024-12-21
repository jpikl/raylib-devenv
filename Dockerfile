FROM ubuntu:24.10

# This can be used by scripts to detect whether we are in containerized environment or not.
ENV INSIDE_RAYLIB_DEVENV=1

# =============================================================================
# System packages
# =============================================================================

ARG JDK_VERSION=24

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
        # To download files (odin)
        curl \
        ca-certificates \
        # Linker needed by odin
        clang \
        # To clone project repos (Emscripten SDK, raylib)
        git \
        # To run Emscripten SDK
        python3 \
        # For Android development
        openjdk-$JDK_VERSION-jdk-headless \
        sdkmanager \
        # To build raylib https://github.com/raysan5/raylib/wiki/Working-on-GNU-Linux
        build-essential \
        libasound2-dev \
        libx11-dev \
        libxrandr-dev \
        libxi-dev \
        libgl1-mesa-dev \
        libglu1-mesa-dev \
        libxcursor-dev \
        libxinerama-dev \
        libwayland-dev \
        libxkbcommon-dev \
        && \
    # Clean apt cache to reduce image size
    rm -rf /var/lib/apt/lists/*

# =============================================================================
# Emscripten SDK
# =============================================================================

ARG EMSDK_VERSION=3.1.74

RUN git clone --depth 1 https://github.com/emscripten-core/emsdk.git /opt/emsdk && \
    cd /opt/emsdk && \
    ./emsdk install "$EMSDK_VERSION" && \
    ./emsdk activate "$EMSDK_VERSION"

# =============================================================================
# Android SDK
# =============================================================================

ARG ANDROID_PLATFORM_VERSION=35
ARG ANDROID_BUILD_TOOLS_VERSION=35.0.0
ARG ANDROID_NDK_VERSION=27.2.12479018

RUN sdkmanager --install "platforms;android-$ANDROID_PLATFORM_VERSION" && \
    sdkmanager --install "build-tools;$ANDROID_BUILD_TOOLS_VERSION" && \
    sdkmanager --install "ndk;$ANDROID_NDK_VERSION"

ENV ANDROID_SDK_DIR=/opt/android-sdk
ENV ANDROID_NDK_DIR=/opt/android-sdk/ndk/$ANDROID_NDK_VERSION
ENV ANDROID_BUILD_TOOLS_DIR=/opt/android-sdk/build-tools/$ANDROID_BUILD_TOOLS_VERSION
ENV ANDROID_PLATFORM_DIR=/opt/android-sdk/platforms/android-$ANDROID_PLATFORM_VERSION
ENV ANDROID_PLATFORM_VERSION=$ANDROID_PLATFORM_VERSION

# =============================================================================
# Raylib
# =============================================================================

ARG RAYLIB_VERSION=5.5

RUN git clone --depth 1 --branch "$RAYLIB_VERSION" https://github.com/raysan5/raylib.git /tmp/raylib && \
    cd /tmp/raylib/src && \
    # Linux X11 static
    make clean && \
    make PLATFORM=PLATFORM_DESKTOP && \
    make install PLATFORM=PLATFORM_DESKTOP RAYLIB_INSTALL_PATH=/usr/local/lib/raylib/linux-x11-static && \
    # Linux X11 shared
    make clean && \
    make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED && \
    make install PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED RAYLIB_INSTALL_PATH=/usr/local/lib/raylib/linux-x11-shared && \
    # Linux Wayland static
    make clean && \
    make PLATFORM=PLATFORM_DESKTOP GLFW_LINUX_ENABLE_WAYLAND=TRUE GLFW_LINUX_ENABLE_X11=FALSE && \
    make install PLATFORM=PLATFORM_DESKTOP  RAYLIB_INSTALL_PATH=/usr/local/lib/raylib/linux-wayland-static && \
    # Linux Wayland shared
    make clean && \
    make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED GLFW_LINUX_ENABLE_WAYLAND=TRUE GLFW_LINUX_ENABLE_X11=FALSE && \
    make install PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED RAYLIB_INSTALL_PATH=/usr/local/lib/raylib/linux-wayland-shared && \
    # Web
    make clean && \
    bash -c 'source /opt/emsdk/emsdk_env.sh && make PLATFORM=PLATFORM_WEB' && \
    make install PLATFORM=PLATFORM_WEB RAYLIB_INSTALL_PATH=/usr/local/lib/raylib/web && \
    # Android armeabi-v7a
    make clean && \
    make PLATFORM=PLATFORM_ANDROID ANDROID_NDK=$ANDROID_NDK_DIR ANDROID_API_VERSION=$ANDROID_PLATFORM_VERSION ANDROID_ARCH=arm && \
    make install PLATFORM=PLATFORM_ANDROID RAYLIB_INSTALL_PATH=/usr/local/lib/raylib/android-armeabi-v7a && \
    # Android arm64-v8a
    make clean && \
    make PLATFORM=PLATFORM_ANDROID ANDROID_NDK=$ANDROID_NDK_DIR ANDROID_API_VERSION=$ANDROID_PLATFORM_VERSION ANDROID_ARCH=arm64 && \
    make install PLATFORM=PLATFORM_ANDROID RAYLIB_INSTALL_PATH=/usr/local/lib/raylib/android-arm64-v8a && \
    # Android x86
    make clean && \
    make PLATFORM=PLATFORM_ANDROID ANDROID_NDK=$ANDROID_NDK_DIR ANDROID_API_VERSION=$ANDROID_PLATFORM_VERSION ANDROID_ARCH=x86 && \
    make install PLATFORM=PLATFORM_ANDROID RAYLIB_INSTALL_PATH=/usr/local/lib/raylib/android-x86 && \
    # Android x86_64
    make clean && \
    make PLATFORM=PLATFORM_ANDROID ANDROID_NDK=$ANDROID_NDK_DIR ANDROID_API_VERSION=$ANDROID_PLATFORM_VERSION ANDROID_ARCH=x86_64 && \
    make install PLATFORM=PLATFORM_ANDROID RAYLIB_INSTALL_PATH=/usr/local/lib/raylib/android-x86_64 && \
    # Get rid of the cloned repo
    rm -r /tmp/raylib

# =============================================================================
# Odin language
# =============================================================================

ARG ODIN_VERSION=dev-2024-12
ARG ODIN_ARCHIVE=odin-linux-amd64-$ODIN_VERSION.tar.gz
ARG ODIN_URL=https://github.com/odin-lang/Odin/releases/download/$ODIN_VERSION/$ODIN_ARCHIVE

RUN mkdir -p /opt/odin && \
    curl --location --output "/tmp/$ODIN_ARCHIVE" "$ODIN_URL" && \
    tar xf "/tmp/$ODIN_ARCHIVE" --strip-components=1 --directory=/opt/odin && \
    rm "/tmp/$ODIN_ARCHIVE"

ENV PATH=$PATH:/opt/odin

# =============================================================================
# Entrypoint
# =============================================================================

COPY entrypoint.sh /usr/local/bin/entrypoint

ENTRYPOINT ["entrypoint"]

CMD ["bash"]
