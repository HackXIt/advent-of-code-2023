//
// File: main.zig
// Created on: Monday, 2023-12-04 @ 21:01:06
// Author: HackXIt (<hackxit@gmail.com>)
// -----
// Last Modified: Monday, 2023-12-04 @ 23:50:04
// Modified By:  HackXIt (<hackxit@gmail.com>) @ HACKXIT
// -----
//

const std = @import("std");
const expect = std.testing.expect;

fn sumOfLine(line: []const u8) !u32 {
    var line_sum: u32 = 0;
    for (line) |val| {
        if (std.ascii.isDigit(val)) {
            // try std.debug.print("{d}", .{val});
            line_sum += @intCast(val);
        }
    }
    return line_sum;
}

fn calibrateTrebuchet(input: []const u8) !u32 {
    var sum: u32 = 0;
    var iter = std.mem.tokenizeAny(u8, input, "\n");
    while (iter.next()) |line| {
        sum += sumOfLine(line) catch 0;
    }
    return sum;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    // const file = std.fs.cwd().openFile("input.txt", .{}) catch |err| {
    //     std.debug.print("Error opening file: ", .{err});
    //     return;
    // };
    // defer file.close(); // defer executes expression at end of current scope (i.e. after main() in this case)
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const content = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 1024 * 1024);

    var total: u32 = calibrateTrebuchet(content) catch 0;

    try stdout.print("Total: {d}", .{total});
}

test "simple test" {
    const example_input = @embedFile("sample.txt");
    var sum: u32 = calibrateTrebuchet(example_input) catch 0;
    try expect(sum == 142);
}
