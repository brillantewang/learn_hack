// Exercise 4: Newtype — Opaque Type Aliases (defining file)
//
// This file defines two newtypes and their APIs.
// Implement each function according to its description.
//
// The companion file ex04_newtype_usage.hack uses these types from "outside."
// Run tests: vendor/bin/hacktest units/04_functions_closures/Ex04NewtypeTest.hack

namespace Unit4Ex4;

use namespace HH\Lib\{Str, Math};

// --- TransactionId: fully opaque ---
// A validated transaction ID. Must be a non-empty string starting with "TXN-".
newtype TransactionId = string;

// 1. make_transaction_id(string $raw): ?TransactionId
//    Returns null if $raw is empty or doesn't start with "TXN-".
//    Otherwise returns the value as a TransactionId.
function make_transaction_id(string $raw): ?TransactionId {
  if ($raw === "" || !Str\starts_with($raw, "TXN-")) {
    return null;
  }
  return $raw;
}

// 2. transaction_id_to_string(TransactionId $id): string
//    Returns the underlying string. Outside files need this since
//    TransactionId is fully opaque (no `as` constraint).
function transaction_id_to_string(TransactionId $id): string {
  return $id;
}

// --- RiskLevel: opaque with `as num` constraint ---
// A risk level from 0-100. Outside files can compare and do math with it
// (since num supports those), but can't create arbitrary values.
newtype RiskLevel as num = int;

// 3. make_risk_level(int $value): RiskLevel
//    Clamps the value to [0, 100] and returns it as a RiskLevel.
function make_risk_level(int $value): RiskLevel {
  return $value
    |> Math\maxva($$, 0)
    |> Math\minva($$, 100);
}

// 4. combine_risk_levels(RiskLevel $a, RiskLevel $b): RiskLevel
//    Returns the average of two risk levels (integer division is fine).
//    This file can treat RiskLevel as int freely.
function combine_risk_levels(RiskLevel $a, RiskLevel $b): RiskLevel {
  return \intdiv($a + $b, 2);
}
