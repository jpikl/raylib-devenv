package app

CODE :: #config(APP_CODE, "")
NAME :: #config(APP_NAME, "")
VERSION :: #config(APP_VERSION, "")

ASSETS_DIR :: #config(ASSETS_DIR, "")

IS_LINUX :: #config(IS_LINUX, ODIN_OS == .Linux)
IS_WINDOWS :: #config(IS_WINDOWS, ODIN_OS == .Windows)
IS_DESKTOP :: IS_LINUX || IS_WINDOWS
IS_WEB :: #config(IS_WEB, false)
IS_ANDROID :: #config(IS_ANDROID, false)
IS_MOBILE :: IS_ANDROID
