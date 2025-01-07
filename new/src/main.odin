package main

import os "core:os"

main :: proc() {
    if !init() {
        os.exit(1)
    }
    for update() {
        free_all(context.temp_allocator)
    }
    quit()
}
