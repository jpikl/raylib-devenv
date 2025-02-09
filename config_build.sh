# shellcheck shell=bash

DEBUG=${DEBUG:-false}
DEBUG=$(normalize_bool DEBUG)

print_var DEBUG
