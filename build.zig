const std = @import("std");
const Build = std.Build;

pub fn build(
    b: *Build,
) void {
    const stbi = b.addModule("stbi", .{
        .root_source_file = b.path("src/stbi.zig"),
        .link_libc = true,
    });

    const stbiDep = b.dependency("stbi", .{});
    stbi.addIncludePath(stbiDep.path(&.{}));
    const implName = "stbiImpl.c";
    const write = b.addWriteFile(implName,
        \\#define STB_IMAGE_IMPLEMENTATION
        \\#include "stb_image.h"
    );
    stbi.addCSourceFile(.{
        .file = write.getDirectory().path(b, implName),
        .flags = &.{},
    });
}
