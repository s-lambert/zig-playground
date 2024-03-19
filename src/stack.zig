const std = @import("std");

pub fn Stack(comptime Item: type) type {
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
            node.* = .{
                .data = item,
                .next = null,
                .prev = null,
            };
            if (this.start == null) {
                this.start = node;
                this.end = node;
            } else {
                node.prev = node;
                this.start = node;
            }
        }
        pub fn pop(this: *This) ?Item {
            const popped = this.start orelse return null;
            defer this.gpa.destroy(popped);
            if (this.start) |start| {
                this.start = start.next;
            }
            return popped.data;
        }
    };
}

test "stack" {
    var int_stack = Stack(i32).init(std.testing.allocator);

    try int_stack.push(10);

    try std.testing.expectEqual(int_stack.pop(), 10);
}
