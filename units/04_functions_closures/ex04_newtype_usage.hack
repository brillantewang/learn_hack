// Exercise 4: Newtype — Using opaque types from outside
//
// This file uses the newtypes defined in ex04_newtype_types.hack.
// You are "outside" the defining file, so you can only use the exported API.
//
// Implement each function according to its description.
// Run tests: vendor/bin/hacktest units/04_functions_closures/Ex04NewtypeTest.hack
//
// Expected output from main():
//   TXN-001
//   invalid
//   Risk: 75
//   High risk: true
//   Combined > 50: true

namespace Unit4Ex4Usage;

use namespace Unit4Ex4;
use namespace HH\Lib\{C, Math};

// 5. format_transaction(Unit4Ex4\TransactionId $id): string
//    Returns "Transaction: " followed by the string representation of the ID.
//    Remember: TransactionId is fully opaque — you can't treat it as a string
//    directly. Use the API from the defining file.
function format_transaction(Unit4Ex4\TransactionId $id): string {
  return "Transaction: ".(Unit4Ex4\transaction_id_to_string($id));
}

// 6. is_high_risk(Unit4Ex4\RiskLevel $level): bool
//    Returns true if the risk level is greater than 70.
//    RiskLevel has `as num`, so you CAN compare it directly — no API call needed.
function is_high_risk(Unit4Ex4\RiskLevel $level): bool {
  return $level > 70;
}

// 7. highest_risk(vec<Unit4Ex4\RiskLevel> $levels): ?Unit4Ex4\RiskLevel
//    Returns the highest risk level, or null if the vec is empty.
//    Since RiskLevel `as num`, you can compare values.
//    Hint: think about what HSL functions work with comparable types.
function highest_risk(
  vec<Unit4Ex4\RiskLevel> $levels,
): ?Unit4Ex4\RiskLevel {
  return Math\max($levels);
}

<<__EntryPoint>>
async function main(): Awaitable<void> {
  // TransactionId (fully opaque)
  $txn = Unit4Ex4\make_transaction_id("TXN-001");
  if ($txn is nonnull) {
    echo Unit4Ex4\transaction_id_to_string($txn)."\n";  // TXN-001
  }

  $bad = Unit4Ex4\make_transaction_id("BAD-123");
  echo ($bad is nonnull ? "valid" : "invalid")."\n";  // invalid

  // RiskLevel (as num — can compare and do math)
  $risk = Unit4Ex4\make_risk_level(75);
  echo "Risk: ".$risk."\n";              // Risk: 75 (as num allows concat)
  echo "High risk: ".(is_high_risk($risk) ? "true" : "false")."\n";  // true

  $r1 = Unit4Ex4\make_risk_level(60);
  $r2 = Unit4Ex4\make_risk_level(80);
  $combined = Unit4Ex4\combine_risk_levels($r1, $r2);
  echo "Combined > 50: ".($combined > 50 ? "true" : "false")."\n";  // true
}
