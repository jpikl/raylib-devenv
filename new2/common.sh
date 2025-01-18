# shellcheck shell=bash

# Project specific configuration overrides
if [[ -f config.sh ]]; then
    # shellcheck disable=SC1091
    source config.sh
fi

APP_CODE=${APP_CODE:-"app"}
APP_NAME=${APP_NAME:-"App"}
APP_VERSION=${APP_VERSION:-"1.0.0"}

print_common_vars() {
    print_var APP_CODE
    print_var APP_NAME
    print_var APP_VERSION
}

print_var() {
    printf "%b%s=%s%b\n" "$FMT_WARNING" "$1" "${!1}" "$FMT_RESET"
}

FMT_DANGER="\e[1;31m"
FMT_SUCCESS="\e[1;32m"
FMT_WARNING="\e[1;33m"
FMT_INFO="\e[1;34m"
FMT_RESET="\e[0m"

RUN_COUNTER=0

run_step() {
    RUN_COUNTER=$((RUN_COUNTER+1))

    printf "%b[Step %d]" "$FMT_INFO" "$RUN_COUNTER"
    printf " %q" "$@"
    printf "%b\n" "$FMT_RESET"

    if "$@"; then
        printf "%b[Step %d] OK%b\n" "$FMT_SUCCESS" "$RUN_COUNTER" "$FMT_RESET"
    else
        die "[Step $RUN_COUNTER] Failed with error $?"
    fi
}

skip_step() {
    RUN_COUNTER=$((RUN_COUNTER+1))
    printf "%b[Step %d] %s%b\n" "$FMT_WARNING" "$RUN_COUNTER" "$1" "$FMT_RESET"
}

die() {
    printf >&2 "%b%s%b\n" "$FMT_DANGER" "$1" "$FMT_RESET"
    exit 1
}

normalize_bool() {
    local name=$1
    local value=${!name-}

    case "$value" in
        true|1) echo 1 ;;
        false|0|"") ;;
        *) die "Invalid $name='$value' value, expected one of [true, false, 0, 1, '']" ;;
    esac
}
