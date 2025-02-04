#+build !wasm32
#+build !wasm64p32
package app

import "base:runtime"
import "core:os"
import "core:log"
import "core:c"
import rl "vendor:raylib"

main_context: runtime.Context

run :: proc(init: InitProc, update: UpdateProc, quit: QuitProc) {
    main_context = runtime.default_context()
    main_context.logger = log.create_console_logger()

    rl.SetTraceLogCallback(proc "c" (level: rl.TraceLogLevel, text: cstring, args: ^c.va_list) {
        context = main_context
        trace_log(level, text, args)
    })


    context = main_context

    if !init() {
        os.exit(1)
    }

    free_all(context.temp_allocator)

    for update() {
        free_all(context.temp_allocator)
    }

    quit()
}
