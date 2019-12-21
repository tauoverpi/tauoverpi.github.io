-- ------ language="Haskell" file="src/purescript/FunctionalProgramming/Data/Lazy.purs"
module Lazy where
-- ------ begin <<lazy-definition>>[0]
foreign import data Lazy :: Type -> Type
-- ------ end
-- ------ begin <<lazy-definition>>[1]
foreign import defer :: a -> Lazy a
foreign import force :: Lazy a -> a
-- ------ end

-- ------ end
