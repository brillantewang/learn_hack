// Exercise 3: Code Reading — Predict Outputs & Spot Errors
//
// For each snippet, predict the output or identify the error.
// Do NOT run this file — work through it mentally first.
// Some snippets have bugs. Find them.
// Fill in your answers in the YOUR ANSWER blocks.

namespace Unit3Ex3;

use namespace HH\Lib\{C, Vec, Dict, Str, Math};

// --- Snippet A ---
// What does $result contain?
function snippet_a(): string {
  $val = 42;
  if ($val is int) {
    $label = "number";
  } else {
    $label = "other";
  }
  return $label;
}
/* YOUR ANSWER (A):
 * number
 *
 */

// --- Snippet B ---
// What does this return? Is there a bug?
function snippet_b(mixed $input): string {
  $val = $input ?as string;
  return "Got: ".$val;
}
/* YOUR ANSWER (B):
 * this would result in a logic bug if $input is not a string and so $val is null and so gets cast as empty string in the result so we lose the value.
 *
 */

// --- Snippet C ---
// What does $result contain?
function snippet_c(): vec<string> {
  $items = vec[
    dict['type' => 'alert', 'msg' => 'high risk'],
    dict['type' => 'info', 'msg' => 'logged in'],
    dict['type' => 'alert', 'msg' => 'unusual location'],
    dict['type' => 'info', 'msg' => 'password changed'],
  ];
  $result = vec[];
  foreach ($items as $item) {
    if ($item['type'] !== 'alert') {
      continue;
    }
    $result[] = Str\uppercase($item['msg']);
  }
  return $result;
}
/* YOUR ANSWER (C):
 * vec['HIGH RISK', 'UNUSUAL LOCATION']
 *
 */

// --- Snippet D ---
// What does this return? Is there a bug?
function snippet_d(dict<string, mixed> $data): float {
  $score = idx($data, 'score');
  invariant($score is float, "expected float");
  $factor = idx($data, 'factor');
  invariant($factor is float, "expected float");
  return $score * $factor;
}
/* YOUR ANSWER (D):
 * no bug, because we type refined both $score and $factor to be floats, so they should be able to be multiplied together
 *
 */

// --- Snippet E ---
// What does this function return for each input? Is there a bug?
//   snippet_e(42)
//   snippet_e(3.14)
//   snippet_e("hello")
function snippet_e(mixed $val): string {
  if ($val is num) {
    if ($val is int) {
      return "integer";
    }
    return "float";
  }
  if ($val is string) {
    return "text";
  }
  return "other";
}
/* YOUR ANSWER (E):
 * input 42 => "integer"
 * input 3.14 => "float"
 * input "hello" => "text"
 * no bugs
 */

/* GRADING — 5/5
 *
 * A: Correct.
 * B: Correct — there's a logic bug. ?as returns null for non-strings,
 *    and Hack's . operator silently converts null to "". So
 *    snippet_b(42) returns "Got: " with no error or indication
 *    that the input was lost.
 * C: Correct.
 * D: Correct — no bug, both values refined by invariant().
 * E: All three correct, no bugs. Good recognition of num narrowing.
 */
