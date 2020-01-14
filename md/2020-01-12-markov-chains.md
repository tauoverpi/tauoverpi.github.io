Markov Chains
=============

```{.js #hash-function}
const djb2_offset = 5381;
const djb2_iter = (hash, item) => ((hash << 5) + hash) + item;
const djb2 = item => item.reduce(djb2_iter, djb2_offset);
```

```{.js #markov-chain}
class Markov {
    constructor() {
        this.lookup = {};
        this.markov = {};
    }

    learn(text) {
        const list = text.split(' ');
        if (list.length > 0) {
            var hash = djb2(list[i]);
            this.lookup[hash] = list[i];
            for (var i = 0; i+1 < list.length; i++) {
                const next = djb2(list[i+1]);
                this.lookup[next] = list[i+1];
                if (this.markov.hasOwnProperty(hash)) {
                    if (this.markov[hash].next.hasOwnPropery(next)) {
                        this.markov[hash].next[next] += 1;
                        this.markov[hash].total += 1;
                    } else {
                        this.markov[hash].next[next] = 1;
                        this.markov[hash].total += 1;
                    }
                } else {
                    this.markov[hash] = {"total": 1, "next": {next: 1}};
                }
                hash = next;
            }
        }
    }

    render() {
        src += "switch (current) {\n";
        for (var key in Object.keys(this.markov)) {
            src += "  case " + key + ":\n";
            const total = Object.keys(this.markov[key].total);
            for (var item in Object.keys(this.markov[key].next)) {
                src += "    if acc >= picked { current = next; break; }\n";
                src += "    acc += freq;\n";
            }
            src += "    break;\n";
        }
        src += "  default: break;\n";
        src += "}"
        return src;
    }
}
```

```{.js file=src/javascript/MarkovChains/mark.js}
```
