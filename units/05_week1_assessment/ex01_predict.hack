// Week 1 Assessment — Code Reading Quiz
//
// Predict the output of each snippet. Covers Units 1-4.
// Fill in your answers in the YOUR ANSWER blocks.
// Check Ex01PredictAnswers.hack when done.

namespace Unit5Ex1;

use namespace HH\Lib\{Vec, Dict, Str, Math, C, Keyset};

// --- Snippet 1 ---
// What gets printed?
function snippet_1(): void {
  $data = dict[
    "txn_a" => 150.0,
    "txn_b" => 30.0,
    "txn_c" => 200.0,
    "txn_d" => 75.0,
  ];

  $result = $data
    |> Dict\filter($$, $v ==> $v >= 100.0) // "txn_a" => 150.0, "txn_c" => 200.0
    |> Dict\map($$, $v ==> $v * 0.1) //  // "txn_a" => 15.0, "txn_c" => 20.0
    |> Vec\keys($$) //
    |> Str\join($$, ", ");

  echo $result."\n";
}
/* YOUR ANSWER (1):
 *  "txn_a, txn_c"
 */

// --- Snippet 2 ---
// What gets printed?
function snippet_2(): void {
  $process = (vec<int> $nums): string ==> {
    $filtered = Vec\filter($nums, $n ==> $n % 2 === 0);
    return C\count($filtered) |> (string)($$);
  };

  $a = $process(vec[1, 2, 3, 4, 5, 6]);
  $b = $process(vec[1, 3, 5]);

  echo $a." ".$b."\n";
}
/* YOUR ANSWER (2):
 * "3 0"
 */

// --- Snippet 3 ---
// What gets printed? Is there a bug?
function snippet_3(mixed $val): string {
  if ($val is string) {
    return Str\uppercase($val);
  }
  if ($val is int) {
    $doubled = $val * 2;
    return (string)$doubled;
  }
  return "unknown";
}

function run_snippet_3(): void {
  echo snippet_3("alert")."\n";
  echo snippet_3(25)."\n";
  echo snippet_3(3.14)."\n";
}
/* YOUR ANSWER (3):
 * no bugs
 * "ALERT
 *  50
 *  unknown"
 *
 */

// --- Snippet 4 ---
// What gets printed?
function snippet_4(): void {
  $scale = 10;
  $make_scorer = (int $base) ==> {
    return ($x ==> $x * $base + $scale);
  };

  $scorer = $make_scorer(3); // $x ==> $x * 3 + 10
  $scale = 999;

  $scores = vec[1, 2, 3]
    |> Vec\map($$, $scorer) // 13, 16, 19
    |> Vec\map($$, $s ==> (string)$s); // 

  echo Str\join($scores, ", ")."\n";
}
/* YOUR ANSWER (4):
 *  "13, 16, 19"
 */

// --- Snippet 5 ---
// What gets printed?
function snippet_5(): void {
  $transactions = vec[
    tuple("TXN-001", 500.0, "wire"),
    tuple("TXN-002", 50.0, "card"),
    tuple("TXN-003", 300.0, "wire"),
    tuple("TXN-004", 1000.0, "wire"),
    tuple("TXN-005", 200.0, "card"),
  ];

  $result = $transactions
    |> Vec\filter($$, $t ==> $t[2] === "wire") // tuple("TXN-301", 500.0, "wire"), tuple("TXN-003", 300.0, "wire"), tuple("TXN-004", 1000.0, "wire"),
    |> Vec\filter($$, $t ==> $t[1] > 400.0) // tuple("TXN-301", 500.0, "wire"), tuple("TXN-004", 1000.0, "wire")
    |> Vec\map($$, $t ==> $t[0]) // TXN-301, TXN-004
    |> C\count($$);

  $label = $result === 1 ? "transaction" : "transactions";
  echo $result." high-value wire ".$label."\n";
}
/* YOUR ANSWER (5):
 * 2 high-value wire transactions
 */

<<__EntryPoint>>
async function main(): Awaitable<void> {
  snippet_1();
  snippet_2();
  run_snippet_3();
  snippet_4();
  snippet_5();
}

/* GRADING
 * Score: 5/5
 * Date: 2026-03-27
 *
 * Snippet 1: CORRECT — dict pipeline with filter/map/keys/join
 * Snippet 2: CORRECT — typed lambda, pipe inside lambda, count as string
 * Snippet 3: CORRECT — type refinement with is, float falls through to catch-all, no bugs
 * Snippet 4: CORRECT — nested closures, capture-by-value, reassignment has no effect
 * Snippet 5: CORRECT — multi-filter pipeline, count, conditional pluralization
 *            (minor: inline working notes say "TXN-301" instead of "TXN-001", but final answer correct)
 */
