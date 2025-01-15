#+build wasm32
package app

import "base:runtime"
import "core:mem"
import web "../web"

@(private)
web_context: runtime.Context

@(private)
@(thread_local)
temp_allocator: web.Default_Temp_Allocator

@(private)
update_ref : UpdateProc

web_run :: proc "c" (init: InitProc, update: UpdateProc) {
    web_context = runtime.default_context()
    web_context.allocator = web.emscripten_allocator()

    context = web_context

    web.default_temp_allocator_init(&temp_allocator, mem.Megabyte)
    web_context.temp_allocator = web.default_temp_allocator(&temp_allocator)
    web_context.logger = web.create_emscripten_logger()

    if init() {
        free_all(context.temp_allocator)
        update_ref = update
        web.emscripten_set_main_loop(web_update, 0, true)
    }
}

@(private)
web_update :: proc "c" () {
    context = web_context
    update_ref()
    free_all(context.temp_allocator)
}
