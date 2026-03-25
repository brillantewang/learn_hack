use function Facebook\FBExpect\expect;
use type Facebook\HackTest\HackTest;
use namespace Unit4Ex2;

final class Ex02PipesTest extends HackTest {

  // --- process_transaction_amounts ---

  public function testProcessTransactions(): void {
    $result = Unit4Ex2\process_transaction_amounts(vec[50.0, 200.0, 150.0]);
    expect($result)->toBeSame("\$220, \$165");
  }

  public function testProcessTransactionsAllFiltered(): void {
    $result = Unit4Ex2\process_transaction_amounts(vec[10.0, 20.0, 50.0]);
    expect($result)->toBeSame("");
  }

  public function testProcessTransactionsEmpty(): void {
    $result = Unit4Ex2\process_transaction_amounts(vec[]);
    expect($result)->toBeSame("");
  }

  public function testProcessTransactionsSingleAbove(): void {
    // 500.0 * 1.1 = 550.0
    $result = Unit4Ex2\process_transaction_amounts(vec[500.0]);
    expect($result)->toBeSame("\$550");
  }

  public function testProcessTransactionsAtBoundary(): void {
    // 100.0 is NOT > 100.0, so it should be filtered out
    $result = Unit4Ex2\process_transaction_amounts(vec[100.0]);
    expect($result)->toBeSame("");
  }

  // --- build_alert_summary ---

  public function testBuildAlertSummary(): void {
    $result = Unit4Ex2\build_alert_summary(vec[
      tuple("velocity_spike", 0.9),
      tuple("low_balance", 0.3),
      tuple("geo_anomaly", 0.7),
      tuple("device_mismatch", 0.6),
      tuple("normal_login", 0.1),
    ]);
    expect($result)->toBeSame(
      "velocity_spike: 0.9 | geo_anomaly: 0.7 | device_mismatch: 0.6",
    );
  }

  public function testBuildAlertSummaryFewerThanThree(): void {
    $result = Unit4Ex2\build_alert_summary(vec[
      tuple("single_alert", 0.8),
    ]);
    expect($result)->toBeSame("single_alert: 0.8");
  }

  public function testBuildAlertSummaryEmpty(): void {
    $result = Unit4Ex2\build_alert_summary(vec[]);
    expect($result)->toBeSame("");
  }

  public function testBuildAlertSummaryAllBelowThreshold(): void {
    $result = Unit4Ex2\build_alert_summary(vec[
      tuple("low1", 0.2),
      tuple("low2", 0.1),
    ]);
    expect($result)->toBeSame("");
  }

  public function testBuildAlertSummaryTruncatesToThree(): void {
    $result = Unit4Ex2\build_alert_summary(vec[
      tuple("a", 0.9),
      tuple("b", 0.8),
      tuple("c", 0.7),
      tuple("d", 0.6),
    ]);
    // Should only include top 3 by severity desc
    expect($result)->toBeSame("a: 0.9 | b: 0.8 | c: 0.7");
  }
}
