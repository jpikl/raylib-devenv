#!/usr/bin/env sh

set -eu

find . -name '*.sh' -print0 | xargs -0 shellcheck --check-sourced --external-sources

printf "\e[32m%s\e[0m\n" "Check OK"
