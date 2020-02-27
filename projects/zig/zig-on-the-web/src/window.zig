// ------ language="Zig" file="projects/zig/zig-on-the-web/src/window.zig" project://article.md#412
extern fn _alert(msg: [*]const u8, len: usize) void;

pub fn alert(msg: []u8) void {
  _alert(msg, msg.len);
}
// ------ end
