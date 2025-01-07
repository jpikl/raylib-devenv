#!/usr/bin/env sh

assert() {
    if ! sh -c "$1"; then
        printf "\e[31mTest failed:\e[0m %s\n" "$1"
        exit 1
    else
        printf "\e[32mTest OK:\e[0m %s\n" "$1"
    fi
}

assert_if_display() {
    if [ "${DISPLAY-}" ] || [ "${WAYLAND_DISPLAY-}" ]; then
        assert "$1"
    else
        printf "\e[33mTest skipped:\e[0m %s\n" "$1"
    fi
}
