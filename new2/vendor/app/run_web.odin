#+build wasm32
package app

import "base:runtime"
import "core:mem"
import web "../web"

init_ref: InitProc
update_ref: UpdateProc

web_context: runtime.Context

@(thread_local)
temp_allocator: web.Default_Temp_Allocator

run :: proc "c" (init: InitProc, update: UpdateProc, _quit: QuitProc) {
    init_ref = init
    update_ref = update

    web_context_init()
    web_init()

    web.emscripten_set_main_loop(web_update, 0, true)
}

@export
web_context_init :: proc "c" () {
    web_context = runtime.default_context()
	web_context.allocator = web.emscripten_allocator()

    context = web_context

	web.default_temp_allocator_init(&temp_allocator, mem.Megabyte)
	web_context.temp_allocator = web.default_temp_allocator(&temp_allocator)
	web_context.logger = web.create_emscripten_logger()
}

import log "core:log"

@export
web_init :: proc "c" () {
    context = web_context
    log.info("helllllo")
	init_ref()
}

@export
web_update :: proc "c" () {
	context = web_context
	update_ref()
}
