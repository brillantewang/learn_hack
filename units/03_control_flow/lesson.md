# Unit 03 — Control Flow & Type Refinement

## 1. if / else

Same as Python/TS, but with mandatory braces:

```hack
$score = 0.85;
if ($score > 0.7) {
  echo "High risk\n";
} else if ($score > 0.4) {
  echo "Medium risk\n";
} else {
  echo "Low risk\n";
}
```

**Note:** Hack uses `else if` (two words), not `elseif` (PHP style still works but `else if` is preferred).

Ternary works like TS:
```hack
$label = $score > 0.7 ? "high" : "low";
```

And there's the null coalescing operator `??` — returns the left side if non-null, otherwise the right. Useful when a function returns a nullable type:
```hack
$first = C\first($scores) ?? 0.0;  // C\first returns ?T, so ?? provides a default
$max = Math\max($scores) ?? 0.0;   // Math\max returns ?num
```

**TS analogy:** Identical to `??` in TypeScript.

---

## 2. switch

```hack
$signal_type = "ml";
switch ($signal_type) {
  case "ml":
    echo "Machine learning signal\n";
    break;
  case "rules":
    echo "Rules engine signal\n";
    break;
  default:
    echo "Unknown signal type\n";
    break;
}
```

**Important details:**
- Switch uses **loose comparison** (`==`), not `===`. So `30` will match `30.0`. Watch out for this.
- Fallthrough is allowed but discouraged — you must add a `// FALLTHROUGH` comment or the linter warns. In practice, always use `break` / `return` / `throw`.
- Case values can be runtime expressions, not just literals.

**TS analogy:** Same syntax, but TS switch uses `===` (strict) while Hack uses `==` (loose). Be careful.

---

## 3. Loops

### foreach — the workhorse

```hack
// Over a vec
$scores = vec[0.1, 0.8, 0.5];
foreach ($scores as $score) {
  echo $score."\n";
}

// Over a dict (key => value)
$users = dict[101 => "Alice", 202 => "Bob"];
foreach ($users as $id => $name) {
  echo $id.": ".$name."\n";
}

// Over a keyset
$ids = keyset[1, 2, 3];
foreach ($ids as $id) {
  echo $id."\n";
}
```

### for and while

```hack
// Classic for loop
for ($i = 0; $i < 10; $i++) {
  echo $i."\n";
}

// while
$i = 0;
while ($i < 10) {
  echo $i."\n";
  $i++;
}
```

`break` exits a loop early. `continue` skips to the next iteration:
```hack
foreach ($scores as $score) {
  if ($score < 0.0) {
    continue;  // skip invalid scores
  }
  if ($score > 0.99) {
    break;  // stop processing
  }
  echo $score."\n";
}
```

**When to use what:** Prefer `foreach` for collections (almost always). Use `for` when you need an index counter. Use `while` for condition-based loops. In practice, `foreach` + HSL functions cover 95% of cases.

**Python analogy:** `foreach ($xs as $x)` = `for x in xs`. `foreach ($d as $k => $v)` = `for k, v in d.items()`.

---

## 4. Type Refinement

This is one of Hack's most powerful features. The typechecker tracks what types a variable *could* be at each point in your code, and narrows them based on checks you've written.

### Refinement through null checks

```hack
function greet(?string $name): string {
  // Here, $name is ?string (string or null)
  if ($name is null) {
    return "Hello, stranger";
  }
  // Here, the typechecker KNOWS $name is string (not null)
  return "Hello, ".$name;
}
```

The `?string` type means "string or null" — like TypeScript's `string | null`.

### The `is` operator — type checking

`is` checks the runtime type and refines within the branch:

```hack
function describe(mixed $val): string {
  if ($val is int) {
    // $val is now typed as int in this branch
    return "Integer: ".($val * 2);
  } else if ($val is string) {
    // $val is now typed as string
    return "String: ".$val;
  } else if ($val is float) {
    return "Float: ".$val;
  }
  return "Something else";
}
```

**TS analogy:** Like `typeof` checks that narrow union types, but `is` works with classes too (like `instanceof`).

