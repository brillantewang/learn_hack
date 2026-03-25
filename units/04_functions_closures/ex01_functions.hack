// Exercise 1: Functions — Default Params, Variadic Params, Function Types
//
// Implement each function according to its description.
// Run with: hhvm ex01_functions.hack
// Run tests: vendor/bin/hacktest units/04_functions_closures/Ex01FunctionsTest.hack
//
// Expected output from main():
//   0.75
//   0.9
//   1
//   0
//   600
//   0
//   0.6
//   0.5
//   0.8, 0.9
//   Checker(0.6): false
//   Checker(0.8): true

namespace Unit4Ex1;

use namespace HH\Lib\{Vec, Str, Math, C};

// 1. calculate_risk_score(float $base_score, float $weight = 1.0, float $bias = 0.0): float
//    Returns $base_score * $weight + $bias, clamped to the range [0.0, 1.0].
//    - If the result is below 0.0, return 0.0.
//    - If the result is above 1.0, return 1.0.
//    Examples:
//      calculate_risk_score(0.75)           => 0.75
//      calculate_risk_score(0.5, 1.8, 0.0)  => 0.9
//      calculate_risk_score(0.5, 3.0, 0.0)  => 1.0  (clamped)
//      calculate_risk_score(0.5, 1.0, -0.8) => 0.0  (clamped)
function calculate_risk_score(
  float $base_score,
  float $weight = 1.0,
  float $bias = 0.0,
): float {
  $res = $base_score * $weight + $bias
    |> Math\maxva($$, 0.0)
    |> Math\minva($$, 1.0);
  return $res;
}

// 2. sum_amounts(float ...$amounts): float
//    Returns the sum of all amounts passed as variadic arguments.
//    If no amounts are passed, returns 0.0.
//    Examples:
//      sum_amounts(100.0, 200.0, 300.0) => 600.0
//      sum_amounts()                     => 0.0
function sum_amounts(float ...$amounts): float {
  return Math\sum_float($amounts);
}

// 3. combine_risk_scores(float $base, vec<float> $adjustments): float
//    Uses the spread operator to pass $base followed by all $adjustments
//    into sum_amounts, then divides by the total count (1 + length of adjustments)
//    to get the average.
//    Example:
//      combine_risk_scores(0.8, vec[0.6, 0.4])  => 0.6  (sum=1.8, count=3)
//      combine_risk_scores(0.5, vec[])           => 0.5  (sum=0.5, count=1)
function combine_risk_scores(float $base, vec<float> $adjustments): float {
  $sum = sum_amounts($base, ...$adjustments);
  $count = C\count($adjustments) + 1;
  return $sum / $count;
}

// 4. apply_detector(vec<float> $scores, (function(float): bool) $detector): vec<float>
//    Returns only the scores for which $detector returns true.
//    Example:
//      apply_detector(vec[0.3, 0.8, 0.9, 0.1], $s ==> $s > 0.5)
//        => vec[0.8, 0.9]
function apply_detector(
  vec<float> $scores,
  (function(float): bool) $detector,
): vec<float> {
  return Vec\filter($scores, $detector);
}

// 5. make_threshold_checker(float $threshold): (function(float): bool)
//    Returns a lambda that checks if a given score EXCEEDS (strictly greater than)
//    the threshold.
//    Example:
//      $checker = make_threshold_checker(0.7);
//      $checker(0.6)  => false
//      $checker(0.8)  => true
function make_threshold_checker(float $threshold): (function(float): bool) {
  return (float $score): bool ==> $score > $threshold;
}

<<__EntryPoint>>
async function main(): Awaitable<void> {
  // 1. calculate_risk_score
  echo calculate_risk_score(0.75)."\n";           // 0.75
  echo calculate_risk_score(0.5, 1.8, 0.0)."\n";  // 0.9
  echo calculate_risk_score(0.5, 3.0, 0.0)."\n";  // 1 (clamped)
  echo calculate_risk_score(0.5, 1.0, -0.8)."\n"; // 0 (clamped)

  // 2. sum_amounts
  echo sum_amounts(100.0, 200.0, 300.0)."\n";  // 600
  echo sum_amounts()."\n";                       // 0

  // 3. combine_risk_scores
  echo combine_risk_scores(0.8, vec[0.6, 0.4])."\n";  // 0.6
  echo combine_risk_scores(0.5, vec[])."\n";            // 0.5

  // 4. apply_detector
  $high = apply_detector(vec[0.3, 0.8, 0.9, 0.1], $s ==> $s > 0.5);
  echo Str\join(Vec\map($high, $s ==> (string)$s), ", ")."\n";  // 0.8, 0.9

  // 5. make_threshold_checker
  $checker = make_threshold_checker(0.7);
  echo "Checker(0.6): ".($checker(0.6) ? "true" : "false")."\n";  // false
  echo "Checker(0.8): ".($checker(0.8) ? "true" : "false")."\n";  // true
}
