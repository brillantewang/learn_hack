# Unit 04 — Functions, Closures & Type Aliases

## 1. Named Functions

You've been writing these since Unit 01. Quick recap of what you know, plus new details:

```hack
function add(int $x, int $y): int {
  return $x + $y;
}
```

All parameter types and return types must be annotated — no implicit `any` like TS allows.

### Default parameters

```hack
function risk_check(float $score, float $threshold = 0.7): bool {
  return $score > $threshold;
}

risk_check(0.85);       // uses default threshold 0.7
risk_check(0.85, 0.9);  // overrides threshold
```

Required params must come before optional params — the typechecker enforces this.

**Python/TS analogy:** Same behavior. Unlike Python, there's no mutable-default-argument gotcha (`def foo(x=[])`) because Hack collections are value types.

### Variadic parameters

```hack
function sum_all(int $first, int ...$rest): int {
  $total = $first;
  foreach ($rest as $val) {
    $total += $val;
  }
  return $total;
}

sum_all(1, 2, 3, 4);  // $first=1, $rest=vec[2, 3, 4]
```

The variadic param becomes a `vec`. You can also **spread** a vec into a call:
```hack
$nums = vec[2, 3, 4];
sum_all(1, ...$nums);  // same as sum_all(1, 2, 3, 4)
```

**Python analogy:** `*args` → `int ...$rest`. Spread `...$nums` → `*nums`.

---

## 2. Function Types

Functions are first-class values. You can pass them as arguments:

```hack
function apply(int $x, (function(int): int) $f): int {
  return $f($x);
}

apply(5, $x ==> $x * 2);  // 10
```

The type `(function(int): int)` means "a callable that takes an int and returns an int."

**TS comparison:** Hack's `(function(int): int)` is TS's `(x: number) => number`. More verbose, but same idea.

### Function references

To pass a named function (not a lambda), use the `<>` syntax:

```hack
function double(int $x): int { return $x * 2; }

apply(5, double<>);  // 10
```

`double<>` creates a reference to the function without calling it.

---

## 3. Lambdas (Anonymous Functions)

You've used these with `Vec\map`, `Vec\filter`, etc. Here's the full picture:

```hack
// Short form — single expression, implicit return
$double = $x ==> $x * 2;

// Multi-param requires parens
$add = ($x, $y) ==> $x + $y;

// Block form — explicit return
$classify = ($score) ==> {
  if ($score > 0.8) {
    return "high";
  }
  return "low";
};

// With type annotations
$double = (int $x): int ==> $x * 2;
```

### Lambdas vs named functions: scope access

Named functions (`function foo() {}`) can only access their own parameters and local variables — they **cannot** see variables from the surrounding scope. Lambdas (`==>`) automatically capture outer variables:

```hack
$threshold = 0.7;

// Lambda — captures $threshold
$is_risky = $score ==> $score > $threshold;  // OK

// Named function — cannot see $threshold
function is_risky_named(float $score): bool {
  // return $score > $threshold;  // ERROR — $threshold not in scope
  return $score > 0.7;  // must hardcode or pass as param
}
```

### Capture by value — the big gotcha

**This is the most important difference from TS/Python.** Hack lambdas capture variables **by value** (a copy), not by reference:

```hack
$multiplier = 2;
$f = $x ==> $x * $multiplier;  // captures $multiplier=2

$multiplier = 10;  // changing it after
$f(5);             // still returns 10, NOT 50
```

In TS/Python, `$f(5)` would return 50 because closures capture by reference. In Hack, the value is **copied** when the lambda is created. Changes to the original variable don't affect the lambda.

**Why this matters:** If you're building lambdas in a loop, each one captures the value at the time it's created — which is actually *safer* than TS/Python's behavior (the classic "closure in a loop" bug doesn't exist in Hack).

---

## 4. Pipe Operator (`|>`)

Turns deeply nested function calls into readable left-to-right chains. The result of the left side becomes `$$` on the right side:

```hack
// Without pipes (hard to read):
$result = Str\join(Vec\map(Vec\filter($scores, $s ==> $s > 0.5), $s ==> "Score: ".$s), ", ");

// With pipes (reads left to right):
$result = $scores
  |> Vec\filter($$, $s ==> $s > 0.5)
  |> Vec\map($$, $s ==> "Score: ".$s)
  |> Str\join($$, ", ");
```

`$$` is a special placeholder — it only exists on the right side of `|>`. It's not a regular variable.

