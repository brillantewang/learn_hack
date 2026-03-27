// Week 1 Assessment — Mini-Project: Transaction Alert Pipeline
//
// Build a fraud alert pipeline that processes raw transaction data
// through several stages: parsing, filtering, scoring, and reporting.
//
// This exercise synthesizes: collections, type aliases, pipes, closures,
// type refinement, HSL functions, and tuples.
//
// Why a CLI tool?
//   The curriculum calls for a "CLI data processor." We haven't covered
//   file I/O or argument parsing yet, so this version uses hardcoded
//   sample data and prints to stdout. You can run it end-to-end with:
//     hhvm units/05_week1_assessment/ex02_mini_project.hack
//   The individual functions are also validated by Ex02MiniProjectTest.
//
// Instructions:
//   Implement each function below according to its docblock.
//   Run tests: vendor/bin/hacktest units/05_week1_assessment/Ex02MiniProjectTest.hack
//   Run CLI:   hhvm units/05_week1_assessment/ex02_mini_project.hack
//
// Expected CLI output (using the sample data in main):
//   FRAUD ALERT REPORT
//   ---
//   High risk (3):
//     [CRYPTO] TXN-006: $8000.00 (score: 140)
//     [WIRE] TXN-004: $12000.00 (score: 135)
//     [WIRE] TXN-001: $5000.00 (score: 115)
//   ---
//   Total flagged amount: $25000.00
//   Avg risk score: 130

namespace Unit5Ex2;

use namespace HH\Lib\{Vec, Dict, Str, Math, C};

// ── Type Aliases ──

// A RiskScore is an int, but should be opaque outside this file.
// Outside code can compare scores (treat as num).
newtype RiskScore as num = int;

// A channel a transaction can come through.
type Channel = string; // "wire", "card", "crypto", "ach"

// Raw transaction tuple: (id, amount, channel, country_code)
type RawTransaction = (string, float, Channel, string);

// Parsed into a structured shape.
type Transaction = shape(
  'id' => string,
  'amount' => float,
  'channel' => Channel,
  'country' => string,
);

// ── Helper: RiskScore constructor ──
function make_risk_score(int $score): RiskScore {
  return $score;
}

// ── 1. parse_transactions ──
// Convert a vec of RawTransaction tuples into a vec of Transaction shapes.
function parse_transactions(
  vec<RawTransaction> $raw,
): vec<Transaction> {
  // TODO
}

// ── 2. score_transaction ──
// Calculate a RiskScore for a single transaction using these rules:
//   - Base score: 10
//   - amount >= 1000  → +30
//   - amount >= 5000  → +50 (in addition to the +30 above)
//   - channel is "wire"   → +25
//   - channel is "crypto" → +30
//   - country is NOT "US" → +20
// Return the total RiskScore.
function score_transaction(Transaction $txn): RiskScore {
  // TODO
}

// ── 3. score_all ──
// Given a vec of Transactions and a scoring function, return a dict
// mapping transaction ID => RiskScore.
// Use the pipe operator.
function score_all(
  vec<Transaction> $txns,
  (function(Transaction): RiskScore) $scorer,
): dict<string, RiskScore> {
  // TODO
}

// ── 4. filter_high_risk ──
// Given the scores dict and a threshold (int), return only the
// transactions whose score >= threshold.
// Return dict<string, RiskScore> with only the high-risk entries.
function filter_high_risk(
  dict<string, RiskScore> $scores,
  int $threshold,
): dict<string, RiskScore> {
  // TODO
}

// ── 5. build_report ──
// Given the original transactions and the high-risk scores dict, produce
// a formatted report string. Use pipes and HSL string functions.
//
// Format:
//   FRAUD ALERT REPORT
//   ---
//   High risk ({count}):
//     [{CHANNEL}] {id}: ${amount} (score: {score})
//     ... (sorted by score descending)
//   ---
//   Total flagged amount: ${total}
//   Avg risk score: {avg}
//
// - Channel should be uppercased.
// - Amount formatted to 2 decimal places: use Str\format("%.2f", $amt)
// - Avg risk score is integer division (rounded down): use Math\int_div
// - Look up each transaction's details from the $txns vec by matching ID.
function build_report(
  vec<Transaction> $txns,
  dict<string, RiskScore> $high_risk_scores,
): string {
  // TODO
}

// ── CLI Entry Point ──
// Runs the full pipeline on sample data and prints the report.
<<__EntryPoint>>
async function main(): Awaitable<void> {
  $raw = vec[
    tuple("TXN-001", 5000.0, "wire", "US"),
    tuple("TXN-002", 200.0, "card", "US"),
    tuple("TXN-003", 1500.0, "ach", "US"),
    tuple("TXN-004", 12000.0, "wire", "NG"),
    tuple("TXN-005", 800.0, "card", "US"),
    tuple("TXN-006", 8000.0, "crypto", "RU"),
  ];

  $txns = parse_transactions($raw);
  $scores = score_all($txns, score_transaction<>);
  $high_risk = filter_high_risk($scores, 80);
  $report = build_report($txns, $high_risk);

  echo $report;
}
