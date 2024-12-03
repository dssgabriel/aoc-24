const std = @import("std");
const input = @embedFile("./input/input.txt");

pub fn part1(comptime in: []const u8) !usize {
    // Parse input
    var lines = std.mem.tokenizeAny(u8, in, "\n");
    var safe_lvls: usize = 0;
    while (lines.next()) |line| {
        var levels = std.mem.tokenizeAny(u8, line, " ");
        var is_safe = true;
        var all_increasing: bool = true;
        var i: usize = 0;
        while (levels.next()) |level| : (i += 1) {
            // Did we reach the end yet?
            if (levels.peek() == null) {
                break;
            }

            const a = try std.fmt.parseInt(i32, level, 10);
            const b = try std.fmt.parseInt(i32, levels.peek().?, 10);
            // Find out if levels are all increasing or all decreasing
            if (i == 0) {
                all_increasing = if (a < b) true else false;
            }

            const diff = a - b;
            const absdiff = if (diff < 0) diff * -1 else diff;
            if (diff >= 0 and all_increasing or diff <= 0 and !all_increasing or absdiff < 1 or absdiff > 3) {
                is_safe = false;
                break;
            }
        }

        if (is_safe) {
            safe_lvls += 1;
        }
    }

    return safe_lvls;
}

pub fn main() !void {
    std.debug.print("Part 1: {}\n", .{try part1(input)});
}

test "test-part1" {
    const test_input = @embedFile("input/test.txt");
    const result = try part1(test_input);
    try std.testing.expectEqual(2, result);
}
