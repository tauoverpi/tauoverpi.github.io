// ------ language="JavaScript" file="projects/zig/zig-on-the-web/src/window.js" project://article.md#447
const getString = (p, len) =>
  (new TextDecoder()).decode(app.exports.memory.buffer.slice(p, p + len));

var app = {
  imports: {
    window: {
      alert: (p, len) => alert(getString(p, len)),
    },
  },
  launch: r => {
    app.exports = r.instance.exports;
    if (!app.exports.launch()) throw "Launch Error";
  },
  exports: undefined,
};
// ------ end
