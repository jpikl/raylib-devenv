FROM ubuntu:24.10

# This can be used by scripts to detect whether we are in containerized environment or not.
ENV INSIDE_RAYLIB_DEVENV=1

# =============================================================================
# System packages
# =============================================================================

ARG JDK_VERSION=24

ENV JAVA_HOME=/usr/lib/jvm/java-$JDK_VERSION-openjdk-amd64

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
        # To download files (Odin)
        curl \
        ca-certificates \
        # To extract files (Raylib for Windows)
        unzip \
        # Linker needed by Odin
        clang \
        # To clone project repos (Emscripten, Raylib)
        git \
        # To run Emscripten
        python3 \
        # For Android development
        openjdk-$JDK_VERSION-jdk-headless \
        sdkmanager \
        # To build Raylib https://github.com/raysan5/raylib/wiki/Working-on-GNU-Linux
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
        # For cross compiling to Windows
        mingw-w64 \
        gcc-mingw-w64 \
        && \
    # Clean apt cache to reduce image size
    rm -rf /var/lib/apt/lists/*

# =============================================================================
# Emscripten SDK
# =============================================================================

ARG EMSDK_VERSION=3.1.74

ENV EMSDK_HOME=/opt/emsdk

RUN git clone --depth 1 https://github.com/emscripten-core/emsdk.git "$EMSDK_HOME" && \
    cd "$EMSDK_HOME" && \
    ./emsdk install "$EMSDK_VERSION" && \
    ./emsdk activate "$EMSDK_VERSION"

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
ENV ANDROID_NDK=$ANDROID_HOME/ndk/$ANDROID_NDK_VERSION
ENV ANDROID_TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64
ENV ANDROID_BUILD_TOOLS=$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION
ENV ANDROID_PLATFORM_TOOLS=$ANDROID_HOME/platform-tools
ENV ANDROID_PLATFORM=$ANDROID_HOME/platforms/android-$ANDROID_API_VERSION
ENV ANDROID_API_VERSION=$ANDROID_API_VERSION

ENV PATH=$PATH:$ANDROID_PLATFORM_TOOLS

# =============================================================================
# Raylib
# =============================================================================

ARG RAYLIB_VERSION=5.5

ENV RAYLIB_INCLUDE_PATH=/usr/local/include
ENV RAYLIB_LIB_PATH=/usr/local/lib/raylib

RUN git clone --depth 1 --branch "$RAYLIB_VERSION" https://github.com/raysan5/raylib.git /tmp/raylib && \
    cd /tmp/raylib/src && \
    # Linux X11 static
    make clean && \
    make PLATFORM=PLATFORM_DESKTOP && \
    make install PLATFORM=PLATFORM_DESKTOP RAYLIB_INSTALL_PATH=$RAYLIB_LIB_PATH/linux-x11-static && \
    # Linux X11 shared
    make clean && \
    make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED && \
    make install PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED RAYLIB_INSTALL_PATH=$RAYLIB_LIB_PATH/linux-x11-shared && \
    # Linux Wayland static
    make clean && \
    make PLATFORM=PLATFORM_DESKTOP GLFW_LINUX_ENABLE_WAYLAND=TRUE GLFW_LINUX_ENABLE_X11=FALSE && \
    make install PLATFORM=PLATFORM_DESKTOP  RAYLIB_INSTALL_PATH=$RAYLIB_LIB_PATH/linux-wayland-static && \
    # Linux Wayland shared
    make clean && \
    make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED GLFW_LINUX_ENABLE_WAYLAND=TRUE GLFW_LINUX_ENABLE_X11=FALSE && \
    make install PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED RAYLIB_INSTALL_PATH=$RAYLIB_LIB_PATH/linux-wayland-shared && \
    # Web
    make clean && \
    bash -c 'source "$EMSDK_HOME/emsdk_env.sh" && make PLATFORM=PLATFORM_WEB' && \
    make install PLATFORM=PLATFORM_WEB RAYLIB_INSTALL_PATH=$RAYLIB_LIB_PATH/web && \
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

ARG RAYLIB_WIN64_ARCHIVE=raylib-${RAYLIB_VERSION}_win64_mingw-w64.zip
ARG RAYLIB_WIN64_URL=https://github.com/raysan5/raylib/releases/download/$RAYLIB_VERSION/$RAYLIB_WIN64_ARCHIVE

# Raylib makefile does not support Linux to Windows cross compilation, so we just download pre-built files.
RUN curl --location --output "/tmp/$RAYLIB_WIN64_ARCHIVE" "$RAYLIB_WIN64_URL" && \
    # Windows 64 static
    mkdir -p "$RAYLIB_LIB_PATH/win64-static" && \
    unzip -j "/tmp/$RAYLIB_WIN64_ARCHIVE" '*/libraylib.a' -d "$RAYLIB_LIB_PATH/win64-static" && \
    # Windows 64 shared
    mkdir -p "$RAYLIB_LIB_PATH/win64-shared" && \
    unzip -j "/tmp/$RAYLIB_WIN64_ARCHIVE" '*/libraylibdll.a' -d "$RAYLIB_LIB_PATH/win64-shared" && \
    unzip -j "/tmp/$RAYLIB_WIN64_ARCHIVE" '*/*.dll' -d "$RAYLIB_LIB_PATH/win64-shared" && \
    mv "$RAYLIB_LIB_PATH/win64-shared/libraylibdll.a" "$RAYLIB_LIB_PATH/win64-shared/libraylib.a" && \
    # Clean up downloaded files
    rm "/tmp/$RAYLIB_WIN64_ARCHIVE"

# =============================================================================
# Odin language
# =============================================================================

ARG ODIN_VERSION=dev-2024-12
ARG ODIN_ARCHIVE=odin-linux-amd64-$ODIN_VERSION.tar.gz
ARG ODIN_URL=https://github.com/odin-lang/Odin/releases/download/$ODIN_VERSION/$ODIN_ARCHIVE

ENV ODIN_ROOT=/opt/odin

RUN mkdir -p "$ODIN_ROOT" && \
    curl --location --output "/tmp/$ODIN_ARCHIVE" "$ODIN_URL" && \
    tar xf "/tmp/$ODIN_ARCHIVE" --strip-components=1 --directory="$ODIN_ROOT" && \
    rm "/tmp/$ODIN_ARCHIVE"

ENV PATH=$PATH:$ODIN_ROOT

# =============================================================================
# Entrypoint
# =============================================================================

COPY entrypoint.sh /usr/local/bin/entrypoint

ENTRYPOINT ["entrypoint"]

CMD ["bash"]
