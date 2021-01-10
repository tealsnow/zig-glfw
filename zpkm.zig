const api = @import(".zpkm/api.zig");

pub fn createManifest(b: *api.ManifestBuilder) void {
    b.addLib(.{
        .name = "glfw",
        .entry_point = "glfw.zig",
        .links = &[_][]const u8{
            "c",
            "glfw",
        },
    });
}
