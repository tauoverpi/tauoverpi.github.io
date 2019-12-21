---
title: Interactive Documents
...

<div class="container">
<p class="notice">NOTICE: Document not complete</p>

Functional Programming
----------------------

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

### Type Classes Continued

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

### IO

<p class="guest">The example</p> <p class="me">well maybe not</p>

```{.hs #io}
foreign import data IO :: Type -> Type

foreign import pureIO :: forall a. a -> IO a
foreign import apIO :: forall a b. IO (a -> b) -> IO a -> IO b
foreign import mapIO :: forall a b. (a -> b) -> IO a -> IO b
foreign import bindIO :: forall a b. IO a -> (a -> IO b) -> IO b
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

```{.hs file=src/purescript/InteractiveDocuments/ID.purs}
module ID where
<<classes>>
```

</div>
