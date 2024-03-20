const std = @import("std");

pub fn Queue(comptime Item: type) type {
    return struct {
        const This = @This();
        const Node = struct {
            data: Item,
            next: ?*Node,
            prev: ?*Node,
        };
        gpa: std.mem.Allocator,
        start: ?*Node,
        end: ?*Node,
    };
}
