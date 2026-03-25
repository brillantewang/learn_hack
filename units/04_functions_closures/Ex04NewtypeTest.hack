use function Facebook\FBExpect\expect;
use type Facebook\HackTest\HackTest;
use namespace Unit4Ex4;
use namespace Unit4Ex4Usage;

final class Ex04NewtypeTest extends HackTest {

  // --- make_transaction_id ---

  public function testMakeTransactionIdValid(): void {
    $id = Unit4Ex4\make_transaction_id("TXN-001");
    expect($id)->toNotBeNull();
    expect(Unit4Ex4\transaction_id_to_string($id as nonnull))->toBeSame("TXN-001");
  }

  public function testMakeTransactionIdInvalidPrefix(): void {
    expect(Unit4Ex4\make_transaction_id("BAD-123"))->toBeNull();
  }

  public function testMakeTransactionIdEmpty(): void {
    expect(Unit4Ex4\make_transaction_id(""))->toBeNull();
  }

  // --- transaction_id_to_string ---

  public function testTransactionIdToString(): void {
    $id = Unit4Ex4\make_transaction_id("TXN-999") as nonnull;
    expect(Unit4Ex4\transaction_id_to_string($id))->toBeSame("TXN-999");
  }

  // --- make_risk_level ---

  public function testMakeRiskLevelNormal(): void {
    $r = Unit4Ex4\make_risk_level(50);
    // as num constraint lets us compare
    expect($r > 40)->toBeTrue();
    expect($r < 60)->toBeTrue();
  }

  public function testMakeRiskLevelClampedAbove(): void {
    $r = Unit4Ex4\make_risk_level(150);
    expect($r <= 100)->toBeTrue();
  }

  public function testMakeRiskLevelClampedBelow(): void {
    $r = Unit4Ex4\make_risk_level(-10);
    expect($r >= 0)->toBeTrue();
  }

  // --- combine_risk_levels ---

  public function testCombineRiskLevels(): void {
    $a = Unit4Ex4\make_risk_level(60);
    $b = Unit4Ex4\make_risk_level(80);
    $combined = Unit4Ex4\combine_risk_levels($a, $b);
    // (60 + 80) / 2 = 70
    expect($combined > 69)->toBeTrue();
    expect($combined < 71)->toBeTrue();
  }

  // --- format_transaction (outside file) ---

  public function testFormatTransaction(): void {
    $id = Unit4Ex4\make_transaction_id("TXN-ABC") as nonnull;
    expect(Unit4Ex4Usage\format_transaction($id))->toBeSame("Transaction: TXN-ABC");
  }

  // --- is_high_risk (outside file) ---

  public function testIsHighRiskTrue(): void {
    $r = Unit4Ex4\make_risk_level(75);
    expect(Unit4Ex4Usage\is_high_risk($r))->toBeTrue();
  }

  public function testIsHighRiskFalse(): void {
    $r = Unit4Ex4\make_risk_level(50);
    expect(Unit4Ex4Usage\is_high_risk($r))->toBeFalse();
  }

  public function testIsHighRiskBoundary(): void {
    $r = Unit4Ex4\make_risk_level(70);
    expect(Unit4Ex4Usage\is_high_risk($r))->toBeFalse(); // strictly > 70
  }

  // --- highest_risk (outside file) ---

  public function testHighestRisk(): void {
    $levels = vec[
      Unit4Ex4\make_risk_level(30),
      Unit4Ex4\make_risk_level(90),
      Unit4Ex4\make_risk_level(60),
    ];
    $highest = Unit4Ex4Usage\highest_risk($levels);
    expect($highest)->toNotBeNull();
    expect($highest as nonnull > 89)->toBeTrue();
  }

  public function testHighestRiskEmpty(): void {
    expect(Unit4Ex4Usage\highest_risk(vec[]))->toBeNull();
  }
}
