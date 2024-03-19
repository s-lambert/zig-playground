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

        pub fn init(gpa: std.mem.Allocator) This {
            return This{
                .gpa = gpa,
                .start = null,
                .end = null,
            };
        }
        pub fn push(this: *This, item: Item) !void {
            const node = try this.gpa.create(Node);
            node.* = .{.data = value, .next = null, .end =null,};
        }
        pub fn pop() ?Item {}
    };
}
