use function Facebook\FBExpect\expect;
use type Facebook\HackTest\HackTest;
use namespace Unit4Ex1;

final class Ex01FunctionsTest extends HackTest {

  // --- calculate_risk_score ---

  public function testRiskScoreDefaultParams(): void {
    // Uses default weight=1.0, bias=0.0
    expect(Unit4Ex1\calculate_risk_score(0.75))->toAlmostEqual(0.75);
  }

  public function testRiskScoreWithOverrides(): void {
    expect(Unit4Ex1\calculate_risk_score(0.5, 1.8, 0.0))->toAlmostEqual(0.9);
  }

  public function testRiskScoreClampedAbove(): void {
    // 0.5 * 3.0 + 0.0 = 1.5, clamped to 1.0
    expect(Unit4Ex1\calculate_risk_score(0.5, 3.0, 0.0))->toAlmostEqual(1.0);
  }

  public function testRiskScoreClampedBelow(): void {
    // 0.5 * 1.0 + (-0.8) = -0.3, clamped to 0.0
    expect(Unit4Ex1\calculate_risk_score(0.5, 1.0, -0.8))->toAlmostEqual(0.0);
  }

  public function testRiskScoreWithBias(): void {
    // 0.4 * 1.0 + 0.2 = 0.6
    expect(Unit4Ex1\calculate_risk_score(0.4, 1.0, 0.2))->toAlmostEqual(0.6);
  }

  // --- sum_amounts ---

  public function testSumAmountsMultiple(): void {
    expect(Unit4Ex1\sum_amounts(100.0, 200.0, 300.0))->toAlmostEqual(600.0);
  }

  public function testSumAmountsZeroArgs(): void {
    expect(Unit4Ex1\sum_amounts())->toAlmostEqual(0.0);
  }

  public function testSumAmountsSingleValue(): void {
    expect(Unit4Ex1\sum_amounts(42.5))->toAlmostEqual(42.5);
  }

  public function testSumAmountsWithZeros(): void {
    expect(Unit4Ex1\sum_amounts(0.0, 0.0, 0.0))->toAlmostEqual(0.0);
  }

  // --- combine_risk_scores (spread operator) ---

  public function testCombineRiskScoresBasic(): void {
    // (0.8 + 0.6 + 0.4) / 3 = 0.6
    expect(Unit4Ex1\combine_risk_scores(0.8, vec[0.6, 0.4]))->toAlmostEqual(0.6);
  }

  public function testCombineRiskScoresEmptyAdjustments(): void {
    // 0.5 / 1 = 0.5
    expect(Unit4Ex1\combine_risk_scores(0.5, vec[]))->toAlmostEqual(0.5);
  }

  public function testCombineRiskScoresSingleAdjustment(): void {
    // (1.0 + 0.0) / 2 = 0.5
    expect(Unit4Ex1\combine_risk_scores(1.0, vec[0.0]))->toAlmostEqual(0.5);
  }

  // --- apply_detector ---

  public function testApplyDetectorThreshold(): void {
    $result = Unit4Ex1\apply_detector(
      vec[0.3, 0.8, 0.9, 0.1],
      $s ==> $s > 0.5,
    );
    expect($result)->toBeSame(vec[0.8, 0.9]);
  }

  public function testApplyDetectorNoneMatch(): void {
    $result = Unit4Ex1\apply_detector(
      vec[0.1, 0.2, 0.3],
      $s ==> $s > 0.9,
    );
    expect($result)->toBeSame(vec[]);
  }

  public function testApplyDetectorAllMatch(): void {
    $result = Unit4Ex1\apply_detector(
      vec[0.8, 0.9],
      $s ==> $s > 0.5,
    );
    expect($result)->toBeSame(vec[0.8, 0.9]);
  }

  public function testApplyDetectorEmptyInput(): void {
    $result = Unit4Ex1\apply_detector(vec[], $s ==> $s > 0.5);
    expect($result)->toBeSame(vec[]);
  }

  // --- make_threshold_checker ---

  public function testThresholdCheckerAbove(): void {
    $checker = Unit4Ex1\make_threshold_checker(0.7);
    expect($checker(0.8))->toBeTrue();
  }

  public function testThresholdCheckerBelow(): void {
    $checker = Unit4Ex1\make_threshold_checker(0.7);
    expect($checker(0.6))->toBeFalse();
  }

  public function testThresholdCheckerEqual(): void {
    // Strictly greater than, so equal should be false
    $checker = Unit4Ex1\make_threshold_checker(0.7);
    expect($checker(0.7))->toBeFalse();
  }

  public function testThresholdCheckerDifferentThresholds(): void {
    $low = Unit4Ex1\make_threshold_checker(0.3);
    $high = Unit4Ex1\make_threshold_checker(0.9);
    expect($low(0.5))->toBeTrue();
    expect($high(0.5))->toBeFalse();
  }
}
