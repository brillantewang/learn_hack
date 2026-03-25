// Exercise 3: Code Reading — Predict the Output
//
// For each snippet, predict what will be printed BEFORE running the code.
// Work through each one mentally, then check your answers below.
//
// ============================================================
// ANSWERS (don't peek until you've predicted!):
//
//   Snippet 1: 20
//   Snippet 2: high => $220, $165
//   Snippet 3: 25
//   Snippet 4: ALERT: velocity_spike
// ============================================================

namespace Unit4Ex3;

use namespace HH\Lib\{Vec, Str, Math, C};

// --- Snippet 1: Capture by value ---
// A variable changes AFTER the lambda is created.
// What gets printed?
function snippet_1(): void {
  $multiplier = 2;
  $compute = $x ==> $x * $multiplier;

  $multiplier = 100;  // changed after lambda creation

  echo $compute(10)."\n";
}

// --- Snippet 2: Pipe operator chaining ---
// Trace through the pipeline step by step.
// What gets printed?
function snippet_2(): void {
  $amounts = vec[50.0, 200.0, 150.0, 30.0];

  $label = $amounts
    |> Vec\filter($$, $a ==> $a > 100.0)
    |> C\count($$);

  $category = $label > 1 ? "high" : "low";

  $summary = $amounts
    |> Vec\filter($$, $a ==> $a > 100.0)
    |> Vec\map($$, $a ==> "$".((string)($a * 1.1)))
    |> Str\join($$, ", ");

  echo $category." => ".$summary."\n";
}

// --- Snippet 3: Function references vs calling ---
// Pay close attention to how the function is used.
// What gets printed?
function add_five(int $x): int {
  return $x + 5;
}

function apply_twice(int $val, (function(int): int) $f): int {
  return $f($f($val));
}

function snippet_3(): void {
  $result = apply_twice(15, add_five<>);
  echo $result."\n";
}

// --- Snippet 4: Type alias + function type ---
// Trace through the types and function calls.
// What gets printed?
type AlertHandler = (function(string): string);

function make_handler(string $prefix): AlertHandler {
  return $msg ==> $prefix.": ".$msg;
}

function snippet_4(): void {
  $handler = make_handler("ALERT");
  $signals = vec["velocity_spike", "normal_login"];

  $result = $signals
    |> Vec\filter($$, $s ==> Str\contains($s, "spike"))
    |> Vec\map($$, $handler)
    |> Str\join($$, ", ");

  echo $result."\n";
}

<<__EntryPoint>>
async function main(): Awaitable<void> {
  snippet_1();
  snippet_2();
  snippet_3();
  snippet_4();
}
