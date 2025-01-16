package app

CODE :: #config(APP_CODE, "")
NAME :: #config(APP_NAME, "")
VERSION :: #config(APP_VERSION, "")
ASSETS_DIR :: #config(ASSETS_DIR, "")
IS_WEB :: ODIN_ARCH == .wasm32
