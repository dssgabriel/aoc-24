const std = @import("std");
const input = @embedFile("./input/input.txt");

pub fn part1(comptime in: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    var lhs_list = std.ArrayList(i32).init(alloc);
    var rhs_list = std.ArrayList(i32).init(alloc);

    // Parse input
    var it = std.mem.tokenizeAny(u8, in, "\n ");
    var i: usize = 0;
    while (it.next()) |tok| : (i += 1) {
        const num = try std.fmt.parseInt(i32, tok, 10);
        switch (i % 2) {
            0 => try lhs_list.append(num),
            1 => try rhs_list.append(num),
            else => unreachable,
        }
    }

    // Sort lists
    const lhs_buf = try lhs_list.toOwnedSlice();
    defer alloc.free(lhs_buf);
    const rhs_buf = try rhs_list.toOwnedSlice();
    defer alloc.free(rhs_buf);
    std.mem.sort(i32, lhs_buf, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, rhs_buf, {}, comptime std.sort.asc(i32));

    // Reduce result
    var distance: usize = 0;
    for (lhs_buf, rhs_buf) |lhs, rhs| {
        const res: i32 = lhs - rhs;
        distance += @intCast(if (res < 0) res * -1 else res);
    }

    return distance;
}

pub fn part2(comptime in: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    var lhs_list = std.ArrayList(i32).init(alloc);
    var rhs_list = std.ArrayList(i32).init(alloc);

    // Parse input
    var it = std.mem.tokenizeAny(u8, in, "\n ");
    var i: usize = 0;
    while (it.next()) |tok| : (i += 1) {
        const num = try std.fmt.parseInt(i32, tok, 10);
        switch (i % 2) {
            0 => try lhs_list.append(num),
            1 => try rhs_list.append(num),
            else => unreachable,
        }
    }

    const lhs_buf = try lhs_list.toOwnedSlice();
    defer alloc.free(lhs_buf);
    const rhs_buf = try rhs_list.toOwnedSlice();
    defer alloc.free(rhs_buf);

    // Reduce result
    var distance: usize = 0;
    for (lhs_buf) |lhs| {
        const count: usize = std.mem.count(i32, rhs_buf, &[1]i32{lhs});
        distance += std.math.cast(usize, lhs).? * count;
    }

    return distance;
}

pub fn main() !void {
    std.debug.print("Part 1: {}\n", .{try part1(input)});
    std.debug.print("Part 2: {}\n", .{try part2(input)});
}

test "test-part1" {
    const test_input = @embedFile("input/test.txt");
    const result = try part1(test_input);
    try std.testing.expectEqual(result, 11);
}

test "test-part2" {
    const test_input = @embedFile("input/test.txt");
    const result = try part2(test_input);
    try std.testing.expectEqual(result, 31);
}
