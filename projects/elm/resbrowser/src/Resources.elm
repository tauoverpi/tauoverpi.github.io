module Resources exposing (Resource, resources, tags)
import Set

type alias Resource =
  { title: String
  , url: String
  , tags: List String
  }

resources : List Resource
resources =
  papers ++ articles ++ projects ++ books
  |> List.map (\r -> { r | tags = List.sort r.tags })

tags : List String
tags = resources
     |> List.concatMap .tags
     |> Set.fromList
     |> Set.toList

papers : List Resource
papers =
  [ { title = "The Elements of Euclid"
    , url = "https://www.c82.net/euclid/"
    , tags = ["math"]
    }
  , { title = "On lions, impala, and bigraphs: modelling interactions in physical/virtual spaces"
    , url = "http://eprints.nottingham.ac.uk/39044/1/main_savannah-accepted.pdf"
    , tags = ["math", "bigraphs"]
    }
  , { title = "Modelling IEEE 802.11 CSMA/CA RTS/CTS with stochastic bigraphs with sharing"
    , url = "https://link.springer.com/content/pdf/10.1007%2Fs00165-012-0270-3.pdf"
    , tags = ["bigraphs"]
    }
  , { title = "bigraphs with sharing"
    , url = "https://www.sciencedirect.com/science/article/pii/S0304397515001085?via%3Dihub"
    , tags = ["math", "bigraphs"]
    }
  , { title = "Graph Neural Networks: A Review of Methods and Applications"
    , url = "https://arxiv.org/pdf/1812.08434.pdf"
    , tags = ["gnn", "math"]
    }
  , { title = "Programming with a Differentiable Forth Interpreter"
    , url = "https://arxiv.org/pdf/1605.06640"
    , tags = ["forth", "machine learning"]
    }
  , { title = "A JIT Compiler for Neural Network Inference"
    , url = "https://arxiv.org/pdf/1906.05737v1.pdf"
    , tags = ["c++", "ann", "compiler", "jit"]
    }
  , { title = "A Critical Review of Recurrent Neural Networks for Sequence Learning"
    , url = "https://arxiv.org/pdf/1506.00019.pdf"
    , tags = ["rnn"]
    }
  , { title = "CacheOut: Leaking Data on Intel CPUs via Cache Evictions"
    , url = "https://cacheoutattack.com/CacheOut.pdf"
    , tags = ["intel", "hardware", "bugs", "security"]
    }
  , { title = "Meltdown: Reading Kernel Memory from User Space"
    , url = "https://meltdownattack.com/meltdown.pdf"
    , tags = ["intel", "hardware", "bugs", "security"]
    }
  , { title = "Spectre Attacks: Exploiting Speculative Execution"
    , url = "https://spectreattack.com/spectre.pdf"
    , tags = ["intel", "hardware", "bugs", "security"]
    }
  , { title = "Temporal correlation detection using computational phase-change memory"
    , url = "https://www.nature.com/articles/s41467-017-01481-9"
    , tags = []
    }
  , { title = "SHA-1 is a Shambles"
    , url = "https://eprint.iacr.org/2020/014.pdf"
    , tags = ["sha-1", "hash", "security"]
    }
  , { title = "RecSplit: Minimal Perfect Hashing via Recursive Splitting"
    , url = "https://arxiv.org/pdf/1910.06416.pdf"
    , tags = ["hash", "perfect hash"]
    }
  , { title = "Less hashing, same performance: Building a better bloom filter (2006)"
    , url = "http://citeseerx.ist.psu.edu/viewdoc/download;jsessionid="
         ++ "F45130A950930D9DEC1C6454277F4B34?doi=10.1.1.152.579&rep=rep1&type=pdf"
    , tags = ["bloom filter", "hash"]
    }
  , { title = "Cuckoo Filter: Practically Better Than Bloom"
    , url = "https://www.cs.cmu.edu/~dga/papers/cuckoo-conext2014.pdf"
    , tags = ["cuckoo filter", "hash"]
    }
  , { title = "Making Data Structures Persistent"
    , url = "http://www.cs.cmu.edu/~sleator/papers/another-persistence.pdf"
    , tags = ["data structure"]
    }
  , { title = "Persistent Data Structures"
    , url = "http://www.math.tau.ac.il/~haimk/papers/persistent-survey.ps"
    , tags = ["data structure"]
    }
  , { title = "Simple High-Level Code For Cryptographic Arithmetic"
           ++ " – With Proofs, Without Compromises"
    , url = "http://adam.chlipala.net/papers/FiatCryptoSP19/FiatCryptoSP19.pdf"
    , tags = []
    }
  , { title = "An Efficient Context-Free Parsing Algorithm"
    , url = "https://web.archive.org/web/20040708052627/http://www-2.cs.cmu"
         ++ ".edu/afs/cs.cmu.edu/project/cmt-55/lti/Courses/711/Class-notes/"
         ++ "p94-earley.pdf"
    , tags = []
    }
  , { title = "Probabilistic Inductive Logic Programming"
    , url = "http://people.csail.mit.edu/kersting/ecmlpkdd05_pilp/pilp.pdf"
    , tags = ["logic"]
    }
  , { title = "Ceptre: A Language for Modeling Generative Interactive Systems"
    , url = "http://www.cs.cmu.edu/~cmartens/ceptre.pdf"
    , tags = ["logic", "linear logic"]
    }
  , { title = "Linear Logic Programming for Narrative Generation"
    , url = "https://www.cs.cmu.edu/~cmartens/lpnmr13-short.pdf"
    , tags = ["logic", "games"]
    }
  , { title = "Principal typing in elementary affine logic"
    , url = "https://www.academia.edu/2622889/Principal_typing_in_elementary_affine_logic"
    , tags = ["logic", "affine logic"]
    }
  , { title = "Elementary affine logic and the call-by-value lambda calculus"
    , url = "https://www.academia.edu/2622886/Elementary_affine_logic_and_the_"
         ++ "call-by-value_lambda_calculus"
    , tags = ["logic", "affine logic"]
    }
  , { title = "Type Theory & Functional Programming"
    , url = "https://www.cs.kent.ac.uk/people/staff/sjt/TTFP/ttfp.pdf"
    , tags = ["types"]
    }
  , { title = "The Syntax and Semantics of Quantitative Type Theory"
    , url = "https://bentnib.org/quantitative-type-theory.html"
    , tags = ["logic", "linear logic"]
    }
  , { title = "Quantitative program reasoning with graded modal types"
    , url = "https://granule-project.github.io/papers/granule-paper-draft.pdf"
    , tags = ["logic", "modal logic", "types"]
    }
  , { title = "Compile-Time Garbage Collection for the Declarative Language Mercury"
    , url = "https://www.mercurylang.org/documentation/papers/CW2004_03_mazur.pdf"
    , tags = ["garbage collection"]
    }
  , { title = "Formal Verification of a Modern SAT Solver"
    , url = "http://poincare.matf.bg.ac.rs/~filip/phd/sat-verification-shallow.pdf"
    , tags = ["sat", "logic"]
    }
  , { title = "Generalized Convolution and Efficient Language Recognition"
    , url = "https://arxiv.org/pdf/1903.10677.pdf"
    , tags = ["category theory"]
    }
  , { title = "Compiling to Categories"
    , url = "http://conal.net/papers/compiling-to-categories/compiling-to-categories.pdf"
    , tags = ["category theory"]
    }
  , { title = "Selecitve Applicative Functors"
    , url = "https://dl.acm.org/ft_gateway.cfm?id=3341694"
    , tags = ["haskell", "category theory"]
    }
  , { title = "An Introduction to Category Theory for the working computer scientist"
    , url = "https://www.researchgate.net/publication/"
         ++ "235778993_The_optimal_implementation_of_functional_programming_languages"
    , tags = ["category theory"]
    }
  , { title = "Functional Programming with Bananas, Lenses, Envelopes and Barbed Wire"
    , url = "https://ris.utwente.nl/ws/portalfiles/portal/6142049/meijer91functional.pdf"
    , tags = ["category theory"]
    }
  , { title = "How to add laziness to a strict language without even being odd"
    , url = "http://hh.diva-portal.org/smash/get/diva2:413532/FULLTEXT01.pdf"
    , tags = ["lazy", "interpreters"]
    }
  , { title = "Partial Evaluation and Automatic Program Generation"
    , url = "http://www.itu.dk/people/sestoft/pebook/jonesgomardsestoft-a4.pdf"
    , tags = ["interpreters"]
    }
  , { title = "Revised7 Report on the Algorithmic Language Scheme"
    , url = "http://www.larcenists.org/Documentation/Documentation0.98/r7rs.pdf"
    , tags = []
    }
  , { title = "Composable Memory Transactions"
    , url = "https://www.microsoft.com/en-us/research/wp-content/"
         ++ "uploads/2005/01/2005-ppopp-composable.pdf"
    , tags = []
    }
  , { title = "Backtracking, Interleaving, and Terminating Monad Transformers"
    , url = "http://okmij.org/ftp/Computation/LogicT.pdf"
    , tags = ["logic"]
    }
  , { title = "Arrows, Robots, and Functional Reactive Programming"
    , url = "http://www.cs.yale.edu/homes/hudak/CS429F04/AFPLectureNotes.pdf"
    , tags = []
    }
  , { title = "Fault tolerant functional reactive programming"
    , url = "https://dl.acm.org/citation.cfm?id=3236791"
    , tags = []
    }
  , { title = "Testing and Debugging Functional Reactive Programming"
    , url = "https://dl.acm.org/citation.cfm?id=3110246"
    , tags = []
    }
  , { title = "Functional Reactive Programming, Refactored"
    , url = "https://dl.acm.org/authorize?N34896"
    , tags = []
    }
  , { title = "Flask: Staged Functional Programming for Sensor Networks"
    , url = "http://www.cl.cam.ac.uk/~ey204/teaching/ACS/R202/papers/"
         ++ "S5_Stream_Query/papers/mainland_icfp_2008.pdf"
    , tags = []
    }
  , { title = "A Pure Language with Default Strict Evaluation and Explicit Laziness"
    , url = "http://web.cecs.pdx.edu/~sheard/papers/ExplicitLazy.ps"
    , tags = []
    }
  , { title = "Type variables in patterns"
    , url = "https://arxiv.org/pdf/1806.03476.pdf"
    , tags = []
    }
  , { title = "Elaborating Evaluation-Order Polymorphism"
    , url = "https://arxiv.org/pdf/1504.07680"
    , tags = []
    }
  , { title = "A Framework for Extended Algebraic Data Types"
    , url = "http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.101.9267&rep=rep1&type=pdf"
    , tags = []
    }
  , { title = "Instance Chains: Type Class Programming Without Overlapping Instances"
    , url = "https://jgbm.github.io/pubs/morris-icfp2010-instances.pdf"
    , tags = []
    }
  , { title = "Type Classes and Instance Chains: A Relational Approach"
    , url = "https://jgbm.github.io/pubs/morris-dissertation.pdf"
    , tags = []
    }
  , { title = "Programming and Reasoning with Algebraic Effects and Dependent Types"
    , url = "https://eb.host.cs.st-andrews.ac.uk/drafts/effects.pdf"
    , tags = ["types"]
    }
  , { title = "The Power of Pi"
    , url = "https://cs.ru.nl/~wouters/Publications/ThePowerOfPi.pdf"
    , tags = []
    }
  , { title = "Lightweight higher-kinded polymorphism"
    , url = "https://ocamllabs.github.io/higher/lightweight-higher-kinded-polymorphism.pdf"
    , tags = []
    }
  , { title = "Improving Haskell Types with SMT"
    , url = "http://yav.github.io/publications/improving-smt-types.pdf"
    , tags = []
    }
  , { title = "Functional Geometry"
    , url = "https://eprints.soton.ac.uk/257577/1/funcgeo2.pdf"
    , tags = ["graphics"]
    }
  , { title = "1ML – Core and Modules United (F-ing First-class Modules)"
    , url = "https://people.mpi-sws.org/~rossberg/1ml/1ml.pdf"
    , tags = ["ml", "types"]
    }
  , { title = ""
    , url = ""
    , tags = []
    }
  , { title = "Cross-platform Compilers for Functional Languages"
    , url = "https://eb.host.cs.st-andrews.ac.uk/drafts/compile-idris.pdf"
    , tags = []
    }
  , { title = "Compiling with Continuations and LLVM"
    , url = "https://arxiv.org/pdf/1805.08842.pdf"
    , tags = []
    }
  , { title = "G2Q: Haskell Constraint Solving"
    , url = "http://www.cs.yale.edu/homes/piskac/papers/2019HallahanETALquasiquoter.pdf"
    , tags = []
    }
  , { title = "SMT Solving for Functional Programming over Infinite Structures∗"
    , url = "https://arxiv.org/pdf/1604.01185v1.pdf"
    , tags = []
    }
  , { title = "Extensible Type-Directed Editing"
    , url = "http://davidchristiansen.dk/pubs/extensible-editing.pdf"
    , tags = []
    }
  , { title = "A prettier printer - Wadler"
    , url = "http://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf"
    , tags = []
    }
  , { title = "Pretty Printing"
    , url = "http://i.stanford.edu/pub/cstr/reports/cs/tr/79/770/CS-TR-79-770.pdf"
    , tags = []
    }
  , { title = "The Final Pretty Printer"
    , url = "http://davidchristiansen.dk/drafts/final-pretty-printer-draft.pdf"
    , tags = []
    }
  , { title = "Extensibility for the Masses Practical Extensibility with Object Algebras"
    , url = "http://www.cs.utexas.edu/~wcook/Drafts/2012/ecoop2012.pdf"
    , tags = []
    }
  , { title = "Feature-Oriented Programming with Object Algebras"
    , url = "https://www.cs.utexas.edu/~wcook/Drafts/2012/FOPwOA.pdf"
    , tags = []
    }
  , { title = "Streams à la carte: Extensible Pipelines with Object Algebras"
    , url = "http://drops.dagstuhl.de/opus/volltexte/2015/5239/pdf/29.pdf"
    , tags = []
    }
  , { title = "Scrap Your Boilerplate with Object Algebras"
    , url = "https://i.cs.hku.hk/~bruno/papers/oopsla2015.pdf"
    , tags = []
    }
  , { title = "An Analysis and Discussion of Solutions to the Expression Problem Across Programming Languages"
    , url = "https://cs242.stanford.edu/f17/assets/projects/2017/kjtian-colinwei.pdf"
    , tags = []
    }
  , { title = "Modular Interpreters with Implicit Context Propagation"
    , url = "https://homepages.cwi.nl/~storm/publications/implicit-ctx.pdf"
    , tags = []
    }
  , { title = "Type-Safe Modular Parsing"
    , url = "https://i.cs.hku.hk/~bruno/papers/sle17.pdf"
    , tags = ["parsing"]
    }
  , { title = "A purely functional implementation of ROBDDs in Haskell"
    , url = "http://www.cs.nott.ac.uk/~psznhn/TFP2006/Papers/09-ChristiansenHuch"
         ++ "-APurelyFunctionalImplementationOfROBDDs.pdf"
    , tags = ["haskell", "data structure", "lazy", "tree"]
    }
  , { title = "Functional Pearl Trouble Shared is Trouble Halved"
    , url = "http://www.cs.ox.ac.uk/ralf.hinze/publications/HW03.pdf"
    , tags = ["haskell", "data structure", "tree"]
    }
  ]

