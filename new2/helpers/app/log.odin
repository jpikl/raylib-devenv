package app

import "core:log"
import "core:c"
import rl "vendor:raylib"

log_buf: [1024]byte

// We cannot import "core:c/libc" when compiling to wasm.
// These declarations are 1:1 with "core:c/libc".
foreign {
    vsnprintf :: proc "c" (s: [^]c.char, n: c.size_t, format: cstring, arg: ^c.va_list) -> c.int ---
}

trace_log :: proc(rl_level: rl.TraceLogLevel, text: cstring, args: ^c.va_list) {
    level: log.Level

    switch rl_level {
    case .TRACE, .DEBUG: level = .Debug
    case .INFO:          level = .Info
    case .WARNING:       level = .Warning
    case .ERROR:         level = .Error
    case .FATAL:         level = .Fatal
    case .ALL, .NONE: fallthrough
    case: return
    }

    if level < context.logger.lowest_level {
        return
    }

    len := vsnprintf(raw_data(&log_buf), len(log_buf), text, args)
    log.log(level, string(log_buf[:len]))
}
