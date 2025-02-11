# shellcheck shell=bash

gen_package_name() {
    printf "com."
    echo "$1" | tr '[:upper:]' '[:lower:]' | tr -cd "a-z0-9_"
}

gen_version_code() {
    local result=0
    local item

    while read -r item; do
        result=$((result * 1000 + item))
    done < <(echo "$1" | tr . $'\n')

    echo "$result"
}

ANDROID_OUT_DIR=${ANDROID_OUT_DIR:-"$OUT_DIR/android"}
ANDROID_APK=${ANDROID_APK:-"$APP_CODE.apk"}
ANDROID_PACKAGE=${ANDROID_PACKAGE:-"$(gen_package_name "$APP_CODE")"}
# shellcheck disable=SC2034
ANDROID_PACKAGE_DIR=${ANDROID_PACKAGE//./\/}
ANDROID_MANIFEST=${ANDROID_MANIFEST:-"$SCRIPTS_DIR/android/AndroidManifest.xml"}
ANDROID_LABEL=${ANDROID_LABEL:-"$APP_NAME"}
ANDROID_VERSION_NAME=${ANDROID_VERSION_NAME:-"$APP_VERSION"}
ANDROID_VERSION_CODE=${ANDROID_VERSION_CODE:-"$(gen_version_code "$ANDROID_VERSION_NAME")"}
ANDROID_ICON=${ANDROID_ICON:-"$SCRIPTS_DIR/android/icon.png"}
ANDROID_ORIENTATION=${ANDROID_ORIENTATION:-"landscape"}

print_var ANDROID_OUT_DIR
print_var ANDROID_APK
print_var ANDROID_PACKAGE
print_var ANDROID_PACKAGE_DIR
print_var ANDROID_MANIFEST
print_var ANDROID_LABEL
print_var ANDROID_VERSION_NAME
print_var ANDROID_VERSION_CODE
print_var ANDROID_ICON
print_var ANDROID_ORIENTATION
