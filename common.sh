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
    debug "[config] $1=(${value[*]})"
}

run() {
    local ID=$RANDOM

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
    true | 1) echo true ;;
    false | 0 | "") echo false ;;
    *) die "Invalid $1='${!1}' value, expected one of [true, false, 1, 0, '']" ;;
    esac
}

assert_var_is_set() {
    if [[ ! "${!1-}" ]]; then
        die "$1 must be set but is empty"
    fi
}

assert_var_is_dir() {
    assert_var_is_set "$1"

    if [[ ! -d "${!1}" ]]; then
        die "$1='${!1}' is not a directory"
    fi
}

assert_var_is_file() {
    assert_var_is_set "$1"

    if [[ ! -f "${!1}" ]]; then
        die "$1='${!1}' is not a file"
    fi
}

assert_var_is_executable() {
    assert_var_is_set "$1"

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

if [[ "${PROJECT_DIR-}" ]]; then
    cd "$PROJECT_DIR" || die "Unable to switch to PROJECT_DIR=$PROJECT_DIR"
fi

readonly PROJECT_DIR=$PWD

# Project specific configuration overrides
# shellcheck disable=SC1091
[[ -f config.sh ]] && source config.sh
# shellcheck disable=SC1091
[[ -f .env ]] && source .env

# Must be set by each script individually at the first thing
assert_var_is_dir SCRIPTS_DIR

print_var PROJECT_DIR
print_var SCRIPTS_DIR
