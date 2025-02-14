const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    while (true) {
        try stdout.print("$ ", .{});
        var buffer: [1024]u8 = undefined;
        const user_input = stdin.readUntilDelimiterOrEof(&buffer, '\n') catch |err| {
            std.debug.print("Error reading input: {}\n", .{err});
            break;
        };

        if (user_input == null) {
            break;
        }

        var commands = std.mem.splitSequence(u8, user_input.?, " ");
        const command = commands.first();
        const args = commands.rest();

        if (std.mem.eql(u8, command, "exit")) {
            if (args.len > 0 and std.mem.eql(u8, args, "0")) {
                break;
            }
        } else if (std.mem.eql(u8, command, "echo")) {
            _ = try stdout.write(args);
            _ = try stdout.write("\n");
        } else {
            try stdout.print("{s}: command not found\n", .{user_input.?});
        }
    }
}