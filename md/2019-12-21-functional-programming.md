---
title: Functional Programming
...

<div class="container">
<p class="notice">NOTICE: Document not complete</p>

Base Data Types
---------------

### Maybe

```{.hs #maybe-definition}
data Maybe a = Just a | Nothing
```

### List

```{.hs #list-definition}
data List a = Nil | Cons a (List a)
```

Lists work fine as long as list items remain small.

```{.hs #lazy-list-definition}
data LazyList a = LNil
                | LCons (Lazy (Pair a (LazyList a)))
```

```{.hs #list}
infixr 6 Cons as :
```

### Array

Basic Type Classes
------------------

### Basic



```{.hs #class-semigroup}
class Semigroup a where
    append :: a -> a -> a
```

```{.hs #class-monoid}
class Semigroup a <= Monoid a where
    mempty :: a
```

#### Basic Instances


### Utility

Some functions may diverge towards `_|_` when given certain values such as
dividing by zero which raises an exception. Thus `Partial` is defined as a
nullary class which act as a compile-time assertion that a function and any
dervived form it are partial.

```{.hs #partial-definition}
class Partial where
```

Conversion between types is common and `Cast` collects the most usual between
any two given types. Being a utility class it has no use other than being
convenient.

```{.hs #cast-definition}
class Cast from to where
    cast :: from -> to
```

Some casts may be partial thus require a version capable of failure. If an
instance is safe by default the implementation is the same as `Cast` wrapped in
a `Just`.

```{.hs #safe-cast-definition}
class SafeCast from to where
    safeCast :: from -> Maybe to
```

#### Utility Instances

Conversion from a `LazyList` requires forcing every element of the list.

```{.hs #cast-lazylist-list}
instance Cast (LazyList a) (List a) where
    cast LNil = Nil
    cast (LCons ls) =
        let Pair x ls' = force ls in x : cast ls
```
<p class="warning">CAUTION: Passing an infinite list to `cast` results in
`_|_`
</p>

```{.hs #cast-lazylist-list}
instance SafeCast (LazyList a) (List a) where
    safeCast = Just <<< cast
```
<p class="warning">CAUTION: Passing an infinite list to `safeCast` results in
`_|_`
</p>

```{.hs #cast-lazylist-list}
instance Cast (List a) (LazyList a) where
    cast Nil = LNil
    cast (Cons x xs) =
        LCons (defer \_ -> Pair x (cast xs))

instance SafeCast (List a) (LazyList a) where
    safeCast = Just <<< cast
```

Numerical Type Classes
----------------------

### Division
#### Division Implementation

```{.hs #int-div-implementation}
foreign import intDiv :: Partial => Int -> Int -> Int
```

```{.js #int-div-ffi-implementation}
exports.intDiv = function (x) {
  return function (y) {
    if (y === 0) throw "NaN";
    return y > 0 ? Math.floor(x / y) : -Math.floor(x / -y);
  }
}
```

```{.hs #int-div-implementation}
foreign import intSafeDiv :: Int -> Int -> Int
```

```{.js #int-safe-div-ffi-implementation}
exports.intSafeDiv = function (x) {
  return function (y) {
    if (y === 0) return 0;
    return y > 0 ? Math.floor(x / y) : -Math.floor(x / -y);
  }
}
```


Higher Kinded Type Classes
--------------------------

### Functor

```{.hs #base-classes}
class Functor f where
    map :: forall a b. (a -> b) -> f a -> f b
```

#### Functor Instances

### Applicative

```{.hs #base-classes}
class Pure f where
    pure :: forall a. a -> f a
```

```{.hs #base-classes}
class Functor f <= Apply f where
    ap :: forall a b. f (a -> b) -> f a -> f b
```

```{.hs #base-classes}
class (Apply f, Pure f) <= Applicative where
```

```{.hs}
class Applicative f <= Selective f where
    select :: f (Either a b) -> f (a -> b) -> f b
```

#### Applicative Instances

### Monad

```{.hs #bind-definition}
class Apply m <= Bind m where
    bind :: m a -> (a -> m b) -> m b
infixl 1 bind as >>=
```

```{.hs}
class (Bind m, Selective m) <= Monad m where

join :: m (m a) -> m a
join m = m >>= id
```

#### Monad Instances

### Comonad

```{.hs #comonad-definition}
class Comonad w where
    extract :: w a -> a
    extend :: (w a -> b) -> w a -> w b
    duplicate :: w a -> w (w a)
```

