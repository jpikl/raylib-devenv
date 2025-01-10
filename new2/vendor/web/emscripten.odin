package web

import "core:c"

foreign import lib {
    "env.o",
}

@(default_calling_convention="c")
foreign lib {
	emscripten_set_main_loop :: proc (func: proc "c" (), fps: c.int, simulate_infinite_loop: c.bool) ---
}
