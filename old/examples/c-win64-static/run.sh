#!/usr/bin/env sh

set -eu

exec wine "$(dirname -- "$0")/out/game.exe"
