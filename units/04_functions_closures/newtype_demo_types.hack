// This file DEFINES the newtype — only this file can treat UserId as int.
namespace NewtypeDemo;

// Without constraint — outside files know NOTHING about the underlying type:
newtype UserId = int;

// With constraint — uncomment this instead to let outside files treat UserId
// as arraykey (dict/keyset key, string concat), and watch the corresponding
// squigglies go away in newtype_demo_outside.hack:
// newtype UserId as arraykey = int;

// Constructor — the only way for outside files to create a UserId
function make_user_id(int $raw): UserId {
  invariant($raw > 0, "User ID must be positive, got %d", $raw);
  return $raw;  // OK — this file knows UserId = int
}

// This is only needed when there's NO `as arraykey` constraint, because outside
// files can't do string concat without it.
function user_id_to_string(UserId $id): string {
  return "user_".$id;  // OK — this file can treat $id as int
}
