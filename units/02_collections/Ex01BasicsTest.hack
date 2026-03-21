use function Facebook\FBExpect\expect;
use type Facebook\HackTest\HackTest;
use namespace Unit2Ex1;

final class Ex01BasicsTest extends HackTest {

  public function testHighRiskScoresFiltersAboveThreshold(): void {
    $scores = vec[0.2, 0.85, 0.5, 0.95, 0.1];
    $result = Unit2Ex1\high_risk_scores($scores, 0.8);
    expect($result)->toBeSame(vec[0.85, 0.95]);
  }

  public function testHighRiskScoresEmptyWhenNoneAbove(): void {
    $result = Unit2Ex1\high_risk_scores(vec[0.1, 0.2], 0.9);
    expect($result)->toBeSame(vec[]);
  }

  public function testNewAccountsUnder30Days(): void {
    $accounts = dict[101 => 5, 202 => 90, 303 => 15, 404 => 365];
    $result = Unit2Ex1\new_accounts($accounts);
    expect($result)->toBeSame(keyset[101, 303]);
  }

  public function testTransactionSummary(): void {
    $amounts = vec[100.0, 250.0, 75.0, 500.0];
    $summary = Unit2Ex1\transaction_summary($amounts);
    expect($summary['count'])->toBeSame(4.0);
    expect($summary['total'])->toBeSame(925.0);
    expect($summary['max'])->toBeSame(500.0);
  }

  public function testMergeFlaggedCombinesAndDedupes(): void {
    $a = keyset[1, 2, 3];
    $b = keyset[2, 3, 4, 5];
    $result = Unit2Ex1\merge_flagged($a, $b);
    expect($result)->toBeSame(keyset[1, 2, 3, 4, 5]);
  }
}
