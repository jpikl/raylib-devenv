# Raylib Odin Build Scripts

Work in progress...

## Configuration variables

Variables may be overridden using either `config.sh` or `.env` files.

These files are searched inside `PROJECT_DIR` (which is the current working directory by default).

### Application configuration

| Variable      | Default      | Description          |
| ------------- | ------------ | -------------------- |
| `APP_CODE` \* | `raylib-app` | Application code.    |
| `APP_NAME`    | `Raylib App` | Application name.    |
| `APP_VERSION` | `1.0.0`      | Application version. |

\* Used as base name for various output artifacts (executables, android APK, etc.).

### Directory configuration

| Variable             | Default             | Description                                           |
| -------------------- | ------------------- | ----------------------------------------------------- |
| `SRC_DIR` \*         | `src`               | Path to directory with `*.odin` source files.         |
| `OUT_DIR` \*         | `out`               | Path where to output build artifacts.                 |
| `ASSETS_DIR` \*      | `assets`            | Path with application assets (textures, sounds, ...). |
| `PROJECT_DIR` \*\*   | Current working dir | Path to project directory.                            |
| `SCRIPTS_DIR` \*\*\* | Auto detected       | Path to build scripts directory.                      |

\* These directories are expected to be inside `PROJECT_DIR` and their paths to be relative to `PROJECT_DIR`.
Otherwise, there might be issues with the docker builds.

\*\* Can be changed only from environment, not from `config.sh` or `.env`.

\*\*\* Cannot be changed.

### Odin configuration

| Variable                 | Default       | Description                                 |
| ------------------------ | ------------- | ------------------------------------------- |
| `ODIN`                   | `odin`        | Path to `odin` executable.                  |
| `ODIN_ROOT` \*           | Auto detected | Path to odin root directory.                |
| `ODIN_STRICT`            | `true`        | Enables `-vet` and `-strict-style` flags.   |
| `ODIN_OPTIMIZATION` \*\* | `speed`       | Optimization mode `-o:<mode>`.              |
| `ODIN_EXTRA_FLAGS`       | `()`          | Array of additional flags passed to `odin`. |

\* Auto detected by calling `odin root`.

\*\* Disabled when `DEBUG=true`.

### Build configuration

| Variable      | Default | Description                              |
| ------------- | ------- | ---------------------------------------- |
| `DEBUG` \*    | `false` | Set `true` to build in debug mode.       |
| `RAYGUI` \*\* | `true`  | Set `false` to disable raygui inclusion. |

\* Debug mode disables any optimizations and enables generation of debug symbols using `-debug` odin flag.

\*\* Due to technical limitations, Android builds ignore this and always include raygui.

### Linux build configuration

| Variable        | Default            | Description                                 |
| --------------- | ------------------ | ------------------------------------------- |
| `LINUX_OUT_DIR` | `${OUT_DIR}/linux` | Output directory for Linux build artifacts. |
| `LINUX_BINARY`  | `${APP_CODE}`      | Name of the Linux binary.                   |

### Windows build configuration

| Variable          | Default              | Description                                   |
| ----------------- | -------------------- | --------------------------------------------- |
| `WINDOWS_OUT_DIR` | `${OUT_DIR}/windows` | Output directory for Windows build artifacts. |
| `WINDOWS_BINARY`  | `${APP_CODE}.exe`    | Name of the Windows binary.                   |
| `XWIN_HOME`       |                      | Path to [xwin][xwin] output directory.        |
| `LINK`            | `lld-link`           | Path to LLVM `lld-link` linker.               |

### Web build configuration

| Variable                  | Default                         | Description                               |
| ------------------------- | ------------------------------- | ----------------------------------------- |
| `WEB_OUT_DIR`             | `${OUT_DIR}/web`                | Output directory for web build artifacts. |
| `WEB_SHELL` \*            | `${SCRIPTS_DIR}/web/shell.html` | Path to HTML shell template.              |
| `WEB_TEMP_ALLOCATOR_SIZE` | `1048576` (1 MB)                | Size of temporary allocator (in bytes).   |
| `WEB_PORT`                | `8080`                          | Port used by development HTTP server.     |
| `EMSDK`                   |                                 | Path to Emscripten install directory.     |
| `EMCC`                    | `emcc`                          | Path to `emcc` executable.                |
| `EMCC_EXTRA_FLAGS`        | `()`                            | Extra flags passed to `emcc`.             |

\* Used only when `DEBUG=false`. For `DEBUG=true`, the [default Emscripten shell][emcc-shell] is used.

### Android build configuration

| Variable          | Default              | Description                                   |
| ----------------- | -------------------- | --------------------------------------------- |
| `ANDROID_OUT_DIR` | `${OUT_DIR}/android` | Output directory for Android build artifacts. |
| `ANDROID_APK`     | `${APP_CODE}.apk`    | Name of the Android APK.                      |

### Docker configuration

| Variable             | Default             | Description                                 |
| -------------------- | ------------------- | ------------------------------------------- |
| `DOCKER` \*          | Auto detected       | Path to `docker` or `podman` executable.    |
| `DOCKER_TYPE`        | Auto detected       | Either `docker` or `podman`.                |
| `DOCKER_IMAGE` \*\*  | `${APP_CODE}-build` | Name of Docker image for building the app.  |
| `DOCKER_PROJECT_DIR` | `/mnt/project`      | `PROJECT_DIR` path inside Docker container. |
| `DOCKER_SCRIPTS_DIR` | `/mnt/scripts`      | `SCRIPTS_DIR` path inside Docker container. |

\* If both `docker` and `podman` are installed, then `podman` is selected as the preferred one.

\*\* The image tag will correspond to the target build platform.
For example `${APP_CODE}-build:linux` or `${APP_CODE}-build:android`.

[xwin]: https://github.com/Jake-Shadle/xwin
[emcc-shell]: https://github.com/emscripten-core/emscripten/blob/main/src/shell.html
