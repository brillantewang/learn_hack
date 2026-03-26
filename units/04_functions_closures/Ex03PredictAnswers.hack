// Exercise 3: Answers — DO NOT PEEK until you've filled in ex03_predict.hack
//
// Each snippet tests a specific concept from the Unit 04 lesson.

namespace Unit4Ex3Answers;

// --- Snippet 1: Capture by value ---
// Hack lambdas capture variables by value at creation time.
// $multiplier was 2 when the lambda was created, so the later
// reassignment to 100 has no effect.
//
// Answer: 20

// --- Snippet 2: Pipe operator chaining ---
// First pipeline: filter >100 gives vec[200.0, 150.0], count = 2.
// $category = 2 > 1 ? "high" : "low" => "high"
// Second pipeline: filter >100 => vec[200.0, 150.0]
//   map *1.1 => vec[220.0, 165.0]
//   map "$".(string) => vec["$220", "$165"]
//   join => "$220, $165"
//
// Answer: high => $220, $165

// --- Snippet 3: Function references ---
// add_five<> passes the function by reference (not calling it).
// apply_twice calls f(f(15)) => add_five(add_five(15)) => add_five(20) => 25
//
// Answer: 25

// --- Snippet 4: Type alias + function type + pipe ---
// make_handler("ALERT") returns a lambda: $msg ==> "ALERT: ".$msg
// Pipeline: filter for "spike" => vec["velocity_spike"]
//   map with $handler => vec["ALERT: velocity_spike"]
//   join => "ALERT: velocity_spike"
//
// Answer: ALERT: velocity_spike
