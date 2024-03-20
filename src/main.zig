const std = @import("std");

const size = 5;

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var state = std.mem.zeroes([25]u8);
    // Create a glider
    // xxx
    // x
    //  x
    state[6] = 1;
    state[7] = 1;
    state[8] = 1;
    state[11] = 1;
    state[17] = 1;

    try print_field(&bw, &stdout, &state);

    for (0..20) |_| {
        std.time.sleep(0.5 * std.time.ns_per_s);
        try clear_field(&bw, &stdout);
        state = compute_next_state(&state);
        try print_field(&bw, &stdout, &state);
    }
}

fn count_neighbours(current_state: *const [25]u8, x: usize, y: usize) usize {
    var count: usize = 0;
    for (0..3) |i| {
        if (x == 0 and i == 0) continue;
        const nx = x + i - 1;
        if (nx > 4) continue;
        for (0..3) |j| {
            if (y == 0 and j == 0) continue;
            const ny = y + j - 1;
            if (ny > 4) continue;
            if (nx == x and ny == y) continue;
            count += current_state[(ny * 5) + nx];
        }
    }
    return count;
}

fn compute_next_state(current_state: *const [25]u8) [25]u8 {
    var next_state = std.mem.zeroes([25]u8);
    for (0..5) |y| {
        for (0..5) |x| {
            const neighbours = count_neighbours(current_state, x, y);
            const is_alive = current_state[(y * 5) + x] == 1;
            if (is_alive) {
                if (neighbours >= 2 and neighbours <= 3) {
                    // Any live cell with fewer than two live neighbors dies, as if by underpopulation.
                    // Any live cell with two or three live neighbors lives on to the next generation.
                    // Any live cell with more than three live neighbors dies, as if by overpopulation.
                    next_state[(y * 5) + x] = 1;
                }
            } else if (neighbours == 3) {
                // Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.
                next_state[(y * 5) + x] = 1;
            }
        }
    }
    return next_state;
}

const clear_lines = "\x1b[A" ** size;
fn clear_field(bw: anytype, stdout: anytype) !void {
    try stdout.print(clear_lines, .{});
    try bw.flush();
}

fn print_field(bw: anytype, stdout: anytype, current_field: *const [25]u8) !void {
    for (0..5) |y| {
        for (0..5) |x| {
            try stdout.print("{d}", .{current_field[(y * 5) + x]});
        }
        try stdout.print("\n", .{});
    }
    try bw.flush();
}

fn terminal_clearing() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});
    try stdout.print("Test line.\n", .{});

    try bw.flush(); // don't forget to flush!

    // var line_buf: [20]u8 = undefined;
    // _ = try std.io.getStdIn().read(&line_buf

    std.time.sleep(0.5 * std.time.ns_per_s);

    try stdout.print("{d}\n", .{1});
    try stdout.print("{d}\n", .{1});
    try stdout.print("{d}\n", .{1});
    try stdout.print("{d}\n", .{1});
    try stdout.print("{d}\n", .{1});

    try bw.flush();

    std.time.sleep(0.5 * std.time.ns_per_s);
    const clearChars = "\x1b[A" ** 5;
    try stdout.print(clearChars, .{});

    try bw.flush();

    std.time.sleep(0.5 * std.time.ns_per_s);
    try stdout.print("{d}\n", .{2});
    try stdout.print("{d}\n", .{2});
    try stdout.print("{d}\n", .{2});
    try stdout.print("{d}\n", .{2});
    try stdout.print("{d}\n", .{2});

    try bw.flush();

    std.time.sleep(0.5 * std.time.ns_per_s);
    try stdout.print(clearChars, .{});

    const field = (((" " ** 5) ++ "\n") ** 5);
    try stdout.print(field, .{});

    try bw.flush();

    std.time.sleep(0.5 * std.time.ns_per_s);
    try stdout.print(clearChars, .{});
    var new_field = try std.heap.page_allocator.dupe(u8, field);
    new_field[0] = 'a';
    new_field[4] = 'b';

    try stdout.print("{s}", .{new_field});

    try bw.flush();
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
