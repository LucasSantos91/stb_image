const std = @import("std");
const Build = std.Build;

pub fn build(
    b: *Build,
) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const strip = b.option(
        bool,
        "strip",
        "Strip debug info.",
    ) orelse (optimize != .Debug);

    const stbi = b.addModule("stbi", .{
        .root_source_file = b.path("src/stbi.zig"),
        .optimize = optimize,
        .target = target,
        .link_libc = true,
        .strip = strip,
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