books : List Resource
books =
  [ { title = "A programmer's introduction to mathematics"
    , url = "https://jeremykun.com/2018/12/01/a-programmers-introduction-to-mathematics/"
    , tags = ["math"]
    }
  , { title = "The space and motion of communicating agents"
    , url = "http://www.cl.cam.ac.uk/archive/rm135/Bigraphs-draft.pdf"
    , tags = ["math", "bigraphs"]
    }
  , { title = "WebPPL probabilistic programming for the web"
    , url = "http://webppl.org"
    , tags = ["logic", "probabilistic"]
    }
  , { title = "The Design and Implementation of Probabilistic Programming Languages"
    , url = "http://dippl.org"
    , tags = ["logic", "probabilistic"]
    }
  , { title = "Finite and Infinite Machines by Marvin Minsky"
    , url = "https://github.com/media-lib/science_lib/raw/master/books/"
         ++ "Computation_Finite_And_Infinite_Machines_by_Marvin_Minksy.pdf"
    , tags = ["ann", "math", "machine learning"]
    }
  , { title = "Structure and Interpretation of Computer Programs"
    , url = "http://xuanji.appspot.com/isicp/"
    , tags = ["sicp", "lisp"]
    }
  , { title = "DESIGN PATTERNS"
    , url = "https://refactoring.guru/design-patterns/"
    , tags = []
    }
  , { title = "Mastering Dyalog APL"
    , url = "https://www.dyalog.com/uploads/documents/MasteringDyalogAPL.pdf"
    , tags = ["apl"]
    }
  , { title = "Learn you some Erlang Clients and Servers"
    , url = "https://learnyousomeerlang.com/clients-and-servers"
    , tags = ["erlang"]
    }
  , { title = "LEX & YACC"
    , url = "https://www.epaperpress.com/lexandyacc/download/LexAndYacc.pdf"
    , tags = ["lex", "parser", "yacc"]
    }
  , { title = "Write Yourself a Scheme in 48 Hours"
    , url = "https://upload.wikimedia.org/wikipedia/commons/a/aa/"
         ++ "Write_Yourself_a_Scheme_in_48_Hours.pdf"
    , tags = []
    }
  , { title = "Static Single Assignment Book"
    , url = "http://ssabook.gforge.inria.fr/latest/book.pdf"
    , tags = ["ssa"]
    }
  , { title = "An Introduction to Functional Programming Through Lambda Calculus"
    , url = "https://www.cs.rochester.edu/~brown/173/readings/LCBook.pdf"
    , tags = []
    }
  , { title = "Category Theory for Programmers: The Preface"
    , url = "https://bartoszmilewski.com/2014/10/28/category-theory-for-programmers-the-preface/"
    , tags = ["category theory"]
    }
  , { title = "The Beam Book"
    , url = "https://happi.github.io/theBeamBook"
    , tags = ["erlang"]
    }
  , { title = "Concrete Semantics - Brick"
    , url = "http://concrete-semantics.org/concrete-semantics-brick.pdf"
    , tags = []
    }
  , { title = "Write You a Haskell"
    , url = "http://dev.stephendiehl.com/fun/"
    , tags = []
    }
  , { title = "Learn you an Agda"
    , url = "http://learnyouanagda.liamoc.net/pages/introduction.html"
    , tags = []
    }
  , { title = "Programming Language Foundations in Agda"
    , url = "https://plfa.github.io/"
    , tags = []
    }
  , { title = ""
    , url = ""
    , tags = []
    }
  , { title = "Smalltalk-80 The Language And It's Implementation"
    , url = "http://stephane.ducasse.free.fr/FreeBooks/BlueBook/Bluebook.pdf"
    , tags = []
    }
  , { title = "Professor Frisby's Mostly Adequate Guide to Functional Programming"
    , url = "https://drboolean.gitbooks.io/mostly-adequate-guide-old/content/"
    , tags = []
    }
  ]

