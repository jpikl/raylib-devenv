# shellcheck shell=bash

echo_color() {
    echo -e "\e[1;3${1}m$2\e[0m"
}

error() {
    echo_color 1 "$1"
}

success() {
    echo_color 2 "$1"
}

warning() {
    echo_color 3 "$1"
}

info() {
    echo_color 4 "$1"
}

debug() {
    echo_color 5 "$1"
}

die() {
    error "$1" >&2
    exit 1
}

print_var() {
    debug "[config] $1=${!1-}"
}

print_arr() {
    local ref="$1[@]"
    local value=${!ref}
    debug "[config] $1=${value[*]}"
}

random_num() {
    shuf -ern "$1" {0..9} | tr -d '\n'
}

run() {
    local ID
    ID=$(random_num 5)

    info "[run $ID]$(printf " %q" "$@")"

    if "$@"; then
        success "[run $ID] OK"
    else
        die "[run $ID] Failed with error $?"
    fi
}

skip() {
    warning "[skip] $1"
}

normalize_bool() {
    case "${!1-}" in
        true|1) echo 1 ;;
        false|0|"") ;;
        *) die "Invalid $1='${!1}' value, expected one of [true, false, 1, 0, '']" ;;
    esac
}

check_var_is_set() {
    if [[ ! "${!1-}" ]]; then
        die "$1 must be set but is empty"
    fi
}


check_var_is_dir() {
    check_var_is_set "$1"

    if [[ ! -d "${!1}" ]]; then
        die "$1='${!1}' is not a directory"
    fi
}

check_var_is_file() {
    check_var_is_set "$1"

    if [[ ! -f "${!1}" ]]; then
        die "$1='${!1}' is not a file"
    fi
}

check_var_is_executable() {
    check_var_is_set "$1"

    if [[ ! -x "${!1}" ]]; then
        die "$1='${!1}' is not executable"
    fi
}

find_executable() {
    local arg

    for arg; do
        if [[ -x "$(command -v "$arg")" ]]; then
            echo "$arg"
            return
        fi
    done

    if [[ ${#@} -eq 1 ]]; then
        die "Could not find executable: $1"
    else
        die "Could not find any of these executables: $*"
    fi
}

# Project specific configuration overrides
if [[ -f config.sh ]]; then
    # shellcheck disable=SC1091
    source config.sh
fi

APP_CODE=${APP_CODE:-"app"}
APP_NAME=${APP_NAME:-"App"}
APP_VERSION=${APP_VERSION:-"1.0.0"}

print_var APP_CODE
print_var APP_NAME
print_var APP_VERSION
