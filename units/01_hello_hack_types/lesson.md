# Unit 01 — Hello Hack & Type System Basics

## 1. What is Hack?

Hack is a language built on top of PHP by Meta. Think of it as **"TypeScript is to JavaScript"** — Hack adds a strict type system on top of PHP, plus async/await, generics, and more.

Key differences from PHP:
- **Strict by default** — `.hack` files are always in strict mode (no `<?hh` header needed)
- **Static type checking** — the typechecker (`hh_client`) catches errors before runtime
- **No PHP arrays** — replaced by `vec`, `dict`, `keyset` (more on this in Unit 02)
- **Runtime:** HHVM (not the PHP interpreter)

**Analogy:** If PHP is JavaScript, Hack is TypeScript with `strict: true` enforced everywhere.

---

## 2. File Structure

```
my_project/
├── .hhconfig          # Tells the typechecker "this is a Hack project"
├── hh_autoload.json   # Autoloading config (like package.json for imports)
├── src/               # Production code
├── tests/             # Tests
└── bin/               # Entry point scripts
```

- Files use the `.hack` extension (not `.php`)
- `.hack` files are **always strict** — no mode header needed
- Each file contains top-level declarations (functions, classes, etc.)

---

## 3. Entry Point & Running Programs

Every Hack program needs an entry point marked with the `<<__EntryPoint>>` attribute:

```hack
<<__EntryPoint>>
async function main(): Awaitable<void> {
  echo "Hello, Hack!\n";
}
```

- The function name is arbitrary — `main`, `run`, `go`, whatever. Only the attribute matters.
- Convention is `async function main(): Awaitable<void>` (we'll learn async later)
- Run with: `hhvm your_file.hack`

**Python analogy:** `<<__EntryPoint>>` is like `if __name__ == "__main__":`
**TypeScript analogy:** There's no direct equivalent — it's like marking your top-level call explicitly.

---

## 4. Primitive Types

| Type | What it is | Python equivalent | TS equivalent |
|------|-----------|-------------------|---------------|
| `int` | Integer | `int` | `number` |
| `float` | Floating point | `float` | `number` |
| `string` | String | `str` | `string` |
| `bool` | Boolean | `bool` | `boolean` |
| `num` | Union of `int \| float` | — | `number` |
| `arraykey` | Union of `int \| string` | — | `string \| number` |
| `mixed` | Any type (must refine before use) | `Any` (but safer) | `unknown` |
| `nonnull` | Anything except `null` | — | `NonNullable<unknown>` |
| `void` | Returns nothing | `-> None` | `void` |
| `noreturn` | Never returns (throws/loops forever) | `-> NoReturn` | `never` |
| `nothing` | Bottom type (no value inhabits it) | — | `never` |
| `null` | The null value | `None` | `null` |

**Key insight:** `mixed` in Hack is like `unknown` in TypeScript, **not** like `any`. You must narrow it before using it.

---

## 5. Type Annotations

Hack requires type annotations on function parameters and return types:

```hack
function add(int $x, int $y): int {
  return $x + $y;
}

function greet(string $name): string {
  return "Hello, ".$name;  // string concat uses . (like PHP), not +
}

function is_suspicious(float $score): bool {
  return $score > 0.8;
}
```

**Syntax notes:**
- Variables start with `$` (inherited from PHP)
- String concatenation is `.` (not `+` like Python/TS)
- Return type comes after `):`  — same position as TypeScript

---

## 6. Tuples

Tuples are fixed-length, typed sequences:

```hack
function get_score(): (string, float) {
  return tuple("high_risk", 0.95);
}
```

- Type syntax: `(int, string, bool)` — parenthesized, comma-separated
- Create with `tuple(val1, val2, ...)`
- Access by index: `$t[0]`, `$t[1]`
- **Immutable length** but values can be reassigned

**Python analogy:** Very similar to `tuple[str, float]` type hints.
**TS analogy:** Like `[string, number]` tuple types.

---

## Exercises

See the exercise files in this folder. Work through them in order:
1. `ex01_hello.hack` — Write your first Hack program
2. `ex02_types.hack` — Write typed functions
3. `ex03_predict.hack` — Predict type errors (code reading)
