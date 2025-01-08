# shellcheck shell=bash

# Project specific configuration overrides
if [[ -f config.sh ]]; then
    source config.sh
fi

# App config
APP_CODE=${APP_CODE:-"app"}
APP_NAME=${APP_NAME:-"App"}
APP_VERSION=${APP_VERSION:-"1.0.0"}

# Directories
SRC_DIR=${SRC_DIR:-"src"}
OUT_DIR=${OUT_DIR:-"out"}
ASSETS_DIR=${ASSETS_DIR:-"assets"}
