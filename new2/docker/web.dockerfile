ARG BASE_DOCKER_IMAGE

FROM $BASE_DOCKER_IMAGE

# =============================================================================
# System packages
# =============================================================================

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
        git \
        python3 \
        xz-utils \
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
