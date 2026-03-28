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
// RiskScore is defined in risk_score.hack (newtype, opaque outside that file).
// Use make_risk_score() to construct, and treat as num for comparisons.

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

// ── 1. parse_transactions ──
// Convert a vec of RawTransaction tuples into a vec of Transaction shapes.
function parse_transactions(
  vec<RawTransaction> $raw,
): vec<Transaction> {
  return Vec\map($raw, $tx ==> shape(
    'id' => $tx[0],
    'amount' => $tx[1],
    'channel' => $tx[2],
    'country' => $tx[3],
  ));
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
  $res = 10;
  if ($txn['amount'] >= 1000) $res += 30;
  if ($txn['amount'] >= 5000) $res += 50;
  switch ($txn['channel']) {
    case 'wire':
      $res += 25;
      break;
    case 'crypto':
      $res += 30;
      break;
    default:
      break;
  }
  if ($txn['country'] !== 'US') $res += 20;
  return make_risk_score($res);
}

// ── 3. score_all ──
// Given a vec of Transactions and a scoring function, return a dict
// mapping transaction ID => RiskScore.
// Use the pipe operator.
function score_all(
  vec<Transaction> $txns,
  (function(Transaction): RiskScore) $scorer,
): dict<string, RiskScore> {
  // first pass
  // $transformed = $txns 
  //   |> Vec\map($$, $txn ==> tuple($txn['id'], $scorer($txn)))
  //   |> Dict\from_entries($$);
  // return $transformed;

  // second pass, learned about \pull
  return Dict\pull($txns, $txn ==> $scorer($txn), $txn ==> $txn['id']);
}

// ── 4. filter_high_risk ──
// Given the scores dict and a threshold (int), return only the
// transactions whose score >= threshold.
// Return dict<string, RiskScore> with only the high-risk entries.
function filter_high_risk(
  dict<string, RiskScore> $scores, // assumed id: RiskScore
  int $threshold,
): dict<string, RiskScore> {
  return $scores
    |> Dict\filter($$, $score ==> $score >= $threshold);
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
  // Get vars
  $txns_with_score = $txns
    |> Vec\filter($$, $txn ==> C\contains_key($high_risk_scores, $txn['id']))
    |> Vec\map($$, $txn ==> tuple($txn, $high_risk_scores[$txn['id']]))
    |> Vec\sort_by($$, $txn_with_score ==> -$txn_with_score[1]);

  $format_row = (Transaction $txn, RiskScore $score): string ==> {
    $channel = Str\uppercase($txn['channel']);
    $id = $txn['id'];
    $amount = Str\format("%.2f", $txn['amount']);
    return "  [".$channel."] ".$id.": $".$amount." (score: ".$score.")";
  };

  $total_amount = $txns_with_score
    |> Vec\map($$, $txn_with_score ==> $txn_with_score[0]['amount'])
    |> Math\sum_float($$)
    |> Str\format("%.2f", $$);

  $avg_score = vec($high_risk_scores)
    |> Math\sum_float($$) // can take in a num type
    |> Math\int_div((int)$$, C\count($high_risk_scores));

  // Create result
  $lines = vec[
    "FRAUD ALERT REPORT",
    "---",
    "High risk (".C\count($high_risk_scores)."):"
  ];

  foreach ($txns_with_score as list($txn, $score)) {
    $lines[] = $format_row($txn, $score);
  }

  $lines[] = "---";
  $lines[] = "Total flagged amount: $".$total_amount."";
  $lines[] = "Avg risk score: ".$avg_score;

  return Str\join($lines, "\n")."\n";
}

// ── CLI Entry Point ──
// Runs the full pipeline on sample data and prints the report.
<<__EntryPoint>>
async function main(): Awaitable<void> {
  require_once(__DIR__.'/../../vendor/autoload.hack');
  \Facebook\AutoloadMap\initialize();

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
