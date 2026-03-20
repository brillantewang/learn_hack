use function Facebook\FBExpect\expect;
use type Facebook\HackTest\HackTest;

final class ExampleTest extends HackTest {
  public function testAddition(): void {
    expect(1 + 1)->toBeSame(2);
  }
}
