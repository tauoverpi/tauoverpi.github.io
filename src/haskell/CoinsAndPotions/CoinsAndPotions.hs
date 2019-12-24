-- ------ language="Haskell" file="src/haskell/CoinsAndPotions/CoinsAndPotions.hs"
-- ------ begin <<modules-and-pragma>>[0]
{-# LANGUAGE BlockArguments,
             RecordWildCards #-}

module Main where
import Data.Bits (xor)
import Control.Monad (when)
import System.IO (hFlush, stdout)
-- ------ end
-- ------ begin <<rng>>[0]
rng :: Word -> Stream Word
rng seed = count >>> loop offset (lift (uncurry fnv1a) >>> dup)
    where offset = 14695981039346656037
          prime = 1099511628211
          count = loop (seed :: Word) (lift \(_, s) -> (s, s+1))
          fnv1a x hash = (hash `xor` x) * prime
-- ------ end
-- ------ begin <<coins-and-potions>>[0]
data Item = Coin | Potion
-- ------ end
-- ------ begin <<logging>>[0]
type Log = String -> String
-- ------ end
-- ------ begin <<logging>>[1]
appendLog :: Log -> String -> Log
appendLog log msg = log . (++msg)
-- ------ end
-- ------ begin <<logging>>[2]
concatLog :: Log -> String
concatLog log = log ""
-- ------ end
-- ------ begin <<state>>[0]
data PlayerState = PS
    { php :: Int
    , pitems :: [(Item, Int)]
    , pscore :: Int
    , phostile :: [Address]
    , pself :: Address
    }
-- ------ end
-- ------ begin <<state>>[1]
data NPCState = ES
    { ehp :: Int
    , eitems :: [(Item, Int)]
    , ehostile :: [Address]
    , eself :: Address
    , erng :: Object () Word
    }
-- ------ end
-- ------ begin <<messages>>[0]
type Address = Int

data Action
data Message = Message Address Action
-- ------ end
-- ------ begin <<object-structure>>[0]
data Object input output =
    Object (input -> (Object input output, output))

type Stream a = Object () a
-- ------ end
-- ------ begin <<object-structure>>[1]
step :: Object a b -> a -> (Object a b, b)
step (Object f) x = f x
-- ------ end
-- ------ begin <<object-structure>>[2]
identity :: Object a a
identity = Object \x -> (identity, x)
-- ------ end
-- ------ begin <<object-structure>>[3]
lift :: (a -> b) -> Object a b
lift fn = Object \input ->
    let result = fn input
     in (lift fn, result)

animate :: Object (Object a b, a) (Object a b, b)
animate = lift (uncurry step)
-- ------ end
-- ------ begin <<object-structure>>[4]
dup :: Object a (a, a)
dup = lift \x -> (x, x)
-- ------ end
-- ------ begin <<object-structure>>[5]
swap :: Object (a, b) (b, a)
swap = lift \(x, y) -> (y, x)

first :: Object a b -> Object (a, c) (b, c)
first w = loop w (lift impl)
    where impl ((input, c), w) =
              let (w', out) = step w input
               in ((out, c), w')
-- ------ end
-- ------ begin <<object-structure>>[6]
second w = swap >>> first w >>> swap

infixr 3 &&&
(&&&) :: Object a b -> Object a b' -> Object a (b, b')
left &&& right = dup >>> first left >>> second right
-- ------ end
-- ------ begin <<object-structure>>[7]
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
-- ------ end
-- ------ begin <<object-structure>>[8]
loop :: state -> Object (a, state) (b, state) -> Object a b
loop state obj = Object \input ->
    let (obj', (out, state')) = step obj (input, state)
     in (loop state' obj', out)
-- ------ end
-- ------ begin <<npc-implementation>>[0]
npc :: NPCState -> Object Message Message
npc config = loop config behaviour
    where behaviour :: Object (Message, NPCState) (Message, NPCState)
          behaviour = undefined
          hp = lift (ehp . snd)
          items = lift (eitems . snd)
          hostile = lift (ehostile . snd)
          self = lift (eself . snd)
          -- rng = animate <<< lift (erng . snd) &&& cst ()
-- ------ end
-- ------ begin <<player>>[0]
player :: PlayerState -> Object Message Message
player config = loop config behaviour
    where behaviour :: Object (Message, PlayerState) (Message, PlayerState)
          behaviour = undefined
-- ------ end
-- ------ begin <<gameboard>>[0]
gameboard :: [(Int, Object Message Message)]
gameboard =
    [ (0, npc (ES 5 [(Coin, 5), (Potion, 1)] [] 0 (rng 12)))
    , (1, npc (ES 6 [(Coin, 3)] [] 1 (rng 13)))
    , (2, npc (ES 2 [(Potion, 3)] [] 2 (rng 17)))
    , (3, player (PS 10 [] 0 [] 3))
    ]
-- ------ end
-- ------ begin <<gameloop>>[0]
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
-- ------ end
-- ------ end
