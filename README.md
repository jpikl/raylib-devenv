# Raylib Odin Build Scripts

Work in progress...

## Application configuration

| Variable      | Default      | Description                                               |
| ------------- | ------------ | --------------------------------------------------------- |
| `APP_CODE`    | `raylib-app` | Application code. Base name for various output artifacts. |
| `APP_NAME`    | `Raylib App` | Application name.                                         |
| `APP_VERSION` | `1.0.0`      | Application version.                                      |

## Directory configuration

| Variable     | Default  | Description                                           |
| ------------ | -------- | ----------------------------------------------------- |
| `SRC_DIR`    | `src`    | Path to directory with `*.odin` source files.         |
| `OUT_DIR`    | `out`    | Path where to output build artifacts.                 |
| `ASSETS_DIR` | `assets` | Path with application assets (textures, sounds, ...). |

## Odin configuration

| Variable            | Default       | Description                                                     |
| ------------------- | ------------- | --------------------------------------------------------------- |
| `ODIN`              | Auto detected | Path to `odin` executable.                                      |
| `ODIN_ROOT`         | Auto detected | Path to odin root directory.                                    |
| `ODIN_STRICT`       | `true`        | Enables `-vet` and `-strict-style` flags.                       |
| `ODIN_OPTIMIZATION` | `speed`       | Optimization mode `-o:<mode>`. Disabled when `DEBUG` is `true`. |
| `ODIN_EXTRA_FLAGS`  | `()`          | Array of additional flags passed to odin.                       |

## Build configuration

| Variable | Default | Description                        |
| -------- | ------- | ---------------------------------- |
| `DEBUG`  | `false` | Set `true` to build in debug mode. |

## Docker configuration

| Variable           | Default             | Description                                 |
| ------------------ | ------------------- | ------------------------------------------- |
| DOCKER             | Auto detected       | Path to `docker`/`podman` executable.       |
| DOCKER_TYPE        | Auto detected       | Either `docker` or `podman`.                |
| DOCKER_IMAGE       | `${APP_CODE}-build` | Name of Docker image for building the app.  |
| DOCKER_PROJECT_DIR | `/mnt/project`      | Project path inside Docker container.       |
| DOCKER_SCRIPTS_DIR | `/mnt/scripts`      | Build scripts path inside Docker container. |
