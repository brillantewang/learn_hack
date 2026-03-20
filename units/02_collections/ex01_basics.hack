// Exercise 1: Collection Basics
//
// Implement each function. Run with: hhvm ex01_basics.hack

namespace Unit2Ex1;

use namespace HH\Lib\{C, Vec, Dict, Keyset, Str, Math};

// 1. Takes a vec of risk scores and returns only scores above the given threshold.
function high_risk_scores(vec<float> $scores, float $threshold): vec<float> {
  return Vec\filter($scores, $score ==> $score > $threshold);
}

// 2. Takes a dict mapping user_id => account_age_days.
//    Returns a keyset of user IDs where the account is newer than 30 days.
function new_accounts(dict<int, int> $accounts): keyset<int> {
  $filtered = Dict\filter($accounts, $age ==> $age < 30);
  // return Keyset\map_with_key($filtered, ($user_id, $_) ==> $user_id);
  return Keyset\keys($filtered);
}

// 3. Takes a vec of transaction amounts and returns a dict with these keys:
//    'count' => number of transactions (as float)
//    'total' => sum of all amounts
//    'max'   => largest amount
//    Returns dict<string, float>
function transaction_summary(vec<float> $amounts): dict<string, float> {
  $count = (float)C\count($amounts);
  // $total = C\reduce($amounts, ($acc, $amount) ==> $acc + $amount, 0.0);
  $total = (float)Math\sum_float($amounts);
  // $max = (float)C\last(Vec\sort($amounts));
  $max = (float)Math\max($amounts);

  return dict["count" => $count, "total" => $total, "max" => $max];
}

// 4. Takes two keysets of flagged user IDs (from different detection systems)
//    and returns the combined set of all flagged IDs.
function merge_flagged(keyset<int> $system_a, keyset<int> $system_b): keyset<int> {
  return Keyset\union($system_a, $system_b);
}

<<__EntryPoint>>
async function main(): Awaitable<void> {
  // Test 1
  $scores = vec[0.2, 0.85, 0.5, 0.95, 0.1];
  $high = high_risk_scores($scores, 0.8);
  echo "High risk: ";
  foreach ($high as $s) { echo $s." "; }
  echo "\n";

  // Test 2
  $accounts = dict[101 => 5, 202 => 90, 303 => 15, 404 => 365];
  $new = new_accounts($accounts);
  echo "New accounts: ";
  foreach ($new as $id) { echo $id." "; }
  echo "\n";

  // Test 3
  $amounts = vec[100.0, 250.0, 75.0, 500.0];
  $summary = transaction_summary($amounts);
  echo "Count: ".$summary['count'].", Total: ".$summary['total'].", Max: ".$summary['max']."\n";

  // Test 4
  $a = keyset[1, 2, 3];
  $b = keyset[2, 3, 4, 5];
  $merged = merge_flagged($a, $b);
  echo "Merged: ";
  foreach ($merged as $id) { echo $id." "; }
  echo "\n";
}
