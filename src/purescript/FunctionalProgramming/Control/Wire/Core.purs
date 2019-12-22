-- ------ language="Haskell" file="src/purescript/FunctionalProgramming/Control/Wire/Core.purs"
module Control.Wire.Core where
-- ------ begin <<wire-definition>>[0]
data Wire m a b where
    Wire (a -> m (Pair (Lazy (Wire m a b)) b))
-- ------ end
-- ------ end