You can also check for collection types, but **not** generic type parameters (they're erased at runtime):
```hack
if ($val is dict<_, _>) { ... }  // OK — checks it's a dict
if ($val is vec<_>) { ... }      // OK — checks it's a vec
// if ($val is vec<int>) { ... } // ERROR — can't check generic params
```

### The `as` operator — type assertion

`as` asserts a type and **throws** if wrong:

```hack
function process(mixed $val): int {
  $num = $val as int;  // throws TypeAssertionException if not int
  return $num * 2;
}
```

### The `?as` operator — safe type assertion

`?as` returns `null` instead of throwing:

```hack
function maybe_int(mixed $val): ?int {
  return $val ?as int;  // returns null if not int, otherwise the int value
}
```

**When to use which:**
| Operator | Behavior | Use when |
|----------|----------|----------|
| `is` | Check + refine in branch | You want to branch on type |
| `as` | Assert or throw at runtime | Wrong type = a bug, crash early |
| `?as` | Returns null if wrong type | Wrong type is expected, you have a fallback |

`as` vs `?as` example:
```hack
// as — processing trusted data, wrong type is a bug
$score = $data['score'] as float;  // crash if not float

// ?as — processing user input, might not be the right type
$score = $input ?as float;
if ($score is nonnull) {
  flag_if_risky($score);
} else {
  echo "No score provided, skipping\n";
}
```

Note: `?as` returns a nullable type, so you must refine (e.g., null check) before using the value as the target type.

---

## 5. Putting It Together: Refinement in Practice

Type refinement is especially useful when processing mixed data:

```hack
function process_signal(dict<string, mixed> $signal): string {
  $source = idx($signal, 'source') ?? 'unknown';
  // $source is mixed at this point (idx returns mixed for dict<string, mixed>)

  $source_str = $source as string;  // assert it's a string

  $score = idx($signal, 'score');
  if ($score is float) {
    if ($score > 0.8) {
      return $source_str.": HIGH RISK";
    }
    return $source_str.": low risk";
  }
  return $source_str.": no score";
}
```

The typechecker ensures you can't accidentally use `$score` as a float without first proving it is one. This is similar to TypeScript's `unknown` type — but in Hack, `mixed` (the equivalent) comes up more often due to legacy PHP patterns and `dict<string, mixed>` being common.

### `invariant()` — assert + refine

`invariant()` asserts a condition is true and throws `InvariantException` if not. Crucially, the typechecker uses it to refine types:

```hack
function get_score(dict<string, mixed> $data): float {
  $score = idx($data, 'score');
  invariant($score is float, "score must be a float, got %s", \gettype($score));
  // After invariant, typechecker knows $score is float
  return $score * 100.0;
}
```

**Python analogy:** Like `assert`, but with a formatted error message and the typechecker actually trusts it for narrowing.

`invariant()` is a core Hack feature that the docs emphasize heavily. Use it when you're confident a condition holds and want a runtime safety check. As a bonus, the typechecker also uses it for type refinement when the condition involves type checks.

### Gotcha: refinement invalidation

Refinement on object properties is **invalidated** by method calls:

```hack
// This is a preview — we'll cover classes in Unit 07
// Just know that this gotcha exists:
if ($this->value is int) {
  $this->some_method();    // might change $this->value
  // $this->value is NO LONGER refined to int here!
}
```

Why? The typechecker doesn't look inside `some_method()` to figure out whether it modifies `$this->value` — that would be too expensive (methods call methods call methods...). So it takes the safe route and assumes any property might have changed.

Direct assignments in the same scope are fine — the typechecker sees those and tracks the type:
```hack
if ($this->value is int) {
  $this->value = "hello";  // typechecker sees this, knows it's now string
}
```

Local variables don't have this problem — only object properties.

---

## Exercises

See the exercise files in this folder:
1. `ex01_control_flow.hack` — Conditionals, loops, and switch statements
2. `ex02_refinement.hack` — Type refinement with `is`, `as`, `?as`
3. `ex03_predict.hack` — Code reading: predict outputs and spot type errors
