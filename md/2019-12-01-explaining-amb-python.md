---
title: Explaining amb
...

<div class="container">
While walking through the code of one of the assignment examples -- the student stumbled over the definition and use of `amb` within the code. Their difficulty was understanding why and how it worked even when they understood the procedures involved. Thus I thought I should write about it's definition and use in detail to clear up the cloud of mystery.

Note, it's probably better to skip the definition and try the examples first to gain a feel for how `amb` is used.

### Definition

`amb` encompasses the concept of non-deterministic choice within it's tiny definition. The procedure, given a variable number of arguments, pick one to return from the given set. It does this by calling to `random.randint` from the `random` module as a source of non-determinism and thus has side effects which prevent us from knowing which value it returns before running it. `amb` requires at least two arguments to make sense as with only one it expresses the same behaviour as the identity function which is not our goal at all. The definition follows:

```python
import random

def amb(item0, item1, *items):
    set = (item0,) + (item1,) + items
    index = random.randint(0, len(items) + 1)
    return set[index]
```

The definition is relatively short and could be made shorter had we declared the set and index inline. `amb` takes three arguments where the third `*items` is a collection of all arguments past the first two we pass it on line 3. This allows for `amb` to be used with `n + 2` arguments which can be expressed as $amb(a_0, a_1, a_2, ..., a_{n-1})$ with the result of freeing us from having to think about `amb` being any different than `print` modulo the keyword arguments.

Line 4 contains the definition of the set we'll later pick from. Note that the order we compose them in has no effect on the result as the index is picked at random without respect to the actual order of the collection. The slightly unfamiliar syntax of `(item0,)` creates a new 1-tuple which is needed as `*items` is passed as an n-tuple which is a list-like collection type supported by python. Tuples themselves allow python to return multiple values instead of just one from procedures. This is desired as quite a few calculations have more than one result we may be interested in. Back on-topic, `(item0,) + (item1,) + items` concatenates tuples much like a list would and ends in a set represented by an n-tuple of `len(items) + 2` size. Note, there's no need to digest all of this at once as `amb` could really have used any collection type as long as it supports concatenation and indexing.

Next is line 5 which makes use of `random.randint` to get an arbitrary index into the n-tuple. The upper bound is $len(items) + 1$ as we take two arguments thus the length of `items` represents two less than the actual length of the n-tuple `set` and one less than the index range of `set`. Thus it's clear that the relation between `set` and `items` is $len(set) - 1 = len(items) + 1$ where the largest index is $len(set) - 1$ which is why we add one to the `length` of `items`.

Finally on line 6 we return the chosen item by picking the value in `set` at the given `index` we computed.

### Examples of use

Now that we have a detailed description of `amb` we're ready to put it to use!

#### Picking what to do

All `amb` does is pick an item at random making it the perfect tool for deciding the next activity.

```python
print(amb("listen to music",
          "study",
          "play games",
          "draw",
          "bother an angle"))
```

#### Parting & greeting messages

`amb` in functions allows for defining non-deterministic functions with a fixed set of answers.

```python
def parting():
    return amb("bye...", "see yah", "I'm out")

def greeting():
    return amb("hi", "hello", "how's it going?")

print(greeting())
print("uh...")
print(parting())
```

#### Coin flipping game

`amb` is also useful in games. The procedure is particularly useful when we need to repeatedly pick something without knowing beforehand which we'll get such as in this coin game. We start by defining the procedure `flipcoin` which returns `"heads"` and `"tails"` for representing the two sides of the coin.

```python
def flipcoin():
    return amb("heads", "tails")
```

After, we dive into the game itself with a `score` set to `0` and a loop over the interval $[0,9)$ to kick off the nine rounds.

```python
score = 0
for n in range(9):
    text = input("heads or tails?: ")
    coin = flipcoin()
    if coin == text:
        score += 1
        print("you're right! it's", coin)
    else:
        print("wrong! it's", coin)

print("you scored", score, "out of 9")
```

The game invokes `flipcoin` to get a new coin state to compare with the player input. If equal; increment the score and print a message to congratulate the player on guessing right; otherwise the game mocks the player. This continues for nine rounds which conclude with the display of the final score. The game itself is relatively simple on it's own but with `amb` it removes even more of the complexity in picking the side of a coin.

#### Shuffle

Yet another use of `amb` is producing a new random order from a given list of an unknown order. The procedure `shuffle` produces a random order for any collection type by randomly swapping the elements around. We start by getting the `length` of the list of `items` and the `indices` of each before we iterate over the list of `indices`. `oldindex` is bound to the index and `newindex` to the list of items passed to `amb` as arguments. Note, when you see the `*indices` syntax in this position it means to expand the collection into arguments which fill all the slots of our procedure. An example of this `amb(*[1, 2])` is the same as `amb(1, 2)` yet in the former case we've expanded a list to fill the arguments of `amb`. Doing so for `newindex` frees us from having to think about how to pick at a random index and instead allows us to reuse `amb` which we're already familiar with.

Following on, `amb` is used again in the conditional statement to pick between `True` and `False` to decide if the item should be swapped. Once `amb` returns an answer can be proceed to swapping with a temporary variable between.

```python
def shuffle(items):
    length = len(items)
    indices = list(range(length))
    for oldindex in indices:
        newindex = amb(*indices)
        if amb(True, False):
            tmp = items[newindex]
            items[newindex] = items[oldindex]
            items[oldindex] = tmp
```

This procedure is a bit more involved and introduced possibly new syntax yet it's concept and implementation are both made simple thanks to `amb`.

### amb is not perfect

There's one issue with `amb` that's inherent to any procedure dealing with random numbers. The sequence $[1_0, 1_1, 1_2, ..., 1_n-1]$ is perfectly valid as far as random numbers go and `amb` doesn't escape from true randomness. Had we wanted to make sure `amb` never returned the same result directly after the last we'd need to save the last result somewhere and compare. However, since we're dealing with non-determinism we have a few problems:

1. non-determinism means it's possible to get the same value over and over again forever! This rarely happens in practice but when it does, software systems break spectacularly such as the recent locking up of the Linux kernel trying to get a unique random number each and repeating the request for all eternity as it refuses to move progress forward without a unique number. The same can happen to out code so we need to be careful, take the following for example:

```python
for n in range(20):
    if amb(1, 2) == amb(1, 2):
        print("same")
    else:
        print("differet")
```

Given a bad implementation of `random.randint` our application could hang forever if we're checking against the last to roll again. So not checking would results in a lesser error than checking and recomputing as it's terminating.
</div>