### Rules
- The right side **must** contain at least one `$$`.
- `$$` can only appear once per pipe stage (it's the single result from the left side).
- **`await` cannot be used on the right side of `|>`.** For async code, use intermediate variables instead.

**No TS/Python equivalent.** This is a Hack-specific feature. Think of it like Unix pipes: `cat file | grep foo | sort`.

---

## 5. Type Aliases

### `type` — transparent alias

Creates a shorthand name for a type. Fully interchangeable everywhere:

```hack
type RiskScore = float;
type SignalMap = dict<string, vec<string>>;
type Detector = (function(float): bool);

function check(RiskScore $score, Detector $detect): bool {
  return $detect($score);
}
```

Useful for avoiding repetition of complex type signatures.

**TS analogy:** Exactly like TS's `type` aliases.

### `newtype` — opaque alias

The defining file encapsulates this type. Only the defining file can treat it as its underlying type. Outside files can only treat it as the `newtype` itself, or as another type specified by the defining file (via `as`). They cannot treat it as its underlying type.

This is purely a typechecker concept — a `newtype UserId = int` is just an int at runtime. Works with any type, not just primitives:

```hack
newtype Config = dict<string, mixed>;
newtype Coordinates = (float, float);
newtype Handler = (function(string): void);
```

#### The defining file: setting the rules

Consider a file that defines `newtype UserId = int`. This file can treat `UserId` as an `int` freely, so it defines functions (the API) for what outside files can do with a `UserId`:

```hack
// user_id.hack (defining file)
newtype UserId = int;

// Constructor — outside files need this to create a UserId
function make_user_id(int $raw): UserId {
  invariant($raw > 0, "User ID must be positive, got %d", $raw);
  return $raw;  // OK — this file knows UserId = int
}

// Only needed without `as arraykey` — outside files can't concat otherwise
function user_id_to_string(UserId $id): string {
  return "user_".$id;  // OK — this file can treat $id as int
}
```

#### Outside files: restricted to the API

An outside file cannot treat a `UserId` as an `int`, because it might do things that don't make sense for a user ID (like arithmetic). It can only use the exported functions:

```hack
// outside file
$id = make_user_id(101);              // OK — uses the constructor
$display = user_id_to_string($id);    // OK — uses exported function
$match = ($id === $other_id);         // OK — === always works on same type

// CANNOT treat as int — these are type errors:
// $id + 1;                // ERROR — don't know it's an int
// echo "ID: ".$id;        // ERROR — can't concat as int
// $names = dict[$id => "Alice"];  // ERROR — can't use as dict key
```

#### With constraint (`as`) — allowing more

Sometimes it's useful for outside files to also treat the value as another type. For example, if you want outside files to use `UserId` as a dict key or in string concatenation, you can add `as arraykey`:

```hack
// user_id.hack (defining file)
newtype UserId as arraykey = int;
//              ^^^^^^^^^^^
// Outside files can now also treat UserId as an arraykey
```

```hack
// outside file
$id = make_user_id(101);

// These NOW work — `as arraykey` allows key and string operations:
$names = dict[$id => "Alice"];   // OK — can use as dict key
$team = keyset[$id];             // OK — can use in keyset
echo "user_".$id;                // OK — can concat as arraykey
// (This makes user_id_to_string unnecessary)

// Still CANNOT treat as int:
// $id + 1;              // ERROR — arraykey doesn't support math
```

#### Why bother?

Even though `UserId` is just an `int` at runtime, we can prevent logical bugs at compile time. The defining file knows what makes sense for a user ID, so it creates the API for outside files. Outside files can only treat it as a `UserId` (or `arraykey` with the constraint). This prevents things like `$user_id + 1` or accidentally passing an amount where a user ID is expected.

See `newtype_demo_types.hack` and `newtype_demo_outside.hack` in this folder for a runnable example with both variants.

| Approach | Outside code can... | Use when |
|----------|-------------------|----------|
| `newtype Foo = T` | Only pass around and use exported functions | Full encapsulation, e.g. validated values |
| `newtype Foo as U = T` | Also treat as `U` | Need some operations (e.g. use as key) without exposing everything |
| `type Foo = T` | Everything — just a shorthand | No encapsulation needed, just readability |

**TS comparison:** No real equivalent. TS's `type` is always transparent. Hack's `newtype` provides actual encapsulation.

**Python comparison:** `NewType` is similar in concept but has zero runtime enforcement.

---

## Exercises

See the exercise files in this folder:
1. `ex01_functions.hack` — Default params, variadic params, spread operator, function types, returning lambdas
2. `ex02_pipes.hack` — Data pipelines with the pipe operator
3. `ex03_predict.hack` — Code reading: predict outputs (capture-by-value, pipes, function refs, type aliases)
4. `ex04_newtype_types.hack` + `ex04_newtype_usage.hack` — Newtype: defining opaque types and using them from outside
