const std = @import("std");

const glfw = @import("glfw");

pub fn main() anyerror!void {
    try glfw.init();
    defer glfw.deinit();
}