articles : List Resource
articles =
  [ { title = "Interactive Tutorial of the Sequent Calculus"
    , url = "http://logitext.mit.edu/tutorial"
    , tags = ["logic"]
    }
  , { title = "Get a Brain"
    , url = "https://crypto.stanford.edu/~blynn/haskell/brain.html"
    , tags = ["haskell", "ann", "machine learning"]
    }
  , { title = "Multi label Image Classification"
    , url = "https://suraj-deshmukh.github.io/Keras-Multi-Label-Image-Classification/"
    , tags = ["machine learning"]
    }
  , { title = "Intro to Low-Level Graphics on Linux"
    , url = "http://betteros.org/tut/graphics1.php"
    , tags = ["graphics", "x11", "framebuffer"]
    }
  , { title = "Fix Your Timestep!"
    , url = "https://gafferongames.com/post/fix_your_timestep/"
    , tags = ["games"]
    }
  , { title = "Integration Basics"
    , url = "https://gafferongames.com/post/integration_basics/"
    , tags = []
    }
  , { title = "FNV"
    , url = "http://www.isthe.com/chongo/tech/comp/fnv/"
    , tags = ["hash", "fnv"]
    }
  , { title = "djb2"
    , url = "http://www.cse.yorku.ca/~oz/hash.html"
    , tags = ["hash", "djb2"]
    }
  , { title = "Hash functions: An empirical comparison"
    , url = "https://www.strchr.com/hash_functions"
    , tags = ["hash"]
    }
  , { title = "Paul Hsieh Hash"
    , url = "http://www.azillionmonkeys.com/qed/hash.html"
    , tags = ["hash"]
    }
  , { title = "Bit Twiddling Hacks"
    , url = "https://graphics.stanford.edu/~seander/bithacks.html"
    , tags = []
    }
  , { title = "Othello for Desktop, Mobile and Web: an AI and GUI Exercise"
    , url = "https://www.hanshq.net/othello.html"
    , tags = ["game"]
    }
  , { title = "Fixed Point Arithmetic and Tricks"
    , url = "http://x86asm.net/articles/fixed-point-arithmetic-and-tricks/"
    , tags = ["fixed-width", "x86"]
    }
  , { title = "ipow"
    , url = "https://gist.github.com/orlp/3551590"
    , tags = []
    }
  , { title = "Data Compression with Arithmetic Encoding"
    , url = "http://www.drdobbs.com/cpp/data-compression-with-arithmetic-encodin/240169251"
    , tags = ["compression"]
    }
  , { title = "Bloom Filters by Example"
    , url = "https://llimllib.github.io/bloomfilter-tutorial/"
    , tags = ["bloom filter"]
    }
  , { title = "Probabilistic Filters By Example"
    , url = "https://bdupras.github.io/filter-tutorial/"
    , tags = []
    }
  , { title = "Fenwick Tree"
    , url = "https://en.wikipedia.org/wiki/Fenwick_tree"
    , tags = []
    }
  , { title = "MOVING FORTH"
    , url = "http://www.bradrodriguez.com/papers/moving1.htm"
    , tags = ["forth"]
    }
  , { title = "UltraTechnology"
    , url = "http://www.ultratechnology.com/"
    , tags = ["forth"]
    }
  , { title = "Earley Parsing Explained"
    , url = "http://loup-vaillant.fr/tutorials/earley-parsing"
    , tags = ["parser"]
    }
  , { title = "Fast Haskell: Competing with C at parsing XML"
    , url = "https://chrisdone.com/posts/fast-haskell-c-parsing-xml/"
    , tags = ["parser", "xml"]
    }
  , { title = "ENTIRE, A Generic Parser for the Entire Class of Context-free Grammars"
    , url = "http://accent.compilertools.net/Entire.html"
    , tags = ["parser"]
    }
  , { title = "The Evolution of a Haskell Programmer"
    , url = "https://www.willamette.edu/~fruehr/haskell/evolution.html"
    , tags = ["haskell"]
    }
  , { title = "Real World Ocaml"
    , url = "https://realworldocaml.org/"
    , tags = ["haskell"]
    }
  , { title = "fclabels 2.0"
    , url = "http://fvisser.nl/post/2013/okt/1/fclabels-2.0.html"
    , tags = ["haskell", "lens"]
    }
  , { title = "From Adjunctions to Monads"
    , url = "http://www.stephendiehl.com/posts/adjunctions.html"
    , tags = ["category theory"]
    }
  , { title = "Profunctors, Arrows, & Static Analysis"
    , url = "https://elvishjerricco.github.io/2017/03/10/"
         ++ "profunctors-arrows-and-static-analysis.html"
    , tags = ["cateogry theory", "profunctors", "functors"]
    }
  , { title = "Reflecting On Incremental Folds"
    , url = "http://comonad.com/reader/2009/incremental-folds/"
    , tags = ["category theory"]
    }
  , { title = "Overloading lambda"
    , url = "http://conal.net/blog/posts/overloading-lambda"
    , tags = ["category theory"]
    }
  , { title = "Composing Reactive Animations"
    , url = "http://conal.net/fran/tutorial.htm"
    , tags = []
    }
  , { title = "Understanding Yoneda"
    , url = "https://www.schoolofhaskell.com/user/bartosz/understanding-yoneda"
    , tags = []
    }
  , { title = "Row Polymorphism Isn't Subtyping"
    , url = "https://brianmckenna.org/blog/row_polymorphism_isnt_subtyping"
    , tags = []
    }
  , { title = "Typing the technical interview"
    , url = "https://aphyr.com/posts/342-typing-the-technical-interview"
    , tags = []
    }
  , { title = "Mirrored Lenses"
    , url = "http://comonad.com/reader/2012/mirrored-lenses/"
    , tags = []
    }
  , { title = "Object Oriented Programming in Haskell"
    , url = "https://www.well-typed.com/blog/2018/03/oop-in-haskell/"
    , tags = ["haskell"]
    }
  , { title = "From walking to zipping, Part 3: Caught in a zipper"
    , url = "http://conway.rutgers.edu/~ccshan/wiki/blog/posts/WalkZip3/"
    , tags = []
    }
    , { title = "Monads to Machine Code"
    , url = "http://www.stephendiehl.com/posts/monads_machine_code.html"
    , tags = []
    }
  , { title = "Quasi-quoting DSLs for free"
    , url = "http://www.well-typed.com/blog/2014/10/quasi-quoting-dsls/"
    , tags = []
    }
  , { title = "Kaleidoscope LLVM tutorial Ocaml"
    , url = "https://llvm.org/docs/tutorial/OCamlLangImpl1.html"
    , tags = []
    }
  , { title = "Writing a SAT Solver"
    , url = "http://andrew.gibiansky.com/blog/verification/writing-a-sat-solver/"
    , tags = []
    }
  , { title = "Simple SMT solver for use in an optimizing compiler"
    , url = "https://www.well-typed.com/blog/2014/12/simple-smt-solver/"
    , tags = []
    }
  , { title = "Quick and Easy DSLs with Writer Endo"
    , url = "https://ocharles.org.uk/blog/posts/2013-02-12-quick-dsls-with-endo-writers.html"
    , tags = []
    }
  , { title = "Seemingly impossible functional programs"
    , url = "http://math.andrej.com/2007/09/28/seemingly-impossible-functional-programs/"
    , tags = []
    }
  , { title = "faster mcpy"
    , url = "https://software.intel.com/en-us/articles/performance-optimization-of-memcpy-in-dpdk"
    , tags = []
    }
  , { title = "ring buffers"
    , url = "https://www.snellman.net/blog/archive/2016-12-13-ring-buffers/"
    , tags = []
    }
  , { title = "Allocator Designs"
    , url = "https://os.phil-opp.com/allocator-designs/"
    , tags = []
    }
  , { title = "Bitsquatting: DNS Hijacking without exploitation"
    , url = "http://www.dinaburg.org/bitsquatting.html"
    , tags = []
    }
  , { title = "Golang implementation of PASETO: Platform-Agnostic Security Tokens"
    , url = "https://github.com/o1egl/paseto"
    , tags = []
    }
  , { title = "PASETO: Platform-Agnostic Security Tokens in JavaScript"
    , url = "https://github.com/sjudson/paseto.js"
    , tags = []
    }
  , { title = "Block ads with OpenWRT dnsmasq"
    , url = "https://www.leowkahman.com/2017/07/23/block-ads-with-openwrt-dnsmasq/"
    , tags = []
    }
  , { title = "measuring syscall overhead"
    , url = "https://drewdevault.com/2020/01/04/Slow.html"
    , tags = []
    }
  , { title = "Text Rendering Hates You"
    , url = "https://gankra.github.io/blah/text-hates-you/"
    , tags = []
    }
  , { title = "oom_pardon, aka don't kill my xlock"
    , url = "lwn.net/Articles/104185"
    , tags = []
    }
  , { title = "Gathering Intel on Intel AVX-512 Transitions"
    , url = "https://travisdowns.github.io/blog/2020/01/17/avxfreq1.html"
    , tags = []
    }
  ]

