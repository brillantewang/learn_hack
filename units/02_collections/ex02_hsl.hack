// Exercise 2: HSL Data Transformation Pipelines
//
// Build fraud-detection data pipelines using HSL functions.
// Run with: hhvm ex02_hsl.hack

namespace Unit2Ex2;

use namespace HH\Lib\{C, Vec, Dict, Keyset, Str, Math};

// 1. Takes a dict of user_id => risk_score.
//    Returns a vec of formatted strings for scores above 0.7, like:
//    vec["User 101: 0.85", "User 303: 0.92"]
//    Expected output: "User 101: 0.85" and "User 303: 0.92" (one per line)
function high_risk_alerts(dict<int, float> $scores): vec<string> {
  $transformed = Vec\map_with_key(Dict\filter($scores, $score ==> $score > 0.7), ($user_id, $score) ==> "User ".$user_id.": ".$score);
  return $transformed;
}

// 2. Takes a vec of transaction description strings like:
//    vec["WIRE 500", "POS 20", "WIRE 1000", "ATM 50", "WIRE 200"]
//    Returns the total amount for transactions starting with "WIRE".
//    Expected output: "Wire total: 1700"
function total_wire_amount(vec<string> $transactions): float {
  $filtered = Vec\filter($transactions, $transaction ==> Str\contains($transaction, "WIRE"));
  $amounts = Vec\map($filtered, $transaction ==> (float)(Str\split($transaction, " ")[1]));
  return Math\sum_float($amounts);
}

// 3. Takes a vec of dicts, each representing a detection signal:
//    vec[dict['source' => 'ml', 'id' => '101'], dict['source' => 'rules', 'id' => '202'], ...]
//    Returns a dict<string, vec<string>> grouping IDs by source, like:
//    dict['ml' => vec['101', '303'], 'rules' => vec['202']]
//    Expected output: "ml: 101, 303" and "rules: 202, 404" (one per line)
function group_by_source(vec<dict<string, string>> $signals): dict<string, vec<string>> {
  // TODO
}

<<__EntryPoint>>
async function main(): Awaitable<void> {
  // Test 1
  $scores = dict[101 => 0.85, 202 => 0.3, 303 => 0.92, 404 => 0.1];
  $alerts = high_risk_alerts($scores);
  foreach ($alerts as $a) { echo $a."\n"; }

  echo "\n";

  // Test 2
  $txns = vec["WIRE 500", "POS 20", "WIRE 1000", "ATM 50", "WIRE 200"];
  echo "Wire total: ".total_wire_amount($txns)."\n";

  echo "\n";

  // Test 3
  $signals = vec[
    dict['source' => 'ml', 'id' => '101'],
    dict['source' => 'rules', 'id' => '202'],
    dict['source' => 'ml', 'id' => '303'],
    dict['source' => 'rules', 'id' => '404'],
  ];
  $grouped = group_by_source($signals);
  foreach ($grouped as $source => $ids) {
    echo $source.": ".Str\join($ids, ", ")."\n";
  }
}
