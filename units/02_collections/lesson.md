# Unit 02 — Collections

## 1. Why Hack Ditched PHP Arrays

PHP's `array` is a single type that acts as a list, a dict, and a set — all at once. This makes it impossible to type precisely. Hack replaced it with three distinct types:

| Hack type | What it is | Python equivalent | TS equivalent |
|-----------|-----------|-------------------|---------------|
| `vec<T>` | Ordered list | `list[T]` | `T[]` |
| `dict<Tk, Tv>` | Key-value map | `dict[Tk, Tv]` | `Record<Tk, Tv>` |
| `keyset<T>` | Set of unique values | `set[T]` | `Set<T>` |

**Key rule:** `Tk` (dict/keyset keys) must be `arraykey` — i.e., `int` or `string`. No object keys.

---

## 2. vec — Ordered Lists

```hack
// Creation
$scores = vec[0.85, 0.92, 0.41];
$empty = vec[];

// Access (0-indexed)
$first = $scores[0];  // 0.85

// Append
$scores[] = 0.77;  // vec[0.85, 0.92, 0.41, 0.77]

// Update
$scores[0] = 0.99;

// Length
$len = C\count($scores);
```

**No direct removal by index.** Use `Vec\take()`, `Vec\drop()`, or `Vec\filter()` instead. This is by design — removing from a list is usually a code smell.

**Python analogy:** Like `list`, but no `.append()` method — mutation uses `$v[] = val` syntax.

---

## 3. dict — Key-Value Maps

```hack
// Creation
$user = dict['name' => 'Alice', 'role' => 'analyst'];
$risk_scores = dict[12345 => 0.85, 67890 => 0.12];

// Access
$name = $user['name'];  // 'Alice'

// Add/Update
$user['team'] = 'fraud';

// Remove
unset($user['role']);

// Check key exists
$has_name = C\contains_key($user, 'name');  // true
```

**TS analogy:** Like `Record<string, string>`, but mutable and with `unset()` instead of `delete`.

**Gotcha:** Accessing a missing key throws at runtime. Always check with `C\contains_key()` or use `idx()` for a default:

```hack
// idx() — safe access with a default (like Python's dict.get())
$role = idx($user, 'role');           // returns null if key missing
$role = idx($user, 'role', 'unknown'); // returns 'unknown' if key missing
```

`idx()` is extremely common in production Hack code — prefer it over raw `$dict['key']` when the key might not exist.

---

## 4. keyset — Unique Values

```hack
// Creation
$flagged_ids = keyset[101, 202, 303];

// Add
$flagged_ids[] = 404;

// Remove
unset($flagged_ids[202]);

// Membership check
$is_flagged = C\contains_key($flagged_ids, 101);  // true
```

**Key insight:** In a keyset, values ARE the keys. `$flagged_ids[101]` returns `101` — it's a membership check that returns the value itself.

**Python analogy:** Like `set()`, but only `int` or `string` elements (no objects).

---

## 5. HSL (Hack Standard Library) Namespaces

Hack's standard library is organized into namespaces. These are your bread and butter:

| Namespace | Purpose | Example |
|-----------|---------|---------|
| `C\` | **C**ounting/checking collections | `C\count()`, `C\contains()`, `C\is_empty()`, `C\first()`, `C\find()` |
| `Vec\` | Transform → returns `vec` | `Vec\map()`, `Vec\filter()`, `Vec\sort()` |
| `Dict\` | Transform → returns `dict` | `Dict\map()`, `Dict\filter()`, `Dict\merge()` |
| `Keyset\` | Transform → returns `keyset` | `Keyset\filter()`, `Keyset\union()`, `Keyset\intersect()`, `Keyset\keys()` |
| `Str\` | String operations | `Str\contains()`, `Str\split()`, `Str\join()` |
| `Math\` | Math operations | `Math\sum()`, `Math\max()`, `Math\min()` |

**Pattern:** The namespace tells you the *return type*. `Vec\map($dict, ...)` takes a dict but returns a vec. `Dict\filter($dict, ...)` takes a dict and returns a dict.

### Common operations

```hack
// Map: transform each element
$doubled = Vec\map($scores, $s ==> $s * 2.0);

// Filter: keep elements matching a condition
$high_risk = Vec\filter($scores, $s ==> $s > 0.8);

// Check if empty
$empty = C\is_empty($scores);

// First/last element (returns null if empty)
$first = C\first($scores);
$last = C\last($scores);

// Sort
$sorted = Vec\sort($scores);  // ascending by default

// Count
$n = C\count($scores);

// Reduce (fold)
$total = C\reduce($scores, ($acc, $s) ==> $acc + $s, 0.0);

// Extract keys from a dict as a keyset
$keys = Keyset\keys($user);  // keyset['name', 'team']

// Group elements by a key function → dict<Tk, vec<Tv>>
$signals = vec['ml_101', 'rules_202', 'ml_303'];
$grouped = Dict\group_by($signals, $s ==> Str\split($s, '_')[0]);
// dict['ml' => vec['ml_101', 'ml_303'], 'rules' => vec['rules_202']]

// Find first element matching a predicate (returns null if none)
$first_high = C\find($scores, $s ==> $s > 0.9);

// Concatenate two vecs
$all = Vec\concat(vec[1, 2], vec[3, 4]);  // vec[1, 2, 3, 4]

// Math on collections
$max = Math\max($scores);    // returns ?float (null if empty)
$sum = Math\sum_float($scores);
```

**TS analogy:** `Vec\map` = `.map()`, `Vec\filter` = `.filter()`, `C\reduce` = `.reduce()`. The difference: these are **free functions**, not methods. Hack collections don't have methods.

---

## 6. Lambda Syntax (Preview)

You'll see this everywhere with collections. Quick primer (full coverage in Unit 04):

```hack
// Long form
$f = ($x) ==> { return $x * 2; };

// Short form (single expression, implicit return)
$f = $x ==> $x * 2;

// With type annotations
$f = (int $x): int ==> $x * 2;
```

**TS analogy:** `==>` is Hack's `=>`. Otherwise nearly identical.

---

## Exercises

See the exercise files in this folder:
1. `ex01_basics.hack` — Create and manipulate vec, dict, keyset
2. `ex02_hsl.hack` — Data transformation pipelines using HSL functions
3. `ex03_predict.hack` — Code reading: predict outputs and spot errors
