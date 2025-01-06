package main

import os "core:os"

main :: proc() {
    if !init() {
        os.exit(1)
    }
    for is_running() {
        update()
    }
    quit()
}
