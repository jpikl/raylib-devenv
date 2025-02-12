package main_impl

import "base:runtime"
import "build:app"
import "build:web"
import "core:c"
import project "project:src"
import rl "vendor:raylib"

@(default_calling_convention = "c")
foreign _ {
    emscripten_set_main_loop :: proc(func: proc(), fps: c.int, simulate_infinite_loop: c.bool) ---
}

web_context: runtime.Context

@(export)
web_main :: proc "c" () {
    web_context = web.create_context()

    rl.SetTraceLogCallback(proc "c" (level: rl.TraceLogLevel, text: cstring, args: ^c.va_list) {
        context = web_context
        app.trace_log(level, text, args)
    })

    if web_init() {
        emscripten_set_main_loop(web_update, 0, true)
    }
}

web_init :: proc "c" () -> bool {
    context = web_context
    defer free_all(context.temp_allocator)
    return project.app.init == nil || project.app.init()
}

web_update :: proc "c" () {
    context = web_context
    defer free_all(context.temp_allocator)
    if project.app.update != nil {
        project.app.update()
    }
}
