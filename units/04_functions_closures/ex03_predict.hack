// Exercise 3: Code Reading — Predict the Output
//
// For each snippet, predict what will be printed.
// Do NOT run this file — work through it mentally first.
// Fill in your answers in the YOUR ANSWER blocks.
// Check Ex03PredictAnswers.hack when done.

namespace Unit4Ex3;

use namespace HH\Lib\{Vec, Str, Math, C};

// --- Snippet 1 ---
// What gets printed?
function snippet_1(): void {
  $multiplier = 2;
  $compute = $x ==> $x * $multiplier;

  $multiplier = 100;

  echo $compute(10)."\n";
}
/* YOUR ANSWER (1):
 * 20 because captured value is still just 2 in the lambda fn
 */

// --- Snippet 2 ---
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
/* YOUR ANSWER (2):
 * "high => $220.0, $165.0"
 */

// --- Snippet 3 ---
// What gets printed?
function add_five(int $x): int {
  return $x + 5;
}

function apply_twice(int $val, (function(int): int) $f): int { // 15, add_five
  return $f($f($val)); // add_five(add_five(15))
}

function snippet_3(): void {
  $result = apply_twice(15, add_five<>);
  echo $result."\n";
}
/* YOUR ANSWER (3):
 * 25
 */

// --- Snippet 4 ---
// What gets printed?
type AlertHandler = (function(string): string);

function make_handler(string $prefix): AlertHandler { // ALERT
  return $msg ==> $prefix.": ".$msg; // $msg ==> ALERT: $msg
}

function snippet_4(): void {
  $handler = make_handler("ALERT");
  $signals = vec["velocity_spike", "normal_login"];

  $result = $signals
    |> Vec\filter($$, $s ==> Str\contains($s, "spike")) // velocity_spike
    |> Vec\map($$, $handler) // ALERT: velocity_spike
    |> Str\join($$, ", ");

  echo $result."\n";
}
/* YOUR ANSWER (4):
 * "ALERT: velocity_spike"
 */

/* GRADING — 4/4
 *
 * 1: Correct. Capture-by-value means $multiplier=2 is baked in at lambda creation.
 * 2: Correct logic, minor detail: (string) on a whole-number float like 220.0
 *    drops the ".0", so output is "$220, $165" not "$220.0, $165.0".
 * 3: Correct. f(f(15)) = add_five(20) = 25.
 * 4: Correct. Filter keeps "velocity_spike", handler prefixes "ALERT: ".
 */

<<__EntryPoint>>
async function main(): Awaitable<void> {
  snippet_1();
  snippet_2();
  snippet_3();
  snippet_4();
}