#### Comonad Instances

### Foldable

```{.hs #foldable-definition}
class Foldable f where
    foldr :: forall t a b. (a -> b -> b) -> b -> t a -> b
    foldl :: forall t a b. (b -> a -> b) -> b -> t a -> b
```

```{.hs #recursive-definition}
type Algebra f t = f t -> t
class Functor f <= Recursive f t | f -> t where
    project :: t -> f t
```

#### Foldable Instances

```
cata :: forall f t a. Recursive f t => Algebra f a -> t -> a
cata f = c where c x = f (map c (project x))
```

### Unfoldable

```{.hs #corecursive-definition}
type CoAlgebra f t = t -> f t
class Functor f <= CoRecursive f t | f -> t where
    embed :: f t -> t
```

#### Unfoldable Instances

```
ana :: forall f t a. CoRecursive f t => CoAlgebra f a -> a -> t
ana g = a where a x = embed (map a (g x))
```

Categories
----------

### Category

```{.hs #semigroupoid-definition}
class Semigroupoid k where
    compose :: k b c -> k a b -> k a c

infixr 10 compose as <<<

flippedCompose :: Semigroupoid k => k a b -> k b c -> k a c
flippedCompose = flip compose

infixl 10 compose as >>>
```

```{.hs #category-definition}
class Semigroupoid k <= Category k where
    id :: k a a
```

```{.hs #cartesian-definition}
class Category k <= Cartesian k where
    fst :: k (Pair a b) a
    snd :: k (Pair a b) b
    dup :: k a (Pair a a)
```

```{.hs #cocartesian-definition}
class Category k <= CoCartesian k where
    left :: k a (Either a b)
    right :: k b (Either a b)
    jam :: k (Either a a) a
```

```{.hs #closed-definition}
class (CoCartesian k, Cartesian k) <= Closed k where
    apply :: k (Pair (k a b) a) b
    curry :: k (k a b) c -> k a (k b c)
    uncurry :: k a (k b c) -> k (k a b) c
```

```{.hs #terminal-definition}
class Terminal k where
    it :: k a Unit
```


#### Category Instances

```{.hs #semigroupoid-function-instance}
instance Semigroupoid (->) where
    compose f g x = f (g x)
```
```{.hs #category-function-instance}
instance Category (->) where
    id x = x
```

```{.hs #cartesian-function-instance}
instance Cartesian (->) where
    fst (Pair a _) = a
    snd (Pair _ b) = b
    dup a = Pair a a
```

```{.hs #terminal-function-instance}
instance Terminal (->) where
    it _ = Unit
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
article.
</p>
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

Hash
----

### Definition

#### FNV1a

```hs
class FNV1a a where
    fnv1a32 :: a -> Int -> Int
```

### djb2

Stream
------

### Definition

```{.hs #stream-definition}
data Stream a = SCons (Lazy (Pair a (Stream a)))
```

```{.hs #stream-cast}
instance Cast (Stream a) (LazyList a) where
    cast (SCons s) = LCons (delay \_ ->
        let Pair x ss = force s in
            Pair x (cast ss))
```
<details>
<summary>note</summary>
<p class="notice">While it's possible to create an instance of `safeCast` for
`LazyList` to `Stream` casts it's inefficient and doesn't result in any
advantages over using `LazyList` directly.
</p>
</details>


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

`Control.Wire` exports the wire prelude consisting of a collection of support
modules and the most frequently used wires.

```{.hs file=src/purescript/FunctionalProgramming/Control/Wire.purs}
module Control.Wire (module X) where
import Control.Wire.Core as X
import Control.Wire.Event as X
```

`Control.Wire.Core` exports the core data structure and definitions.

```{.hs file=src/purescript/FunctionalProgramming/Control/Wire/Core.purs}
module Control.Wire.Core where
<<wire-definition>>
```

### Definition

```{.hs #wire-definition}
data Wire m a b where
    Wire (a -> m (Pair (Lazy (Wire m a b)) b))
```

```{.hs #wire-semigroupoid}
instance Semigroupoid (Wire m) where
    compose (Wire f) (Wire g) = Wire \x ->
        let Pair g' x' = g x
            Pair f' x'' = f x'
         in Pair (compose (force f') (force g')) x''
```

```{.hs #wire-category}
instance Category (Wire m) where
    id = Wire \x -> Pair (delay \_ -> id) x
```

```{.hs #wire-loop}
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
