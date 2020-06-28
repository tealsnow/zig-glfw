const root = @import("root");

pub usingnamespace if (@hasDecl(root, "glfw_c"))
    root.glfw_c
else
    @cImport({
        @cInclude("GLFW/glfw3.h");
    });
