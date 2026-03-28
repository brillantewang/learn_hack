// RiskScore — opaque type for fraud risk scoring.
//
// This is the defining file. Only this file can construct RiskScores.
// Outside files can compare them (as num) but not create them directly.

namespace Unit5Ex2;

// Outside code can treat as num (for comparisons, sorting, display)
// but cannot construct directly — must use make_risk_score().
newtype RiskScore as num = int;

function make_risk_score(int $score): RiskScore {
  return $score;
}
