// ------ language="Zig" file="projects/zig/zig-on-the-web/build.zig" project://article.md#337
// ------ begin <<zotw-imports>>[0] project://article.md#319
const Builder = @import("std").build.Builder;
// ------ end
// ------ begin <<zotw-imports>>[1] project://article.md#327
const builtin = @import("builtin");
// ------ end
pub fn build(b: *Builder) void {

    // ------ begin <<zotw-add-test-hook>>[0] project://article.md#381
    var main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);
    // ------ end
    // ------ begin <<zotw-add-test-hook>>[1] project://article.md#391
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
    // ------ end
}
// ------ end
