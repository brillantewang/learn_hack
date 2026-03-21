// Exercise 3: Code Reading — Predict Outputs & Spot Errors
//
// For each snippet, predict the output or identify the error.
// Do NOT run this file — work through it mentally first.
// Some snippets have bugs. Find them.
// Fill in your answers in the YOUR ANSWER blocks.

namespace Unit2Ex3;

use namespace HH\Lib\{C, Vec, Dict, Keyset, Str, Math};

// --- Snippet A ---
// What does $result contain?
function snippet_a(): vec<int> {
  $nums = vec[10, 20, 30, 40, 50];
  $result = Vec\filter($nums, $n ==> $n > 25);
  return $result;
}
/* YOUR ANSWER (A):
 * vec[30, 40, 50]
 *
 */

// --- Snippet B ---
// What does $result contain?
function snippet_b(): dict<string, vec<string>> {
  $logs = vec[
    dict['level' => 'error', 'msg' => 'timeout'],
    dict['level' => 'warn', 'msg' => 'slow query'],
    dict['level' => 'error', 'msg' => 'null ref'],
    dict['level' => 'info', 'msg' => 'started'],
  ];
  $result = Dict\group_by($logs, $log ==> $log['level'])
    |> Dict\map($$, $entries ==> Vec\map($entries, $e ==> $e['msg']));
  return $result;
}
/* YOUR ANSWER (B):
 * dict['error' => vec['timeout', 'null ref'], 'warn' => vec['slow query'], 'info' => vec['started']]
 *
 */

// --- Snippet C ---
// What does $result contain? Is there a bug?
function snippet_c(): keyset<int> {
  $a = keyset[1, 2, 3];
  $b = keyset[3, 4, 5];
  $result = Keyset\intersect($a, $b);
  return $result;
}
/* YOUR ANSWER (C):
 * keyset[3] no bug
 *
 */

// --- Snippet D ---
// What does this return? Is there a bug?
function snippet_d(): float {
  $prices = vec[19.99, 5.50, 42.00, 8.75];
  $expensive = Vec\filter($prices, $p ==> $p > 10.0); // vec[19.99, 42.00]
  $total = Math\sum_float($expensive); // 61.99
  $avg = $total / C\count($expensive); // 61.99 / 2
  return $avg;
}
/* YOUR ANSWER (D):
 * 30.995, no bug, unless you cant divide a float by an int (which is returned by C\count)
 *
 */

// --- Snippet E ---
// What does $result contain? Is there a bug?
function snippet_e(): vec<string> {
  $transactions = dict[
    'tx_001' => 150.0,
    'tx_002' => 30.0,
    'tx_003' => 500.0,
    'tx_004' => 75.0,
  ];
  $result = Vec\map(
    Dict\filter($transactions, $amt ==> $amt >= 100.0),
    $amt ==> "flagged: ".$amt,
  );
  return $result;
}
/* YOUR ANSWER (E):
 * vec['flagged: 150.0', 'flagged: 500.0'] no bug since floats auto cast to strings when using .
 *
 */

/* GRADING — 4.5/5
 *
 * A: Correct.
 * B: Correct. Read the pipe operator naturally.
 * C: Correct.
 * D: Value correct (30.995). Missed the bug: if $expensive is empty,
 *    C\count() returns 0 → division by zero. Always guard against
 *    empty collections when doing aggregations.
 * E: Correct that it works. Float-to-string coercion via . is valid.
 *    Minor note: Hack may render 150.0 as "150" (dropping .0) depending
 *    on the value. Also worth noting: dict keys (tx_001, etc.) are
 *    silently dropped by Vec\map — intended behavior, not a bug.
 */
