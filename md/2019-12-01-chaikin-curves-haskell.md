Drawing chaikin curves
======================

```haskell
lerp s e r = s + r * (e - s)

lp (sx, sy) (ex, ey) r = (lerp sx ex r, lerp sy ey r)

cut r p p' = let r' = if r > 0.5 then 1 - r else r
             in [lp p p' r', lp p' p r']

chaikin r xs =
  concat $ zipWith const
          (zipWith (cut r) (cycle xs) (tail $ cycle xs)) xs
```
