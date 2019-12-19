// ------ language="C#" file="src/csharp/InterfacesGenericsAndObjectAlgebras/Algebra.cs"
using System;

namespace Algebra
{
    // ------ begin <<algebra-interface>>[0]
    public interface IAlg<A>
    {
        A Lit(int x);
        A Add(A x, A y);
    }
    // ------ end
    // ------ begin <<algebra-int-implementation>>[0]
    public class IntAlg : IAlg<int>
    {
        public int Lit(int x) => x;
        public int Add(int x, int y) => x + y;
    }
    // ------ end
    // ------ begin <<algebra-string-implementation>>[0]
    public class StrAlg : IAlg<string>
    {
        public string Lit(int x) => x.ToString();
        public string Add(string x, string y) => $"({x} + {y})";
    }
    // ------ end
    // ------ begin <<algebra-main>>[0]
    public class Program
    {
        // ------ begin <<algebra-meta>>[0]
        static A ESum<A>(IAlg<A> o) =>
            o.Add(o.Lit(3), o.Add(o.Lit(4), o.Lit(5)));
        // ------ end
        // ------ begin <<algebra-meta>>[1]
        static A ESum2<A>(IAlg<A> o) => o.Add(ESum(o), ESum(o));
        // ------ end
        public static void Main(string[] _)
        {
            Console.WriteLine(ESum(new IntAlg()));
            Console.WriteLine(ESum(new StrAlg()));
            Console.WriteLine(ESum2(new IntAlg()));
            Console.WriteLine(ESum2(new StrAlg()));
        }
    }
    // ------ end
}
// ------ end
