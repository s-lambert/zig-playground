const std = @import("std");

const size: usize = 5;
const field = (((" " ** size) ++ '\n') ** size);
const clearChars = "\x1b[A" ** size;

pub fn conway_simulation() !void {
    var initial_state = [25]u8{};
    _ = initial_state;
}
