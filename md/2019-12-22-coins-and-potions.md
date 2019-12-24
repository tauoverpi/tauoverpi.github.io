---
title: Coins & Potions
...

<div class="container">
<p class="notice">NOTICE: Document not complete</p>

```{.hs #coins-and-potions}
data Item = Coin | Potion
```
The program consists of:

```{.hs file=src/haskell/CoinsAndPotions/CoinsAndPotions.hs}
<<modules-and-pragma>>
<<rng>>
<<coins-and-potions>>
<<logging>>
<<state>>
<<messages>>
<<object-structure>>
<<npc-implementation>>
<<player>>
<<gameboard>>
<<gameloop>>
```

Full source can be found
[here](https://github.com/tauoverpi/tauoverpi.github.io/tree/master/src/haskell/CoinsAndPotions/CoinsAndPotions.hs)

### RNG

Random number generation is handled through continuously computing a hash over an
infinite cycled stream of values from `0` to `maxBound` with `fnv1a`. Since
`rng` doesn't take any influence from it's input it's equivalent to a pure
stream.

```{.hs #rng}
rng :: Word -> Stream Word
rng seed = count >>> loop offset (lift (uncurry fnv1a) >>> dup)
    where offset = 14695981039346656037
          prime = 1099511628211
          count = loop (seed :: Word) (lift \(_, s) -> (s, s+1))
          fnv1a x hash = (hash `xor` x) * prime
```

### Messages

```{.hs #messages}
type Address = Int

data Action
data Message = Message Address Action
```

### State

```{.hs #state}
data PlayerState = PS
    { php :: Int
    , pitems :: [(Item, Int)]
    , pscore :: Int
    , phostile :: [Address]
    , pself :: Address
    }
```

```{.hs #state}
data NPCState = ES
    { ehp :: Int
    , eitems :: [(Item, Int)]
    , ehostile :: [Address]
    , eself :: Address
    , erng :: Object () Word
    }
```


### Objects

```{.hs #object-structure}
data Object input output =
    Object (input -> (Object input output, output))

type Stream a = Object () a
```

```{.hs #object-structure}
step :: Object a b -> a -> (Object a b, b)
step (Object f) x = f x
```

```{.hs #object-structure}
identity :: Object a a
identity = Object \x -> (identity, x)
```

```{.hs #object-structure}
lift :: (a -> b) -> Object a b
lift fn = Object \input ->
    let result = fn input
     in (lift fn, result)

animate :: Object (Object a b, a) (Object a b, b)
animate = lift (uncurry step)
```

Since the language of `Object` can't make use of `let` bindings we instead have
sharing through duplication of values.

```{.hs #object-structure}
dup :: Object a (a, a)
dup = lift \x -> (x, x)
```

```{.hs #object-structure}
swap :: Object (a, b) (b, a)
swap = lift \(x, y) -> (y, x)

first :: Object a b -> Object (a, c) (b, c)
first w = loop w (lift impl)
    where impl ((input, c), w) =
              let (w', out) = step w input
               in ((out, c), w')
```

`second` is

```{.hs #object-structure}
second w = swap >>> first w >>> swap

infixr 3 &&&
(&&&) :: Object a b -> Object a b' -> Object a (b, b')
left &&& right = dup >>> first left >>> second right
```

```{.hs #object-structure}
infixl 8 >>>
infixl 8 <<<
(>>>) :: Object a b -> Object b c -> Object a c
(Object left) >>> (Object right) =
    Object \input ->
        let (left', input') = left input
            (right', input'') = right input'
         in (left' >>> right', input'')

(<<<) = flip (>>>)

cst v = Object \_ -> (cst v, v)
```

```{.hs #object-structure}
loop :: state -> Object (a, state) (b, state) -> Object a b
loop state obj = Object \input ->
    let (obj', (out, state')) = step obj (input, state)
     in (loop state' obj', out)
```

### Player & NPC

```{.hs #npc-implementation}
npc :: NPCState -> Object Message Message
npc config = loop config behaviour
    where behaviour :: Object (Message, NPCState) (Message, NPCState)
          behaviour = undefined
          hp = lift (ehp . snd)
          items = lift (eitems . snd)
          hostile = lift (ehostile . snd)
          self = lift (eself . snd)
          -- rng = animate <<< lift (erng . snd) &&& cst ()
```

```{.hs #player}
player :: PlayerState -> Object Message Message
player config = loop config behaviour
    where behaviour :: Object (Message, PlayerState) (Message, PlayerState)
          behaviour = undefined
```

### Logging

```{.hs #logging}
type Log = String -> String
```

```{.hs #logging}
appendLog :: Log -> String -> Log
appendLog log msg = log . (++msg)
```

```{.hs #logging}
concatLog :: Log -> String
concatLog log = log ""
```

### Game Loop

```{.hs #gameboard}
gameboard :: [(Int, Object Message Message)]
gameboard =
    [ (0, npc (ES 5 [(Coin, 5), (Potion, 1)] [] 0 (rng 12)))
    , (1, npc (ES 6 [(Coin, 3)] [] 1 (rng 13)))
    , (2, npc (ES 2 [(Potion, 3)] [] 2 (rng 17)))
    , (3, player (PS 10 [] 0 [] 3))
    ]
```

```{.hs #gameloop}
game :: Object String (Bool, String)
game = undefined

main :: IO ()
main = do putStrLn "Coins & Potions v0.1.0.0"
          putStrLn "Enter your name."
          next game
    where next gameFrame = do
              putStr "> "
              hFlush stdout
              line <- getLine
              let (gameFrame', (quit, text)) = step gameFrame line
              putStrLn text
              when (not quit) $ next gameFrame'
```

```{.hs #modules-and-pragma}
{-# LANGUAGE BlockArguments,
             RecordWildCards #-}

module Main where
import Data.Bits (xor)
import Control.Monad (when)
import System.IO (hFlush, stdout)
```


</div>
