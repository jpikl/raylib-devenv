#+build wasm32, wasm64p32
package app

import "base:runtime"
import "core:c"
import rl "vendor:raylib"
import "../web"

@(default_calling_convention="c")
foreign {
	emscripten_set_main_loop :: proc(func: proc(), fps: c.int, simulate_infinite_loop: c.bool) ---
}

@(private)
web_context: runtime.Context

@(private)
web_init_impl : InitProc

@(private)
web_update_impl : UpdateProc

web_run :: proc "c" (init: InitProc, update: UpdateProc) {
    web_context = web.create_context()
    web_init_impl = init
    web_update_impl = update

    rl.SetTraceLogCallback(proc "c" (level: rl.TraceLogLevel, text: cstring, args: ^c.va_list) {
        context = web_context
        trace_log(level, text, args)
    })

    if web_init() {
        emscripten_set_main_loop(web_update, 0, true)
    }
}

@(private)
web_init :: proc "c" () -> bool {
    context = web_context
    defer free_all(context.temp_allocator)
    return web_init_impl()
}

@(private)
web_update :: proc "c" () {
    context = web_context
    defer free_all(context.temp_allocator)
    web_update_impl()
}
