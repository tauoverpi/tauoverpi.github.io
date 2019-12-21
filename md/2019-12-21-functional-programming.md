---
title: Functional Programming
...

<div class="container">
<p class="notice">NOTICE: Document not complete</p>
### List

```{.hs #list}
data List a = Nil | Cons a (List a)
```

```{.hs #list}
infixr 6 Cons as :
```

### Type Classes

```{.hs #class-semigroup}
class Semigroup a where
    append :: a -> a -> a
```

```{.hs #class-monoid}
class Semigroup a <= Monoid a where
    mempty :: a
```

```{.hs #base-classes}
class Functor f where
    map :: forall a b. (a -> b) -> f a -> f b
```

```{.hs #base-classes}
class Pure f where
    pure :: forall a. a -> f a
```

```{.hs #base-classes}
class Functor f <= Apply fwhere
    ap :: forall a b. f (a -> b) -> f a -> f b
```

```{.hs #base-classes}
class (Apply f, Pure f) <= Applicative where
```

Lazy Evaluation
---------------

Lazy evaluation opens up a world of new patterns of infinite structure allowing
for a truly declarative style. With lazy semantics it's possible to write types
such as `Stream` which represents infinite lists, `Wire` representing time
varying values in intinite stepped computations, and so on.

In this section we'll be implementing our own lazy evaluation library and see
how instances change along with concerns involving the performance of such. It
includes one purescript module `Data.Lazy`.

```{.hs file=src/purescript/FunctionalProgramming/Data/Lazy.purs}
module Lazy where
<<lazy-definition>>
<<lazy-numerical-instances>>
```

And one javascript module implementing the runtime.

```{.hs file=src/purescript/FunctionalProgramming/Data/Lazy.js}
<<lazy-js-definition>>
```

### Definition

We begin by declaring an abstract type `Lazy` to represent defered computation.

```{.hs #lazy-definition}
foreign import data Lazy :: Type -> Type
```

Since lazy evaluation is external to purescript it won't be able to deconstruct
`Lazy` inside purescript. Instead we'll define `defer` taking a closure which
it turns into a thunk to be evaluated later and `force` which evaluates the
thunk in javascript.

```{.hs #lazy-definition}
foreign import defer :: a -> Lazy a
foreign import force :: Lazy a -> a
```

The machinery behind lazy evaluation is captured by `defer` which makes use of
mutable state behind the scenes.

First `defer` allocates a mutable variable `value` which will house the result
once computed and takes a computation `thunk` which when run will give that
value. Then `value` is captured in a new closure `lazy-js-closure` containing
the thunk to be run later.

```{.js #lazy-js-definition}
exports.defer = function(thunk) {
    var value = null;
    return <<lazy-js-closure>>
}
```

Upon the first execution of `lazy-js-closure` the `thunk` is defined and `value`
is `null` thus the condition doesn't fire. The sequence continues with setting
`value` to the result of evaluating `thunk` and clearing `thunk` allowing the
computation to be freed from memory before returing the result. For every use
after `thunk` will still be `undefined` and `value` set which causes the
condition to fire and result returned without recomputing `value`.

```{.js #lazy-js-closure}
function () {
    if (thunk === undefined) return value;
    value = thunk();
    thunk = undefined;
    return value;
}
```

By keeping the result around and throwing away the computation thunk we've
implemented sharing of immutable values and on-demand evaluation which is the
core of lazy evaluation.
<details>
<summary>note</summary>
<p class="notice">There are other ways to implement lazy evaluation besides the
one shown here. For example, a compiler may inline the conditional branch at
the location of `force` along with procedures called after to eliminate the
overhead of calling. However, implementation of such is out of scope for this
article.</p>
</details>


`force` is considerably simpler in it's definition. The closure ready to be
evaluated, `force` only needs to invoke it to get the result.

```{.js #lazy-js-definition}
exports.force = function(closure) {
    return closure();
}
```

### Numerical Instances
### Functor & Applicative Instances

Stream
------

### Definition

```{.hs #stream-definition}
data Stream a = Cons a (Lazy (Stream a))
```

Wire
----

`Stream` is great for tasks where you can define the set of possible values up
front while not taking into account the past states. While this works great for
random numbers, spreadsheets, and similar it doesn't fare so well when we need
that state. Wires are stateful where the next value is derived from an input
value and the past state while keeping the properties we like of streams.

This section covers the design and implementation of the `Control.Wire` library
along with the many utilities that come with it and since this is a pure
purescript module there are only a few files to keep track of.

`Data.Wire` exports the wire prelude consisting of a collection of support
modules and the most frequently used wires.

```{.hs file=src/purescript/FunctionalProgramming/Control/Wire.purs}
module Wire (module X) where
import Control.Wire.Core as X
import Control.Wire.Event as X
```

### Definition

```{.hs #wire-definition}
data Wire m a b =
    Wire (a -> m (Pair (Lazy (Wire m a b)) b))
```

### Events


IO
--

```{.hs #io}
foreign import data IO :: Type -> Type

foreign import pureIO :: forall a. a -> IO a
foreign import apIO :: forall a b. IO (a -> b) -> IO a -> IO b
foreign import mapIO :: forall a b. (a -> b) -> IO a -> IO b
foreign import bindIO :: forall a b. IO a -> (a -> IO b) -> IO b

instance Functor IO where
    map = mapIO

instance Apply IO where
    ap = apIO
```

### Canvas

```{.hs}
foreign import data Canvas :: Type
foreign import data Context2D :: Type
foreign import createCanvas :: Int -> Int -> String -> IO Canvas
foreign import getContext2D :: Canvas -> IO Context2D
foreign import setCtxFillStyle :: String -> IO Unit
foreign import setCtxFillRect :: Int -> Int -> Int -> Int -> IO Unit
```

### Animation

```{.hs}
foreign import requestAnimationFrame :: (Unit -> IO Unit) -> IO Unit
```

</div>
