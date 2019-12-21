---
title: Interfaces, Generics, and Object-Algebras
...

<div class="container">
<p class="notice">NOTICE: Document not complete</p>

A Simple Algebra
----------------

### Interface

Interfaces in C# allow for the definition of a common communication protocol for
objects involved without having to know more than the object implementing it. We
start by defining an interface `IAlg` taking a generic type parameter `A` which
the implementations will provide.

```{.cs #algebra-interface}
public interface IAlg<A>
{
    A Lit(int x);
    A Add(A x, A y);
}
```

The language consists only of expressions of constants where `Lit` introduces
a constant and addition with the `Add` constructor. Given this we can construct
a set of programs in out meta language (C#) which construct valid programs in
object language `IAlg`.

The first constructs a program for calculating the sum of the expression
$3 + (4 + 5)$.

```{.cs #algebra-meta}
static A ESum<A>(IAlg<A> o) =>
    o.Add(o.Lit(3), o.Add(o.Lit(4), o.Lit(5)));
```

While the second constructs the sum of the expression multiplied by two.
However, the language doesn't currently support multiplication thus we must make
do with the sum of the expression evaluated twice.

```{.cs #algebra-meta}
static A ESum2<A>(IAlg<A> o) => o.Add(ESum(o), ESum(o));
```

Notice that at this point in the program we still don't know the concrete type
of `A` so we're unable to operate on it with anything other than the operators
defined within our language. This isn't a negative! By restricting what we can
do we gain in reasoning about what out program can do. Now of course an
implementation may diverge from our goals yet that's completely up to them.

### Implementation

Starting with an implementation for `int` we see that the translation is pretty
straight forward with `Lit` being the identity function and `Add` making use of
C#'s native `+` operator.

```{.cs #algebra-int-implementation}
public class IntAlg : IAlg<int>
{
    public int Lit(int x) => x;
    public int Add(int x, int y) => x + y;
}
```

The implementation for printing expressions isn't any more spectacular.

```{.cs #algebra-string-implementation}
public class StrAlg : IAlg<string>
{
    public string Lit(int x) => x.ToString();
    public string Add(string x, string y) => $"({x} + {y})";
}
```

### Main

```{.cs #algebra-main}
public class Program
{
    <<algebra-meta>>
    public static void Main(string[] _)
    {
        Console.WriteLine(ESum(new IntAlg()));
        Console.WriteLine(ESum(new StrAlg()));
        Console.WriteLine(ESum2(new IntAlg()));
        Console.WriteLine(ESum2(new StrAlg()));
    }
}
```

Finally we lay out the program fragments in order.

```{.cs file=src/csharp/InterfacesGenericsAndObjectAlgebras/Algebra.cs}
using System;

namespace Algebra
{
    <<algebra-interface>>
    <<algebra-int-implementation>>
    <<algebra-string-implementation>>
    <<algebra-main>>
}
```
### Conclusion

The full source can be found
[here](../src/csharp/InterfacesGenericsAndObjectAlgebras/Algebra.cs).

An Extensible Interpreter
-------------------------

```{.cs #interpreter-interface}
public interface IEval<A> : IAlg<A>
{
    A Var(string name);
    A Mul(A x, A y);
}
```

### Implementation

```{.cs #interpreter-int-implementation}
public class IntEval: IEval<int>
{
    private Dictionary<string, int> env;
    public IntEval(Dictionary<string, int> dict)
    {
        env = dict;
    }

    public int Lit(int x) => x;
    public int Add(int x, int y) => x + y;
    public int Mul(int x, int y) => x * y;
    public int Var(string name) => env[name];
}
```

```{.cs #interpreter-pretty-implementation}
public class PrettyEval: IEval<Func<int, string>>
{
```

For convenience we abstract over wrapping parenthesis around the expression to
lower the noise in the following definitions.

```{.cs #interpreter-pretty-implementation}
    private paren(bool x, string s) => x? $"({s})" : s;
```

Literals ignore the current nesting level and print directly as-is.

```{.cs #interpreter-pretty-implementation}
    public Func<int, string> Lit(int x) => _ => x.ToString();
```

Since multiplication is more tightly binding than addition we might need to wrap
the expression in parenthesis when within an expression involving
multiplication.

```{.cs #interpreter-pretty-implementation}
    public Func<int, string>
        Add(Func<int, string> x, Func<int, string> y) =>
            i => paren(i < 0, $"{x(0)} + {y(0)}");
```

Multiplication itself doesn't require any parenthesis since it's the most
tightly binding expression within our language.

```{.cs #interpreter-pretty-implementation}
    public Func<int, string>
        Mul(Func<int, string> x, Func<int, string> y) =>
            _ => $"{x(1)} * {y(1)}";
```

```{.cs #interpreter-pretty-implementation}
    public Func<int, string> Var(string name) => name;
}
```

A Scripting Language
--------------------

### Interface

```{.cs #script-interface}
public interface IScript<E,S>
{
    E Lit(int x);
    E Add(E x, E y);

    E Assign(string name, E x);
    E Ref(stirng name);

    E Eq(E x, E y);
    E Lt(E x, E y);
    E Not(E x);
    E And(E x, E y);

    S Print(E x);
    S While(S cond, S loop);
    S If(S cond, S cons, S alt);
}
```
</div>
