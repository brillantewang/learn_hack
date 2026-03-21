use function Facebook\FBExpect\expect;
use type Facebook\HackTest\HackTest;
use namespace Unit2Ex2;

final class Ex02HslTest extends HackTest {

  public function testHighRiskAlerts(): void {
    $scores = dict[101 => 0.85, 202 => 0.3, 303 => 0.92, 404 => 0.1];
    $result = Unit2Ex2\high_risk_alerts($scores);
    expect($result)->toBeSame(vec["User 101: 0.85", "User 303: 0.92"]);
  }

  public function testHighRiskAlertsNoneAboveThreshold(): void {
    $scores = dict[101 => 0.1, 202 => 0.3];
    $result = Unit2Ex2\high_risk_alerts($scores);
    expect($result)->toBeSame(vec[]);
  }

  public function testTotalWireAmount(): void {
    $txns = vec["WIRE 500", "POS 20", "WIRE 1000", "ATM 50", "WIRE 200"];
    $result = Unit2Ex2\total_wire_amount($txns);
    expect($result)->toBeSame(1700.0);
  }

  public function testTotalWireAmountNoWires(): void {
    $txns = vec["POS 20", "ATM 50"];
    $result = Unit2Ex2\total_wire_amount($txns);
    expect($result)->toBeSame(0.0);
  }

  public function testGroupBySource(): void {
    $signals = vec[
      dict['source' => 'ml', 'id' => '101'],
      dict['source' => 'rules', 'id' => '202'],
      dict['source' => 'ml', 'id' => '303'],
      dict['source' => 'rules', 'id' => '404'],
    ];
    $result = Unit2Ex2\group_by_source($signals);
    expect($result)->toBeSame(dict[
      'ml' => vec['101', '303'],
      'rules' => vec['202', '404'],
    ]);
  }
}
