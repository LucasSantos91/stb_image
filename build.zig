const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});
    const stb_dep = b.dependency("stb", .{});
    const stbi_path = stb_dep.path("stb_image.h");
    const translate = b.addTranslateC(.{
        .root_source_file = stbi_path,
        .optimize = optimize,
        .target = target,
    });
    const stbi_module = b.addModule("stbi", .{
        .root_source_file = translate.getOutput(),
        .optimize = optimize,
        .target = target,
        .link_libc = true,
    });
    stbi_module.addCSourceFile(.{
        .file = stbi_path,
        .language = .c,
    });
    stbi_module.addCMacro("STB_IMAGE_IMPLEMENTATION", "1");
    if (optimize != .Debug) {
        stbi_module.addCMacro("NDEBUG", "1");
        translate.defineCMacro("NDEBUG", "1");
    }
}
