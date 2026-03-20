// Exercise 3: Spot the Type Errors (Code Reading)
//
// DON'T RUN THIS FILE. Read each function and predict:
//   - Will the typechecker accept it? (yes/no)
//   - If no, what's the error and how would you fix it?

namespace Unit1Ex3;

// --- A ---
function transaction_total(int $quantity, float $price): float {
  return $quantity * $price;
}

// --- B ---
function flag_account(int $account_id): string {
  if ($account_id > 0) {
    return "flagged: ".$account_id;
  }
}

// --- C ---
function merge_ids(int $id1, string $id2): arraykey {
  if ($id1 > 100) {
    return $id1;
  }
  return $id2;
}

// --- D ---
function describe_risk(mixed $score): string {
  return "Risk level: ".$score;
}

// --- E ---
function get_verdict(): (string, float) {
  return tuple("fraud", 0.97, "high");
}
