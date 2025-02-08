# Raylib Odin Scripts

Work in progress...

## Application configuration

| Variable      | Default      | Description                                               |
| ------------- | ------------ | --------------------------------------------------------- |
| `APP_CODE`    | `raylib-app` | Application code. Base name for various output artifacts. |
| `APP_NAME`    | `Raylib App` | Application name.                                         |
| `APP_VERSION` | `1.0.0`      | Application version.                                      |

## Odin configuration

| Variable            | Default       | Description                                                     |
| ------------------- | ------------- | --------------------------------------------------------------- |
| `ODIN`              | Auto detected | Path to `odin` executable.                                      |
| `ODIN_ROOT`         | Auto detected | Path to odin root directory.                                    |
| `ODIN_STRICT`       | `true`        | Enables `-vet` and `-strict-style`.                             |
| `ODIN_OPTIMIZATION` | `speed`       | Optimization mode `-o:<mode>`. Disabled when `DEBUG` is `true`. |
| `ODIN_EXTRA_FLAGS`  | `()`          | Additional flags passed to odin.                                |
