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

ARG ODIN_VERSION=dev-2025-01
ARG ODIN_ARCHIVE=odin-ubuntu-amd64-$ODIN_VERSION.zip
ARG ODIN_URL=https://github.com/odin-lang/Odin/releases/download/$ODIN_VERSION/$ODIN_ARCHIVE

ENV ODIN_ROOT=/opt/odin

RUN mkdir -p "$ODIN_ROOT" && \
    curl --location --fail --output "/tmp/$ODIN_ARCHIVE" "$ODIN_URL" && \
    # Probably due to some packaging issue, the zip file does not include files directly but has intermediate `dist.tar.gz` in it.
    unzip "/tmp/$ODIN_ARCHIVE" -d /tmp && \
    tar xf /tmp/dist.tar.gz --strip-components=1 --directory="$ODIN_ROOT" && \
    rm "/tmp/$ODIN_ARCHIVE" /tmp/dist.tar.gz

ENV PATH=$PATH:$ODIN_ROOT
