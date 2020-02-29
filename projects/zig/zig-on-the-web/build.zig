// ------ language="Zig" file="projects/zig/zig-on-the-web/build.zig" project://article.md#362
// ------ begin <<zotw-imports>>[0] project://article.md#344
const Builder = @import("std").build.Builder;
// ------ end
// ------ begin <<zotw-imports>>[1] project://article.md#352
const builtin = @import("builtin");
// ------ end
pub fn build(b: *Builder) void {

    // ------ begin <<zotw-add-test-hook>>[0] project://article.md#406
    var main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);
    // ------ end
    // ------ begin <<zotw-add-test-hook>>[1] project://article.md#416
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
    // ------ end
}
// ------ end
