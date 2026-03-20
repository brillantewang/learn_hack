// Exercise 2: Typed Functions
//
// Implement the three functions below. Each one should pass the typechecker.
// Run with: hhvm ex02_types.hack

namespace Unit1Ex2;

// 1. Takes a transaction amount (float) and a threshold (float).
//    Returns true if the amount exceeds the threshold.
function is_suspicious(float $amount, float $threshold): bool {
  return $amount > $threshold;
}

// 2. Takes a user ID (int) and a reason (string).
//    Returns a formatted alert string like: "ALERT: User 12345 flagged for suspicious_login"
function format_alert(int $user_id, string $reason): string {
  return "ALERT: User ".$user_id." flagged for ".$reason;
}

// 3. Takes a risk score (float) and returns a label:
//    - score >= 0.8 → "high"
//    - score >= 0.5 → "medium"
//    - otherwise    → "low"
function risk_label(float $risk_score): string {
  if ($risk_score >= 0.8) return "high";
  if ($risk_score >= 0.5) return "medium";
  return "low";
}

<<__EntryPoint>>
async function main(): Awaitable<void> {
  // Test your functions:
  echo is_suspicious(9999.99, 5000.0) ? "suspicious\n" : "clean\n";
  echo format_alert(12345, "suspicious_login")."\n";
  echo risk_label(0.92)."\n";
  echo risk_label(0.65)."\n";
  echo risk_label(0.15)."\n";
}
