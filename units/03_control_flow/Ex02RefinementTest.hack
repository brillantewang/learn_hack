use function Facebook\FBExpect\expect;
use type Facebook\HackTest\HackTest;
use namespace Unit3Ex2;

final class Ex02RefinementTest extends HackTest {

  public function testDescribeInt(): void {
    expect(Unit3Ex2\describe(42))->toBeSame("int:42");
  }

  public function testDescribeString(): void {
    expect(Unit3Ex2\describe("hello"))->toBeSame("string:hello");
  }

  public function testDescribeFloat(): void {
    expect(Unit3Ex2\describe(3.14))->toBeSame("float:3.14");
  }

  public function testDescribeBoolTrue(): void {
    expect(Unit3Ex2\describe(true))->toBeSame("bool:true");
  }

  public function testDescribeBoolFalse(): void {
    expect(Unit3Ex2\describe(false))->toBeSame("bool:false");
  }

  public function testDescribeUnknown(): void {
    expect(Unit3Ex2\describe(null))->toBeSame("unknown");
  }

  public function testFormatSignal(): void {
    $signal = dict['score' => 0.85, 'source' => 'ml'];
    expect(Unit3Ex2\format_signal($signal))->toBeSame("ml: 0.85");
  }

  public function testSumNumeric(): void {
    expect(Unit3Ex2\sum_numeric(vec[1, "hello", 3.5, true, 2]))->toBeSame(6.5);
  }

  public function testSumNumericAllStrings(): void {
    expect(Unit3Ex2\sum_numeric(vec["a", "b", "c"]))->toBeSame(0.0);
  }

  public function testValidateUser(): void {
    $user = dict['name' => 'Alice', 'age' => 30];
    expect(Unit3Ex2\validate_user($user))->toBeSame("Name: Alice, Age: 30");
  }

  public function testFormatSignalBadScore(): void {
    expect(() ==> Unit3Ex2\format_signal(dict['score' => 'not_a_float', 'source' => 'ml']))
      ->toThrow(\TypeAssertionException::class);
  }

  public function testFormatSignalMissingKey(): void {
    expect(() ==> Unit3Ex2\format_signal(dict['source' => 'ml']))
      ->toThrow(\TypeAssertionException::class);
  }

  public function testValidateUserMissingName(): void {
    expect(() ==> Unit3Ex2\validate_user(dict['age' => 30]))
      ->toThrow(\HH\InvariantException::class);
  }

  public function testValidateUserWrongType(): void {
    expect(() ==> Unit3Ex2\validate_user(dict['name' => 123, 'age' => 30]))
      ->toThrow(\HH\InvariantException::class);
  }
}
