use function Facebook\FBExpect\expect;
use type Facebook\HackTest\HackTest;
use namespace Unit5Ex2;

final class Ex02MiniProjectTest extends HackTest {

  // ── Sample data ──

  private static function sampleRaw(): vec<Unit5Ex2\RawTransaction> {
    return vec[
      tuple("TXN-001", 5000.0, "wire", "US"),
      tuple("TXN-002", 200.0, "card", "US"),
      tuple("TXN-003", 1500.0, "ach", "US"),
      tuple("TXN-004", 12000.0, "wire", "NG"),
      tuple("TXN-005", 800.0, "card", "US"),
      tuple("TXN-006", 8000.0, "crypto", "RU"),
    ];
  }

  private static function sampleTxns(): vec<Unit5Ex2\Transaction> {
    return vec[
      shape('id' => "TXN-001", 'amount' => 5000.0, 'channel' => "wire", 'country' => "US"),
      shape('id' => "TXN-002", 'amount' => 200.0, 'channel' => "card", 'country' => "US"),
      shape('id' => "TXN-003", 'amount' => 1500.0, 'channel' => "ach", 'country' => "US"),
      shape('id' => "TXN-004", 'amount' => 12000.0, 'channel' => "wire", 'country' => "NG"),
      shape('id' => "TXN-005", 'amount' => 800.0, 'channel' => "card", 'country' => "US"),
      shape('id' => "TXN-006", 'amount' => 8000.0, 'channel' => "crypto", 'country' => "RU"),
    ];
  }

  // ── 1. parse_transactions ──

  public function testParseTransactions(): void {
    $result = Unit5Ex2\parse_transactions(static::sampleRaw());
    expect(\HH\Lib\C\count($result))->toEqual(6);
    expect($result[0]['id'])->toEqual("TXN-001");
    expect($result[0]['amount'])->toEqual(5000.0);
    expect($result[0]['channel'])->toEqual("wire");
    expect($result[0]['country'])->toEqual("US");
    expect($result[3]['country'])->toEqual("NG");
  }

  public function testParseEmpty(): void {
    $result = Unit5Ex2\parse_transactions(vec[]);
    expect(\HH\Lib\C\count($result))->toEqual(0);
  }

  // ── 2. score_transaction ──

  public function testScoreLowRiskDomesticCard(): void {
    // 200, card, US → base 10 only
    $txn = shape('id' => "T", 'amount' => 200.0, 'channel' => "card", 'country' => "US");
    expect(Unit5Ex2\score_transaction($txn))->toEqual(10);
  }

  public function testScoreMidAmount(): void {
    // 1500, ach, US → 10 + 30(>=1000) = 40
    $txn = shape('id' => "T", 'amount' => 1500.0, 'channel' => "ach", 'country' => "US");
    expect(Unit5Ex2\score_transaction($txn))->toEqual(40);
  }

  public function testScoreHighWireDomestic(): void {
    // 5000, wire, US → 10 + 30(>=1000) + 50(>=5000) + 25(wire) = 115
    $txn = shape('id' => "T", 'amount' => 5000.0, 'channel' => "wire", 'country' => "US");
    expect(Unit5Ex2\score_transaction($txn))->toEqual(115);
  }

  public function testScoreHighWireForeign(): void {
    // 12000, wire, NG → 10 + 30(>=1000) + 50(>=5000) + 25(wire) + 20(non-US) = 135
    $txn = shape('id' => "T", 'amount' => 12000.0, 'channel' => "wire", 'country' => "NG");
    expect(Unit5Ex2\score_transaction($txn))->toEqual(135);
  }

  public function testScoreHighCryptoForeign(): void {
    // 8000, crypto, RU → 10 + 30(>=1000) + 50(>=5000) + 30(crypto) + 20(non-US) = 140
    $txn = shape('id' => "T", 'amount' => 8000.0, 'channel' => "crypto", 'country' => "RU");
    expect(Unit5Ex2\score_transaction($txn))->toEqual(140);
  }

  public function testScoreExactly1000(): void {
    // 1000, card, US → 10 + 30(>=1000) = 40
    $txn = shape('id' => "T", 'amount' => 1000.0, 'channel' => "card", 'country' => "US");
    expect(Unit5Ex2\score_transaction($txn))->toEqual(40);
  }

  // ── 3. score_all ──

