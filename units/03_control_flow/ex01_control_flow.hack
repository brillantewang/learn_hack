// Exercise 1: Control Flow Basics
//
// Implement each function using conditionals, loops, and switch.
// Run with: hhvm ex01_control_flow.hack
// Run tests: vendor/bin/hacktest units/03_control_flow/Ex01ControlFlowTest.hack

namespace Unit3Ex1;

use namespace HH\Lib\{C, Vec, Dict, Str, Math};

// 1. Takes a risk score (float) and returns a label:
//    score > 0.8  → "critical"
//    score > 0.5  → "high"
//    score > 0.2  → "medium"
//    otherwise    → "low"
//    Expected: risk_label(0.85) => "critical", risk_label(0.3) => "medium"
function risk_label(float $score): string {
  if ($score > 0.8) {
    return "critical";
  } else if ($score > 0.5) {
    return "high";
  } else if ($score > 0.2) {
    return "medium";
  }

  return "low";
}

// 2. Takes a signal type string and returns a priority int using a switch:
//    "fraud"    → 1
//    "abuse"    → 2
//    "spam"     → 3
//    anything else → 99
//    Expected: signal_priority("fraud") => 1, signal_priority("other") => 99
function signal_priority(string $type): int {
  switch ($type) {
    case "fraud":
      return 1;
    case "abuse":
      return 2;
    case "spam":
      return 3;
    default:
      return 99;
  }
}

// 3. Takes a vec of transaction amounts and returns a dict with:
//    'count' => number of positive amounts (as float)
//    'total' => sum of only the positive amounts
//    Use a foreach loop (not HSL filter/map).
//    Expected: summarize_positive(vec[100.0, -50.0, 200.0, -10.0]) =>
//              dict['count' => 2.0, 'total' => 300.0]
function summarize_positive(vec<float> $amounts): dict<string, float> {
  $res = dict['count' => 0.0, 'total' => 0.0];
  foreach ($amounts as $amount) {
    if ($amount > 0) {
      $res['count'] = $res['count'] + 1;
      $res['total'] = $res['total'] + $amount;
    }
  }
  return $res;
}

// 4. Takes a vec of nullable strings (?string) representing user IDs.
//    Returns a vec containing only the non-null IDs, uppercased.
//    Use a foreach loop with a null check.
//    Expected: clean_ids(vec["abc", null, "def", null, "ghi"]) =>
//              vec["ABC", "DEF", "GHI"]
function clean_ids(vec<?string> $ids): vec<string> {
  $res = vec[];
  foreach ($ids as $id) {
    if ($id !== null) {
      $res[] = Str\uppercase($id);
    }
  }
  return $res;
}

<<__EntryPoint>>
async function main(): Awaitable<void> {
  // Test 1
  echo risk_label(0.85)."\n";  // critical
  echo risk_label(0.3)."\n";   // medium

  echo "\n";

  // Test 2
  echo signal_priority("fraud")."\n";   // 1
  echo signal_priority("other")."\n";   // 99

  echo "\n";

  // Test 3
  $summary = summarize_positive(vec[100.0, -50.0, 200.0, -10.0]);
  echo "Count: ".$summary['count'].", Total: ".$summary['total']."\n";

  echo "\n";

  // Test 4
  $clean = clean_ids(vec["abc", null, "def", null, "ghi"]);
  echo Str\join($clean, ", ")."\n";  // ABC, DEF, GHI
}