projects : List Resource
projects =
  [ { title = "LATEX for Logicians"
    , url = "https://www.logicmatters.net/resources/pdfs/latex/BussGuide2.pdf"
    , tags = ["latex", "logic"]
    }
  , { title = "Bloom Filter Calculator"
    , url = "https://hur.st/bloomfilter/"
    , tags = ["bloom filter", "hash"]
    }
  , { title = "The new Smol compiler and reference"
    , url = "https://github.com/CurtisFenner/zsmol"
    , tags = ["compiler"]
    }
  , { title = "Relational Hindley-Milner type inferencer in miniKanren"
    , url = "https://github.com/webyrd/hindley-milner-type-inferencer"
    , tags = ["types", "type inference"]
    }
  , { title = "toysolver: Assorted decision procedures for SAT, SMT, Max-SAT, PB, MIP, etc"
    , url = "http://hackage.haskell.org/package/toysolver"
    , tags = ["sat"]
    }
  , { title = "Copilot"
    , url = "http://leepike.github.io/Copilot/"
    , tags = []
    }
  , { title = "Clash"
    , url = "http://www.clash-lang.org/"
    , tags = []
    }
  , { title = "ComonadSheet"
    , url = "https://github.com/kwf/ComonadSheet"
    , tags = []
    }
  , { title = "Learn OpenGL in zig"
    , url = "https://github.com/cshenton/learnopengl"
    , tags = []
    }
  , { title = "NeHe tutorials in zig"
    , url = "https://github.com/mypalmike/zigNeHe"
    , tags = []
    }
  ]

lectures : List Resource
lectures =
  [ { title = "Sanskrit and OCR"
    , url = "https://vimeo.com/4714623"
    , tags = ["ocr", "smalltalk"]
    }
  , { title = "How we program multicores - Joe Armstrong"
    , url = "https://invidio.us/watch?v=bo5WL5IQAd0"
    , tags = ["concurrency", "parallel", "erlang"]
    }
  ]

misc : List Resource
misc =
  [ { title = "Programmer books"
    , url = "https://programmer-books.com/wp-content/uploads/"
    , tags = []
    }
  ]