  public function testScoreAll(): void {
    $txns = static::sampleTxns();
    $scores = Unit5Ex2\score_all($txns, Unit5Ex2\score_transaction<>);
    expect(\HH\Lib\C\count($scores))->toEqual(6);
    expect($scores["TXN-001"])->toEqual(115);
    expect($scores["TXN-002"])->toEqual(10);
    expect($scores["TXN-004"])->toEqual(135);
  }

  // ── 4. filter_high_risk ──

  public function testFilterHighRisk(): void {
    $scores = dict[
      "TXN-001" => Unit5Ex2\make_risk_score(115),
      "TXN-002" => Unit5Ex2\make_risk_score(10),
      "TXN-003" => Unit5Ex2\make_risk_score(40),
      "TXN-004" => Unit5Ex2\make_risk_score(135),
      "TXN-005" => Unit5Ex2\make_risk_score(10),
      "TXN-006" => Unit5Ex2\make_risk_score(140),
    ];
    $high = Unit5Ex2\filter_high_risk($scores, 80);
    expect(\HH\Lib\C\count($high))->toEqual(3);
    expect(\HH\Lib\C\contains_key($high, "TXN-001"))->toBeTrue();
    expect(\HH\Lib\C\contains_key($high, "TXN-004"))->toBeTrue();
    expect(\HH\Lib\C\contains_key($high, "TXN-006"))->toBeTrue();
  }

  public function testFilterNoneAboveThreshold(): void {
    $scores = dict[
      "A" => Unit5Ex2\make_risk_score(10),
      "B" => Unit5Ex2\make_risk_score(20),
    ];
    $high = Unit5Ex2\filter_high_risk($scores, 80);
    expect(\HH\Lib\C\count($high))->toEqual(0);
  }

  // ── 5. build_report ──

  public function testBuildReport(): void {
    $txns = static::sampleTxns();
    $high_risk = dict[
      "TXN-001" => Unit5Ex2\make_risk_score(115),
      "TXN-004" => Unit5Ex2\make_risk_score(135),
      "TXN-006" => Unit5Ex2\make_risk_score(140),
    ];
    $report = Unit5Ex2\build_report($txns, $high_risk);

    expect(\HH\Lib\Str\contains($report, "FRAUD ALERT REPORT"))->toBeTrue();
    expect(\HH\Lib\Str\contains($report, "High risk (3):"))->toBeTrue();
    expect(\HH\Lib\Str\contains($report, "[WIRE] TXN-001: \$5000.00 (score: 115)"))->toBeTrue();
    expect(\HH\Lib\Str\contains($report, "[WIRE] TXN-004: \$12000.00 (score: 135)"))->toBeTrue();
    expect(\HH\Lib\Str\contains($report, "[CRYPTO] TXN-006: \$8000.00 (score: 140)"))->toBeTrue();
    expect(\HH\Lib\Str\contains($report, "Total flagged amount: \$25000.00"))->toBeTrue();
    expect(\HH\Lib\Str\contains($report, "Avg risk score: 130"))->toBeTrue();
  }

  public function testBuildReportSortedByScoreDescending(): void {
    $txns = static::sampleTxns();
    $high_risk = dict[
      "TXN-001" => Unit5Ex2\make_risk_score(115),
      "TXN-004" => Unit5Ex2\make_risk_score(135),
      "TXN-006" => Unit5Ex2\make_risk_score(140),
    ];
    $report = Unit5Ex2\build_report($txns, $high_risk);

    // TXN-006 (140) should appear before TXN-004 (135) before TXN-001 (115)
    $pos_006 = \HH\Lib\Str\search($report, "TXN-006") as nonnull;
    $pos_004 = \HH\Lib\Str\search($report, "TXN-004") as nonnull;
    $pos_001 = \HH\Lib\Str\search($report, "TXN-001") as nonnull;
    expect($pos_006 < $pos_004)->toBeTrue();
    expect($pos_004 < $pos_001)->toBeTrue();
  }

  // ── End-to-end: full pipeline ──

  public function testFullPipeline(): void {
    $raw = static::sampleRaw();
    $txns = Unit5Ex2\parse_transactions($raw);
    $scores = Unit5Ex2\score_all($txns, Unit5Ex2\score_transaction<>);
    $high_risk = Unit5Ex2\filter_high_risk($scores, 80);
    $report = Unit5Ex2\build_report($txns, $high_risk);

    expect(\HH\Lib\Str\contains($report, "High risk (3):"))->toBeTrue();
    expect(\HH\Lib\Str\contains($report, "Avg risk score: 130"))->toBeTrue();
  }
}
