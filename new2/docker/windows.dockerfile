ARG BASE_DOCKER_IMAGE

FROM $BASE_DOCKER_IMAGE

# =============================================================================
# MSVC via XWin
# =============================================================================

ARG XWIN_VERSION=0.6.5
ARG XWIN_PREFIX=xwin-$XWIN_VERSION-x86_64-unknown-linux-musl
ARG XWIN_URL=https://github.com/Jake-Shadle/xwin/releases/download/$XWIN_VERSION/$XWIN_PREFIX.tar.gz

ENV XWIN_HOME=/opt/xwin

# Manifest with fixed MSVC SDK versions to make the image reproducible.
# Downloaded from https://aka.ms/vs/{version}/{channel}/channel where version=17 and channel=release.
COPY windows_msvc.chman /tmp

RUN curl --location --fail "$XWIN_URL" | tar xz --directory=/usr/local/bin --strip-components=1 "$XWIN_PREFIX/xwin" && \
    xwin --accept-license \
         --cache-dir /tmp/xwin \
         --log-level debug \
         --manifest /tmp/windows_msvc.chman \
         splat --output "$XWIN_HOME" && \
    rm -rf /tmp/xwin /tmp/windows_msvc.chman /usr/local/bin/xwin
