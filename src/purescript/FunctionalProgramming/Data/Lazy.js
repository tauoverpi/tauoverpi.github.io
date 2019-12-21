-- ------ language="Haskell" file="src/purescript/FunctionalProgramming/Data/Lazy.js"
// ------ begin <<lazy-js-definition>>[0]
exports.defer = function(thunk) {
    var value = null;
    return <<lazy-js-closure>>
}
// ------ end
// ------ begin <<lazy-js-definition>>[1]
exports.force = function(closure) {
    return closure();
}
// ------ end
-- ------ end
