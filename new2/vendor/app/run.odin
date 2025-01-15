#+build !wasm32
package app

import os "core:os"

run :: proc(init: InitProc, update: UpdateProc, quit: QuitProc) {
    if !init() {
        os.exit(1)
    }

    free_all(context.temp_allocator)

    for update() {
        free_all(context.temp_allocator)
    }

    quit()
}
