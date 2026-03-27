// Week 1 Assessment — Code Reading Answers
// DO NOT PEEK until you've filled in ex01_predict.hack

namespace Unit5Ex1Answers;

// --- Snippet 1: Dict pipeline + Vec\keys ---
// Dict\filter keeps txn_a (150.0) and txn_c (200.0).
// Dict\map multiplies by 0.1 => dict["txn_a" => 15.0, "txn_c" => 20.0]
// Vec\keys extracts keys => vec["txn_a", "txn_c"]
// Str\join => "txn_a, txn_c"
//
// Answer: txn_a, txn_c

// --- Snippet 2: Lambda with typed params + pipe inside lambda ---
// $process filters even numbers and returns count as string.
// vec[1,2,3,4,5,6] => evens are 2,4,6 => count 3 => "3"
// vec[1,3,5] => no evens => count 0 => "0"
//
// Answer: 3 0

// --- Snippet 3: Type refinement with is + mixed ---
// snippet_3("alert"): $val is string => Str\uppercase("alert") => "ALERT"
// snippet_3(25): $val is int => 25*2 = 50 => "50"
// snippet_3(3.14): not string, not int => "unknown"
// No bugs — float falls through to the catch-all correctly.
//
// Answer:
//   ALERT
//   50
//   unknown

// --- Snippet 4: Nested closures + capture by value ---
// $scale = 10 when $make_scorer is created.
// $make_scorer(3) creates inner lambda capturing $base=3 and $scale=10.
// $scale = 999 happens AFTER both lambdas are created, no effect.
// vec[1,2,3] => map with $scorer: 1*3+10=13, 2*3+10=16, 3*3+10=19
//
// Answer: 13, 16, 19

// --- Snippet 5: Multi-step filter + conditional pluralization ---
// Filter wire: TXN-001(500), TXN-003(300), TXN-004(1000)
// Filter >400: TXN-001(500), TXN-004(1000)
// Map to IDs: vec["TXN-001", "TXN-004"]
// Count: 2
// 2 === 1 ? "transaction" : "transactions" => "transactions"
//
// Answer: 2 high-value wire transactions
