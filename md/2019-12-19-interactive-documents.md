Interactive documents
=====================

<div class="container">
Data types
----------

### Pair

```{.js #pair}
const Pair = x => y =>
    ({
        fst: x,
        snd: y,
        bimap: f => g => Pair (f(x)) (g(y)),
        lmap: f => Pair (f(x)) (y),
        rmap: g => Pair (x) (g(y))
    })
```

### Events

```{.js #maybe}
const Now = x =>
    ({
        match: default => f => f(x),
        map: f => Now(f(x))
    })
```

```{.js #maybe}
const NotNow = () =>
    ({
        maybe: default => f => default,
        map: f => NotNow ()
    })
```


Reactive
--------

Interactive documents rely heavily on user interaction which favours a reactive
style of programming.

### Pure wires

```{.js #identity}
const id = () => x => Pair (x) (id ())
```

```{.js #composition}
const o = f => g => x => {
    const gx = g (x)
    const fy = f (gx.fst)
    return Pair (fy.fst) (o (fy.snd) (gx.snd))
}
```

### Stateful wires

```{.js #delay}
const delayed = init => x => Pair (init) (delay (init))
```

```{.js #accum}
const accumed = f => init => x => {
    const r = f (init) (x)
    return Pair (r) (accum(f, r))
}
```

```{.js #loop}
const looped = w => init => x => {
}
```

### Event wires

```{.js #hold}
const holdon = init => x =>
    init === x
    ? Pair (NotNow ()) (hold (init))
    : Pair (Now (x)) (hold (x))
```

```{.js #altdef}
const altdef = f => g => x => {
    const fx = f(x)
    return fx.fst.match(
        (gx => Pair (gx.fst) (altdef (f) (gx.snd)) (g(x)),
        r => Pair (r) (altdef (fx.snd) (g))
    )
}
```

```{.js #alt}
const alt = f => g => x => {
    const fx = f(x)
    return fx.fst.match(
        (gx => Pair (gx.fst) (alt (f) (gx.snd)) (g(x)),
        _ => Pair (fx.fst) (alt (fx.snd) (g))
    )
}
```

### Applicatives

```{.js #delay}
const delay = init => w => o (delayed (init)) (w)
```

Interactive
-----------
</div>
