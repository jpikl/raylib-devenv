// Source: https://github.com/karl-zylinski/odin-raylib-web/blob/main/source/main_web/main_web_entry.odin

package web

import "base:runtime"
import "core:mem"

TEMP_ALLOCATOR_SIZE :: #config(TEMP_ALLOCATOR_SIZE, mem.Megabyte)

@(private)
@(thread_local)
temp_allocator: Default_Temp_Allocator

create_context :: proc "c" () -> runtime.Context {
    context = runtime.default_context()
    context.allocator = emscripten_allocator()

    default_temp_allocator_init(&temp_allocator, TEMP_ALLOCATOR_SIZE)

    context.temp_allocator = default_temp_allocator(&temp_allocator)
    context.logger = create_emscripten_logger()

    return context
}
