// Exercise 2: Type Refinement
//
// Practice using is, as, ?as, and invariant() for type-safe code.
// Run with: hhvm ex02_refinement.hack
// Run tests: vendor/bin/hacktest units/03_control_flow/Ex02RefinementTest.hack

namespace Unit3Ex2;

use namespace HH\Lib\{C, Vec, Dict, Str, Math};

// 1. Takes a mixed value and returns a description string.
//    - If it's an int, return "int:<value>"
//    - If it's a string, return "string:<value>"
//    - If it's a float, return "float:<value>"
//    - If it's a bool, return "bool:true" or "bool:false"
//    - Otherwise, return "unknown"
//    Expected: describe(42) => "int:42", describe("hi") => "string:hi"
function describe(mixed $val): string {
  if ($val is int) return "int:".($val);
  if ($val is string) return "string:".($val);
  if ($val is float) return "float:".($val);
  if ($val is bool) return "bool:".($val ? "true" : "false");
  return "unknown";
}

// 2. Takes a dict<string, mixed> representing a detection signal.
//    Extract 'score' (must be a float) and 'source' (must be a string).
//    Return "<source>: <score>".
//    Use `as` to assert the types — it's a bug if they're wrong.
//    Expected: format_signal(dict['score' => 0.85, 'source' => 'ml']) => "ml: 0.85"
function format_signal(dict<string, mixed> $signal): string {
  $source = idx($signal, 'source') as string;
  $score = idx($signal, 'score') as float;
  return ($source).": ".($score);
}

// 3. Takes a vec<mixed> and returns the sum of all values that are numeric
//    (int or float). Skip anything that isn't a number.
//    Use ?as for safe type checking.
//    Expected: sum_numeric(vec[1, "hello", 3.5, true, 2]) => 6.5
function sum_numeric(vec<mixed> $values): float {
  $res = 0.0;
  foreach ($values as $value) {
    $amount = $value ?as num;
    if ($amount is nonnull) {
      $res = $res + $amount;
    }
  }
  return $res;
}

// 4. Takes a dict<string, mixed> representing a user record.
//    Must have 'name' (string) and 'age' (int).
//    Use invariant() to assert both exist and are the right type.
//    Return "Name: <name>, Age: <age>".
//    Expected: validate_user(dict['name' => 'Alice', 'age' => 30]) => "Name: Alice, Age: 30"
function validate_user(dict<string, mixed> $user): string {
  $name = idx($user, 'name');
  $age = idx($user, 'age');
  invariant($name is string, 'name doesnt exist or is wrong type: %d', $name);
  invariant($age is int, 'age doesnt exist or is wrong type: %d', $age);
  return "Name: ".($name).", Age: ".($age);
}

<<__EntryPoint>>
async function main(): Awaitable<void> {
  // Test 1
  echo describe(42)."\n";        // int:42
  echo describe("hello")."\n";   // string:hello
  echo describe(3.14)."\n";      // float:3.14
  echo describe(true)."\n";      // bool:true
  echo describe(null)."\n";      // unknown

  echo "\n";

  // Test 2
  $signal = dict['score' => 0.85, 'source' => 'ml'];
  echo format_signal($signal)."\n";  // ml: 0.85

  echo "\n";

  // Test 3
  echo sum_numeric(vec[1, "hello", 3.5, true, 2])."\n";  // 6.5

  echo "\n";

  // Test 4
  $user = dict['name' => 'Alice', 'age' => 30];
  echo validate_user($user)."\n";  // Name: Alice, Age: 30
}
