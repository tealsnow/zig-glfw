# Zig GLFW Wrapper

A wrapper library for the GLFW3 library in the Zig programming language.

## Installation

Since Zig does not have a package manager yet, it is recommended to bring in
this dependency as a Git submodule:

```sh
mkdir -p deps/
git submodule add https://github.com/ziglang-contrib/glfw deps/glfw
```

To use, add the following to your `build.zig` configuration file, replacing
`my_exe` with the `LibExeObjStep` upon which to link GLFW3.

```zig
// Required by GLFW3
my_exe.linkLibC();
my_exe.linkSystemLibrary("glfw");
my_exe.addPackagePath("glfw", "./deps/glfw/glfw.zig");
```

To import this package, simply to the following:

```zig
const glfw = @import("glfw");
```

## API Naming Conventions

All symbols from GLFW3 have been renamed to use a more Zig standardised naming
scheme.

All functions now use a camelCase naming conversion with the `glfw` prefix
removed.

`GLFWwindow` and `GLFWmonitor` both have a wrapper struct named `Window` and
`Monitor` respectively.

All functions pertaining to windows and monitors have been moved to their
respective wrapper structs.

## Examples

For examples of use, please consult the files in the `example/` directory.
