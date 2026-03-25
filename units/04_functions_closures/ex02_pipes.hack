// Exercise 2: Pipe Operator — Data Pipelines
//
// Implement each function using the pipe operator (|>).
// Run with: hhvm ex02_pipes.hack
// Run tests: vendor/bin/hacktest units/04_functions_closures/Ex02PipesTest.hack
//
// Expected output from main():
//   $220, $165
//   velocity_spike: 0.9 | geo_anomaly: 0.7 | device_mismatch: 0.6

namespace Unit4Ex2;

use namespace HH\Lib\{Vec, Str, Math, C};

// 1. process_transaction_amounts(vec<float> $amounts): string
//    Takes a vec of transaction amounts and processes them through a pipeline:
//    - Filter to amounts > 100.0
//    - Multiply each by 1.1 (add 10% fee)
//    - Round each to 2 decimal places using Math\round($$, 2) in the map
//    - Format each as a string with "$" prefix
//    - Join with ", "
//    Must use the pipe operator (|>).
//
//    Example:
//      process_transaction_amounts(vec[50.0, 200.0, 150.0])
//        => "$220, $165"
//      process_transaction_amounts(vec[10.0, 20.0])
//        => ""
function process_transaction_amounts(vec<float> $amounts): string {
  // TODO: implement using pipe operator (|>)
  return '';
}

// 2. build_alert_summary(vec<(string, float)> $alerts): string
//    Takes a vec of tuples (alert_name, severity_score) and builds a summary:
//    - Filter to alerts with severity > 0.5
//    - Sort by severity descending (use Vec\sort_by with negation for desc)
//    - Take the top 3 (use Vec\take)
//    - Format each as "name: score"
//    - Join with " | "
//    Must use the pipe operator (|>).
//
//    Example:
//      build_alert_summary(vec[
//        tuple("velocity_spike", 0.9),
//        tuple("low_balance", 0.3),
//        tuple("geo_anomaly", 0.7),
//        tuple("device_mismatch", 0.6),
//        tuple("normal_login", 0.1),
//      ])
//        => "velocity_spike: 0.9 | geo_anomaly: 0.7 | device_mismatch: 0.6"
function build_alert_summary(vec<(string, float)> $alerts): string {
  // TODO: implement using pipe operator (|>)
  return '';
}

<<__EntryPoint>>
async function main(): Awaitable<void> {
  // 1. process_transaction_amounts
  echo process_transaction_amounts(vec[50.0, 200.0, 150.0])."\n";
  // Expected: $220, $165

  // 2. build_alert_summary
  echo build_alert_summary(vec[
    tuple("velocity_spike", 0.9),
    tuple("low_balance", 0.3),
    tuple("geo_anomaly", 0.7),
    tuple("device_mismatch", 0.6),
    tuple("normal_login", 0.1),
  ])."\n";
  // Expected: velocity_spike: 0.9 | geo_anomaly: 0.7 | device_mismatch: 0.6
}
