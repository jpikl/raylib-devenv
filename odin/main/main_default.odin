package main_impl

import "base:runtime"
import "build:app"
import "core:c"
import "core:log"
import "core:os"
import project "project:src"
import rl "vendor:raylib"

main_context: runtime.Context


main :: proc() {
    main_context = runtime.default_context()
    main_context.logger = log.create_console_logger()

    rl.SetTraceLogCallback(proc "c" (level: rl.TraceLogLevel, text: cstring, args: ^c.va_list) {
        context = main_context
        app.trace_log(level, text, args)
    })

    context = main_context

    if project.app.init != nil {
        if !project.app.init() {
            os.exit(1)
        }
        free_all(context.temp_allocator)
    }

    if project.app.update != nil {
        for project.app.update() {
            free_all(context.temp_allocator)
        }
    }

    if project.app.quit != nil {
        project.app.quit()
    }
}
