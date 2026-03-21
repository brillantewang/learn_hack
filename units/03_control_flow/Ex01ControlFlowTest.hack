use function Facebook\FBExpect\expect;
use type Facebook\HackTest\HackTest;
use namespace Unit3Ex1;

final class Ex01ControlFlowTest extends HackTest {

  public function testRiskLabelCritical(): void {
    expect(Unit3Ex1\risk_label(0.85))->toBeSame("critical");
  }

  public function testRiskLabelHigh(): void {
    expect(Unit3Ex1\risk_label(0.6))->toBeSame("high");
  }

  public function testRiskLabelMedium(): void {
    expect(Unit3Ex1\risk_label(0.3))->toBeSame("medium");
  }

  public function testRiskLabelLow(): void {
    expect(Unit3Ex1\risk_label(0.1))->toBeSame("low");
  }

  public function testSignalPriorityKnown(): void {
    expect(Unit3Ex1\signal_priority("fraud"))->toBeSame(1);
    expect(Unit3Ex1\signal_priority("abuse"))->toBeSame(2);
    expect(Unit3Ex1\signal_priority("spam"))->toBeSame(3);
  }

  public function testSignalPriorityUnknown(): void {
    expect(Unit3Ex1\signal_priority("other"))->toBeSame(99);
  }

  public function testSummarizePositive(): void {
    $result = Unit3Ex1\summarize_positive(vec[100.0, -50.0, 200.0, -10.0]);
    expect($result['count'])->toBeSame(2.0);
    expect($result['total'])->toBeSame(300.0);
  }

  public function testSummarizePositiveAllNegative(): void {
    $result = Unit3Ex1\summarize_positive(vec[-10.0, -20.0]);
    expect($result['count'])->toBeSame(0.0);
    expect($result['total'])->toBeSame(0.0);
  }

  public function testCleanIds(): void {
    $result = Unit3Ex1\clean_ids(vec["abc", null, "def", null, "ghi"]);
    expect($result)->toBeSame(vec["ABC", "DEF", "GHI"]);
  }

  public function testCleanIdsAllNull(): void {
    $result = Unit3Ex1\clean_ids(vec[null, null]);
    expect($result)->toBeSame(vec[]);
  }
}
