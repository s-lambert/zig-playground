const std = @import("std");

pub fn main() !void {
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
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
