const std = @import("std");
const mem = std.mem;

const c = @import("./c.zig");
const glfw = @import("./main.zig");

pub const Window = struct {
    const Self = @This();

    handle: *c.GLFWwindow,

    pub const ClientApi = enum(i32) {
        OpenGLApi   = c.GLFW_OPENGL_API,
        OpenGLESApi = c.GLFW_OPENGL_ES_API,
        NoApi       = c.GLFW_NO_API,
    };

    pub const ContextCreationApi = enum(i32) {
        NativeContextApi    = c.GLFW_NATIVE_CONTEXT_API,
        EGLContextApi       = c.GLFW_EGL_CONTEXT_API,
        OSMesaContextApi    = c.GLFW_OSMESA_CONTEXT_API,
    };

    pub const ContextRobustness = enum(i32) {
        NoRobustness        = c.GLFW_NO_ROBUSTNESS,
        NoResetNotification = c.GLFW_NO_RESET_NOTIFICATION,
        LoseContextOnReset  = c.GLFW_LOSE_CONTEXT_ON_RESET,
    };

    pub const ContextReleaseBehavior = enum(i32) {
        AnyReleaseBehavior      = c.GLFW_ANY_RELEASE_BEHAVIOR,
        ReleaseBehaviorFlush    = c.GLFW_RELEASE_BEHAVIOR_FLUSH,
        ReleaseBehaviorNone     = c.GLFW_RELEASE_BEHAVIOR_NONE,
    };

    pub const OpenGLProfile = enum(i32) {
        OpenGLAnyProfile = c.GLFW_OPENGL_ANY_PROFILE,
        OpenGLCompatProfile = c.GLFW_OPENGL_COMPAT_PROFILE,
        OpenGLCoreProfile = c.GLFW_OPENGL_CORE_PROFILE,
    };

    pub const HintName = enum(i32) {
        Resizable               = c.GLFW_RESIZABLE,
        Visible                 = c.GLFW_VISIBLE,
        Decorated               = c.GLFW_DECORATED,
        Focused                 = c.GLFW_FOCUSED,
        AutoIconify             = c.GLFW_AUTO_ICONIFY,
        Floating                = c.GLFW_FLOATING,
        Maximized               = c.GLFW_MAXIMIZED,
        CenterCursor            = c.GLFW_CENTER_CURSOR,
        // TransparentFramebuffer  = c.GLFW_TRANPARENT_FRAMEBUFFER,
        FocusOnShow             = c.GLFW_FOCUS_ON_SHOW,
        ScaleToMonitor          = c.GLFW_SCALE_TO_MONITOR,
        RedBits                 = c.GLFW_RED_BITS,
        GreenBits               = c.GLFW_GREEN_BITS,
        BlueBits                = c.GLFW_BLUE_BITS,
        AlphaBits               = c.GLFW_ALPHA_BITS,
        AccumRedBits            = c.GLFW_ACCUM_RED_BITS,
        AccumGreenBits          = c.GLFW_ACCUM_GREEN_BITS,
        AccumBlueBits           = c.GLFW_ACCUM_BLUE_BITS,
        AccumAlphaBits          = c.GLFW_ACCUM_ALPHA_BITS,
        AuxBuffers              = c.GLFW_AUX_BUFFERS,
        Stereo                  = c.GLFW_STEREO,
        Samples                 = c.GLFW_SAMPLES,
        SRGBCapable             = c.GLFW_SRGB_CAPABLE,
        DoubleBuffer            = c.GLFW_DOUBLEBUFFER,
        RefreshRate             = c.GLFW_REFRESH_RATE,
        ClientApi               = c.GLFW_CLIENT_API,
        ContextCreationApi      = c.GLFW_CONTEXT_CREATION_API,
        ContextVersionMajor     = c.GLFW_CONTEXT_VERSION_MAJOR,
        ContextVersionMinor     = c.GLFW_CONTEXT_VERSION_MINOR,
        OpenGLForwardCompat     = c.GLFW_OPENGL_FORWARD_COMPAT,
        OpenGLDebugContext      = c.GLFW_OPENGL_DEBUG_CONTEXT,
        OpenGLProfile           = c.GLFW_OPENGL_PROFILE,
        ContextRobustness       = c.GLFW_CONTEXT_ROBUSTNESS,
        ContextReleaseBehavior  = c.GLFW_CONTEXT_RELEASE_BEHAVIOR,
        // ContextNoError          = c.GLFW_CONTEXT_NO_ERROR,
        CocoaRetinaFramebuffer  = c.GLFW_COCOA_RETINA_FRAMEBUFFER,
        CocoaFrameName          = c.GLFW_COCOA_FRAME_NAME,
        CocoaGraphicsSwitching  = c.GLFW_COCOA_GRAPHICS_SWITCHING,
        X11ClassName            = c.GLFW_X11_CLASS_NAME,
        X11InstanceName         = c.GLFW_X11_INSTANCE_NAME,
    };

    pub const Hint = union(HintName) {
        Resizable: bool,
        Visible: bool,
        Decorated: bool,
        Focused: bool,
        AutoIconify: bool,
        Floating: bool,
        Maximized: bool,
        CenterCursor: bool,
        // TransparentFramebuffer: bool,
        FocusOnShow: bool,
        ScaleToMonitor: bool,
        RedBits: ?i32,
        GreenBits: ?i32,
        BlueBits: ?i32,
        AlphaBits: ?i32,
        // DepthBits: ?i32,
        // StencilBits: ?i32,
        AccumRedBits: ?i32,
        AccumGreenBits: ?i32,
        AccumBlueBits: ?i32,
        AccumAlphaBits: ?i32,
        AuxBuffers: ?i32,
        Samples: ?i32,
        RefreshRate: ?i32,
        Stereo: bool,
        SRGBCapable: bool,
        DoubleBuffer: bool,
        ClientApi: ClientApi,
        ContextCreationApi: ContextCreationApi,
        ContextVersionMajor: i32,
        ContextVersionMinor: i32,
        ContextRobustness: ContextRobustness,
        ContextReleaseBehavior: ContextReleaseBehavior,
        OpenGLForwardCompat: bool,
        OpenGLDebugContext: bool,
        OpenGLProfile: OpenGLProfile,
        CocoaRetinaFramebuffer: bool,
        CocoaFrameName: [:0]const u8,
        CocoaGraphicsSwitching: bool,
        X11ClassName: [:0]const u8,
        X11InstanceName: [:0]const u8,
    };

    pub fn defaultHints() void {
        c.glfwDefaultWindowHints();

        glfw.getError() catch |err| switch (err) {
            .NotInitialized => return err,
            else => unreachable,
        };
    }

    pub fn hint(h: Hint) !void {
        switch (h) {
            .Resizable              => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .Visible                => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .Decorated              => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .Focused                => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .AutoIconify            => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .Floating               => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .Maximized              => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .CenterCursor           => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            // .TransparentFramebuffer => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .FocusOnShow            => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .ScaleToMonitor         => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .RedBits                => |value| c.glfwWindowHint(@enumToInt(h), toGLFWInt(value)),
            .GreenBits              => |value| c.glfwWindowHint(@enumToInt(h), toGLFWInt(value)),
            .BlueBits               => |value| c.glfwWindowHint(@enumToInt(h), toGLFWInt(value)),
            .AlphaBits              => |value| c.glfwWindowHint(@enumToInt(h), toGLFWInt(value)),
            // .DepthBits              => |value| c.glfwWindowHint(@enumToInt(hint), toGLFWInt(value)),
            // .StencilBits            => |value| c.glfwWindowHint(@enumToInt(hint), toGLFWInt(value)),
            .AccumRedBits           => |value| c.glfwWindowHint(@enumToInt(h), toGLFWInt(value)),
            .AccumGreenBits         => |value| c.glfwWindowHint(@enumToInt(h), toGLFWInt(value)),
            .AccumBlueBits          => |value| c.glfwWindowHint(@enumToInt(h), toGLFWInt(value)),
            .AccumAlphaBits         => |value| c.glfwWindowHint(@enumToInt(h), toGLFWInt(value)),
            .AuxBuffers             => |value| c.glfwWindowHint(@enumToInt(h), toGLFWInt(value)),
            .Samples                => |value| c.glfwWindowHint(@enumToInt(h), toGLFWInt(value)),
            .RefreshRate            => |value| c.glfwWindowHint(@enumToInt(h), toGLFWInt(value)),
            .Stereo                 => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .SRGBCapable            => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .DoubleBuffer           => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .ClientApi              => |value| c.glfwWindowHint(@enumToInt(h), @enumToInt(value)),
            .ContextCreationApi     => |value| c.glfwWindowHint(@enumToInt(h), @enumToInt(value)),
            .ContextVersionMajor    => |value| c.glfwWindowHint(@enumToInt(h), toGLFWInt(value)),
            .ContextVersionMinor    => |value| c.glfwWindowHint(@enumToInt(h), toGLFWInt(value)),
            .ContextRobustness      => |value| c.glfwWindowHint(@enumToInt(h), @enumToInt(value)),
            .ContextReleaseBehavior => |value| c.glfwWindowHint(@enumToInt(h), @enumToInt(value)),
            .OpenGLForwardCompat    => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .OpenGLDebugContext     => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .OpenGLProfile          => |value| c.glfwWindowHint(@enumToInt(h), @enumToInt(value)),
            .CocoaRetinaFramebuffer => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .CocoaFrameName         => |value| c.glfwWindowHintString(@enumToInt(h), value.ptr),
            .CocoaGraphicsSwitching => |value| c.glfwWindowHint(@enumToInt(h), toGLFWBool(value)),
            .X11ClassName           => |value| c.glfwWindowHintString(@enumToInt(h), value.ptr),
            .X11InstanceName        => |value| c.glfwWindowHintString(@enumToInt(h), value.ptr),
        }

        glfw.getError() catch |err| switch (err) {
            error.NotInitialized => return err,
            else => unreachable,
        };
    }

    pub const AttributeName = enum(i32) {
        Focused                 = c.GLFW_FOCUSED,
        Iconified               = c.GLFW_ICONIFIED,
        Maximized               = c.GLFW_MAXIMIZED,
        Hovered                 = c.GLFW_HOVERED,
        Visible                 = c.GLFW_VISIBLE,
        Resizable               = c.GLFW_RESIZABLE,
        Decorated               = c.GLFW_DECORATED,
        AutoIconify             = c.GLFW_AUTO_ICONIFY,
        Floating                = c.GFLW_FLOATING,
        TransparentFramebuffer  = c.GLFW_TRANPARENT_FRAMEBUFFER,
        FocusOnShow             = c.GLFW_FOCUS_ON_SHOW,
        ClientApi               = c.GLFW_CLIENT_API,
        ContextCreationApi      = c.GLFW_CONTEXT_CREATION_API,
        ContextVersionMajor     = c.GLFW_CONTEXT_VERSION_MAJOR,
        ContextVersionMinor     = c.GLFW_CONTEXT_VERSION_MINOR,
        ContextRevision         = c.GLFW_CONTEXT_REVISION,
        OpenGLForwardCompat     = c.GLFW_OPENGL_FORWARD_COMPAT,
        OpenGLDebugContext      = c.GLFW_OPENGGL_DEBUG_CONTEXT,
        OpenGLProfile           = c.GLFW_OPENGL_PROFILE,
        ContextReleaseBehavior  = c.GLFW_CONTEXT_RELEASE_BEHAVIOR,
        ContextNoError          = c.GLFW_CONTEXT_NO_ERROR,
        ContextRobustness       = c.GLFW_CONTEXT_ROBUSTNESS,
    };

    pub const Attribute = union(AttributeName) {
        Focused: bool,
        Iconified: bool,
        Maximized: bool,
        Hovered: bool,
        Visible: bool,
        Resizable: bool,
        Decorated: bool,
        AutoIconify: bool,
        Floating: bool,
        TransparentFramebuffer: bool,
        FocusOnShow: bool,
        ClientApi: ClientApi,
        ContextCreationApi: ContextCreationApi,
        ContextVersionMajor: i32,
        ContextVersionMinor: i32,
        ContextRevision: i32,
        OpenGLForwardCompat: bool,
        OpenGLDebugContext: bool,
        OpenGLProfile: OpenGLProfile,
        ContextReleaseBehavior: ContextReleaseBehavior,
        ContextNoError: bool,
        ContextRobustness: ContextRobustness,
    };

    pub fn getAttrib(self: Self, attrib: AttributeName) !Attribute {
        var attribute = blk: { switch (attrib) {
            .Focused
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .Focused = value == c.GLFW_TRUE };
                },
            .Iconified
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .Iconified = value == c.GLFW_TRUE };
                },
            .Maximized
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .Maximized = value == c.GLFW_TRUE };
                },
            .Hovered
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .Hovered = value == c.GLFW_TRUE };
                },
            .Visible
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .Visible = value == c.GLFW_TRUE };
                },
            .Resizable
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .Resizable = value == c.GLFW_TRUE };
                },
            .Decorated
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .Decorated = value == c.GLFW_TRUE };
                },
            .AutoIconify
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .AutoIconify = value == c.GLFW_TRUE };
                },
            .Floating
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .Floating = value == c.GLFW_TRUE };
                },
            .TransparentFramebuffer
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .TransparentFramebuffer = value == c.GLFW_TRUE };
                },
            .FocusOnShow
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .FocusOnShow = value == c.GLFW_TRUE };
                },
            .ClientApi
                => {
                    var value = @intToEnum(ClientApi, c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib)));
                    break :blk Attribute{ .ClientApi = value, };
                },
            .ContextCreationApi
                => {
                    var value = @intToEnum(ContextCreationApi, c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib)));
                    break :blk Attribute{ .ContextCreationApi = value, };
                },
            .ContextVersionMajor
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .ContextVersionMajor = value, };
                },
            .ContextVersionMinor
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .ContextVersionMinor = value, };
                },
            .ContextRevision
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .ContextRevision = value, };
                },
            .OpenGLForwardCompat
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .OpenGLForwardCompat = value == c.GLFW_TRUE };
                },
            .OpenGLDebugContext
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .OpenGLDebugContext = value == c.GLFW_TRUE };
                },
            .OpenGLProfile
                => {
                    var value = @intToEnum(OpenGLProfile, c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib)));
                    break :blk Attribute{ .OpenGLProfile = value, };
                },
            .ContextReleaseBehavior
                => {
                    var value = @intToEnum(ContextReleaseBehavior, c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib)));
                    break :blk Attribute{ .ContextReleaseBehavior = value, };
                },
            .ContextNoError
                => {
                    var value = c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib));
                    break :blk Attribute{ .ContextNoError = value == c.GLFW_TRUE };
                },
            .ContextRobustness
                => {
                    var value = @intToEnum(ContextRobustness, c.glfwGetWindowAttrib(self.handle, @enumToInt(attrib)));
                    break :blk Attribute{ .ContextRobustness = value, };
                },
        } };

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };

        return attribute;
    }

    pub fn setAttrib(self: *Self, attribute: Attribute) !void {
        switch (attribute) {
            Resizable               => |value| c.glfwSetWindowAttrib(self.handle, @enumToInt(attribute), toGLFWBool(value)),
            Decorated               => |value| c.glfwSetWindowAttrib(self.handle, @enumToInt(attribute), toGLFWBool(value)),
            AutoIconify             => |value| c.glfwSetWindowAttrib(self.handle, @enumToInt(attribute), toGLFWBool(value)),
            Floating                => |value| c.glfwSetWindowAttrib(self.handle, @enumToInt(attribute), toGLFWBool(value)),
            FocusOnShow             => |value| c.glfwSetWindowAttrib(self.handle, @enumToInt(attribute), toGLFWBool(value)),
            else => std.debug.panic("unsupported attribute in setter"),
        }

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };
    }

    inline fn toGLFWBool(value: bool) i32 {
        return if (value) c.GLFW_TRUE else c.GLFW_FALSE;
    }

    inline fn toGLFWInt(value: ?i32) i32 {
        return if (value) |v| v else c.GLFW_DONT_CARE;
    }

    pub fn init(width: i32, height: i32, title: [:0]const u8, monitor: ?glfw.Monitor, share: ?glfw.Window) !Self {
        var handle = c.glfwCreateWindow(width, height, title.ptr, if (monitor) |m| m.handle else null, if (share) |s| s.handle else null);

        if (handle == null) {
            glfw.getError() catch |err| switch (err) {
                glfw.Error.NotInitialized,
                glfw.Error.InvalidValue,
                glfw.Error.ApiUnavailable,
                glfw.Error.VersionUnavailable,
                glfw.Error.FormatUnavailable,
                glfw.Error.PlatformError => return err,
                else => unreachable,
            };
        }

        return Self{ .handle = handle.? };
    }

    pub fn deinit(self: *Self) void {
        c.glfwDestroyWindow(self.handle);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => std.debug.panic("cannot handle: {}\n", .{ err }),
            else => unreachable,
        };
    }

    pub fn shouldClose(self: Self) !bool {
        var result = c.glfwWindowShouldClose(self.handle);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized => return err,
            else => unreachable,
        };

        return result == c.GLFW_TRUE;
    }

    pub fn setShouldClose(self: *Self, value: bool) !void {
        c.glfwSetWindowShouldClose(self.handle, toGLFWBool(value));

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized => return err,
            else => unreachable,
        };
    }

    pub fn setTitle(self: *Self, title: [:0]const u8) !void {
        c.glfwSetWindowTitle(self.handle, title.ptr);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };
    }

    pub fn setIcon(self: *Self, icon: glfw.Image) !void {
        return self.setIcons(&[1]glfw.Image{ icon });
    }

    pub fn setIcons(self: *Self, icons: []glfw.Image) !void {
        c.glfwSetWindowIcon(self.handle, @intCast(i32, icons.len), icons.ptr);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };
    }

    pub const Position = struct {
        x: i32,
        y: i32,
    };

    pub fn getPos(self: Self) !Position {
        var position: Position = undefined;

        c.glfwGetWindowPos(self.handle, &position.x, &position.y);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };

        return position;
    }

    pub fn setPos(self: *Self, position: Position) !void {
        c.glfwSetWindowPos(self.handle, position.x, position.y);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };
    }

    pub fn getSize(self: Self) !glfw.Size {
        var size: glfw.Size = undefined;

        c.glfwGetWindowSize(self.handle, &size.width, &size.height);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };

        return size;
    }

    pub fn setSize(self: Self, size: glfw.Size) !void {
        c.glfwSetWindowSize(self.handle, size.width, size.height);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };
    }

    pub fn setSizeLimits(self: *Self, min: ?glfw.Size, max: ?glfw.Size) !void {
        var minwidth: i32 = if (min) |m| m.width else c.GLFW_DONT_CARE;
        var minheight: i32 = if (min) |m| m.height else c.GLFW_DONT_CARE;
        var maxwidth: i32 = if (max) |m| m.width else c.GLFW_DONT_CARE;
        var maxheight: i32 = if (max) |m| m.height else c.GLFW_DONT_CARE;

        c.glfwSetWindowSizeLimits(self.handle, minwidth, minheight, maxwidth, maxheight);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };
    }

    pub fn setAspectRatio(self: *Self, aspect: ?glfw.Size) !void {
        if (aspect) |a| {
            c.glfwSetWindowAspectRatio(self.handle, a.width, a.height);
        } else {
            c.glfwSetWindowAspectRatio(self.handle, c.GLFW_DONT_CARE, c.GLFW_DONT_CARE);
        }

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };
    }

    pub fn getFramebufferSize(self: Self) !glfw.Size {
        var framebufferSize: glfw.Size = undefined;

        c.glfwGetFramebufferSize(self.handle, &framebufferSize.width, &framebufferSize.height);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };

        return framebufferSize;
    }

    pub fn getFrameSize(self: Self) !glfw.Bounds {
        var frameSize: glfw.Bounds = undefined;

        c.glfwGetWindowFrameSize(self.handle, &frameSize.left, &frameSize.top, &frameSize.right, &frameSize.bottom);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };

        return frameSize;
    }

    pub fn getContentScale(self: Self) !glfw.Scale {
        var scale: glfw.Scale = undefined;

        c.glfwGetWindowContentScale(self.handle, &scale.x, &scale.y);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };

        return scale;
    }

    pub fn getOpacity(self: Self) !f32 {
        var opacity = c.glfwGetWindowOpacity(self.handle);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };

        return opacity;
    }

    pub fn setOpacity(self: *Self, opacity: f32) !void {
        c.glfwSetWindowOpacity(self.handle, opacity);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };
    }

    pub fn iconify(self: *Self) !void {
        c.glfwIconifyWindow(self.handle);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };
    }

    pub fn restore(self: *Self) !void {
        c.glfwRestoreWindow(self.handle);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };
    }

    pub fn maximize(self: *Self) !void {
        c.glfwMaximizeWindow(self.handle);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };
    }

    pub fn show(self: *Self) !void {
        c.glfwShowWindow(self.handle);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };
    }

    pub fn hide(self: *Self) !void {
        c.glfwHideWindow(self.handle);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };
    }

    pub fn focus(self: *Self) !void {
        c.glfwFocusWindow(self.handle);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };
    }

    pub fn requestAttention(self: *Self) !void {
        c.glfwRequestWindowAttention(self.handle);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };
    }

    pub fn getMonitor(self: Self) !?glfw.Monitor {
        var handle = c.glfwGetWindowMonitor(self.handle);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };

        if (handle) |h| {
            return glfw.Monitor{ .handle = handle };
        } else {
            return null;
        }
    }

    pub fn setMonitor(self: *Self, monitor: ?glfw.Monitor, position: glfw.Position, size: glfw.Size, refreshRate: ?i32) !void {
        c.glfwSetWindowMonitor(self.handle, if (monitor) |m| m.handle else null, position.x, position.y, size.width, size.height, if (refreshRate) |rr| rr else c.GLFW_DONT_CARE);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError => return err,
            else => unreachable,
        };
    }

    pub fn setUserPointer(self: *Self, comptime T: type, pointer: ?*T) !void {
        c.glfwSetWindowUserPointer(self.handle, if (pointer) |ptr| @ptrToInt(ptr) else null);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized => return err,
            else => unreachable,
        };
    }

    pub fn getUserPointer(self: Self, comptime T: type) !?*T {
        var ptr = c.glfwGetWindowUserPointer(self.handle);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized => return err,
            else => unreachable,
        };

        if (ptr) |pointer| {
            return @intToPtr(*T, pointer);
        } else {
            return null;
        }
    }

    pub fn swapBuffers(self: *Self) !void {
        c.glfwSwapBuffers(self.handle);

        glfw.getError() catch |err| switch (err) {
            glfw.Error.NotInitialized,
            glfw.Error.PlatformError,
            glfw.Error.NoWindowContext => return err,
            else => unreachable,
        };
    }

    pub fn makeContextCurrent(self: *Self) void {
        c.glfwMakeContextCurrent(self.handle);
    }

    pub fn getKey(self: *Self, key: i32) bool {
        return c.glfwGetKey(self.handle, key) == 1;
    }
};
