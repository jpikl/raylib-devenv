FROM ubuntu:24.10

# =============================================================================
# System packages
# =============================================================================

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
        # To download files (odin)
        curl \
        ca-certificates \
        # To clone project repos (emsdk, raylib)
        git \
        # To run emsdk
        python3 \
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
# Emscripten SDK
# =============================================================================

ARG EMSDK_VERSION=3.1.74

RUN git clone --depth 1 https://github.com/emscripten-core/emsdk.git /opt/emsdk && \
    cd /opt/emsdk && \
    ./emsdk install "$EMSDK_VERSION" && \
    ./emsdk activate "$EMSDK_VERSION"

# =============================================================================
# Raylib
# =============================================================================

ARG RAYLIB_VERSION=5.5

RUN git clone --depth 1 --branch "$RAYLIB_VERSION" https://github.com/raysan5/raylib.git /tmp/raylib && \
    cd /tmp/raylib/src && \
    # Static version
    make clean && \
    make PLATFORM=PLATFORM_DESKTOP && \
    make install PLATFORM=PLATFORM_DESKTOP && \
    # Dynamic shared version
    make clean && \
    make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED && \
    make install PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED && \
    # Static version (Web)
    make clean && \
    bash -c 'source /opt/emsdk/emsdk_env.sh && make PLATFORM=PLATFORM_WEB' && \
    cp libraylib.a /usr/local/lib/libraylib.web.a && \
    # Get rid of the cloned repo
    rm -r /tmp/raylib

# =============================================================================
# Entrypoint
# =============================================================================

COPY entrypoint.sh /usr/local/bin/entrypoint

ENTRYPOINT ["entrypoint"]

CMD ["bash"]
