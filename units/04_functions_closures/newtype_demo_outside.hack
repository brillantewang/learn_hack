// This file is OUTSIDE — it cannot treat UserId as int.
namespace NewtypeDemoOutside;

use type NewtypeDemo\UserId;
use function NewtypeDemo\{make_user_id, user_id_to_string};

<<__EntryPoint>>
async function main(): Awaitable<void> {
  require_once(__DIR__.'/../../vendor/autoload.hack');
  \Facebook\AutoloadMap\initialize();

  // Must create through the constructor — can't use raw ints
  $alice_id = make_user_id(101);
  $bob_id = make_user_id(202);

  // --- Always works (with or without constraint) ---
  echo user_id_to_string($alice_id)."\n";    // "user_101" Note: This is not needed with `as arraykey`, since outside files can freely concat with `arraykey`.
  $match = ($alice_id === $bob_id);           // === always works on same type

  // --- Only works with `as arraykey` constraint ---
  // If the defining file uses `newtype UserId as arraykey = int`, outside files can do these directly:
  $names = dict[$alice_id => "Alice"];   // can use as dict key
  $team = keyset[$alice_id];             // can use in keyset
  echo "user_".$alice_id;               // can concat as arraykey, making user_id_to_string unnecessary

  // --- Never works (with or without constraint) ---
  // Outside files can never treat UserId as int:
  $alice_id + 1;              // ERROR — can't do math
  $alice_id * 2;              // ERROR
  make_user_id($alice_id);    // ERROR — UserId is not int
}
