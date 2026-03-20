// Exercise 1: Hello Hack
//
// TODO: Write an entry point function that prints:
//   "Fraud detector v1.0 online"
//
// Requirements:
// - Use the <<__EntryPoint>> attribute
// - Use the async main convention
// - Run with: hhvm ex01_hello.hack

namespace Unit1Ex1;

<<__EntryPoint>>
async function main(): Awaitable<void> {
    echo "Fraud detector v1.0 online\n";
}
