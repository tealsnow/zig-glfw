const std = @import("std");

const glfw = @import("glfw");

pub fn main() anyerror!void {
    var window = try glfw.Window.init(800, 600, "error", null, null);
    defer window.deinit();
}
