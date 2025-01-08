FROM ubuntu:24.10

# =============================================================================
# System packages
# =============================================================================

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        unzip \
        git \
        clang \
        && \
    # Clean apt cache to reduce image size
    rm -rf /var/lib/apt/lists/*

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
