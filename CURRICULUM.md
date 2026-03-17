# Hack Language Curriculum

**Learner:** Infra engineer joining Meta (fraud & financial team), background in Python & TypeScript
**Timeline:** 4 weeks, ~1 hour/day (~20 sessions)
**Goal:** Proficiency in Hack for daily backend/infra work (LLM integration, legacy migration, systems code)

---

## Approach

Each unit follows: **concept → exercise → code-reading → check-for-understanding**.
Each week ends with a mini-project that synthesizes that week's concepts.
Exercises are written in `.hack` files within each unit folder.

---

## Week 1: Foundations (Sessions 1–5)

### Unit 01 — Hello Hack & Type System Basics
- Hack vs PHP: what changed and why (strict mode, type safety)
- `<<__EntryPoint>>`, file structure, running Hack programs
- Primitive types: `int`, `string`, `float`, `bool`, `num`, `arraykey`, `mixed`, `nonnull`, `nothing`, `void`, `noreturn`
- Tuples
- Type annotations on functions, parameters, return types
- **Exercises:** Write typed functions, predict type errors

### Unit 02 — Collections
- `vec<T>`, `dict<Tk, Tv>`, `keyset<T>`
- Why Hack ditched PHP arrays
- HSL namespaces: `C\`, `Vec\`, `Dict\`, `Keyset\`, `Str\`, `Math\`
- **Exercises:** Data transformation pipelines with collections

### Unit 03 — Control Flow & Type Refinement
- `if`/`else`, `switch`, ternary
- `is` / `as` / `?as` type assertions
- Type refinement through control flow
- Loops: `for`, `foreach`, `while`
- **Exercises:** Type-narrowing puzzles, collection processing

### Unit 04 — Functions, Closures & Type Aliases
- Named functions, default params, variadic params
- Anonymous functions / lambdas (`==>` syntax)
- Pipe operator `|>`
- `type` and `newtype` aliases
- **Exercises:** Higher-order functions, data pipelines with `|>`

### Unit 05 — Week 1 Assessment
- Code-reading quiz (predict output of 5 snippets)
- Mini-project: CLI data processor using collections, types, functions, and pipes

---

## Week 2: Type System & OOP (Sessions 6–10)

### Unit 06 — Enums, Enum Classes & Shapes
- Enums (backed by `string` / `int`)
- Enum classes & enum class labels
- Shapes: typed dictionaries
- When to use shapes vs classes
- **Exercises:** Model scam-detection signal data with shapes and enums

### Unit 07 — Classes & Interfaces
- Classes, constructors (`__construct`), properties
- Constructor parameter promotion
- Visibility: `public`, `protected`, `private`
- Interfaces, `implements`
- `this` type, `classname<T>`
- **Exercises:** Design a class hierarchy for a detection pipeline

### Unit 08 — Traits & Generics
- Traits: what they are, when to use them
- Generics: `<T>`, constraints (`as`, `super`)
- Reified generics (`<reify T>`) — runtime type info, Hack-unique
- Generic classes, functions, interfaces
- **Exercises:** Build a generic result wrapper, use reified generics

### Unit 09 — Nullability & Readonly
- `?Type` (nullable)
- Null-safe operators: `?->`, `??`
- `invariant()` for assertions
- `readonly` keyword: immutable references
- Readonly subtyping, containers, advanced semantics
- **Exercises:** Refactor unsafe code to be null-safe; apply readonly

### Unit 10 — Week 2 Assessment
- Code-reading quiz
- Mini-project: Type-safe data model for a fraud signal pipeline

---

## Week 3: Async, Contexts & Advanced Features (Sessions 11–15)

### Unit 11 — Async & Await
- `async` / `await` in Hack vs TypeScript (cooperative multitasking, NOT threads)
- `Awaitable<T>`
- Concurrent execution: `concurrent { }` blocks
- Async utility functions, `Vec\map_async`
- Async generators (overview)
- **Exercises:** Convert sequential code to async; concurrent data fetching

### Unit 12 — Error Handling
- Exceptions: `try` / `catch` / `finally`
- `invariant()`, `invariant_violation()`
- Best practices: when to throw vs return errors
- **Exercises:** Add error handling to prior mini-projects

### Unit 13 — Attributes & Memoization
- What attributes are (metadata on definitions)
- Key predefined attributes: `__EntryPoint`, `__Override`, `__Memoize`, `__Sealed`, `__ConsistentConstruct`, `__LateInit`
- Custom attributes
- `__Memoize` deep dive (ubiquitous at Meta)
- **Exercises:** Apply attributes to existing code; memoize expensive operations

### Unit 14 — Contexts & Capabilities
- What contexts/capabilities are (permission system for functions)
- `[defaults]`, `[write_props]`, `[leak_safe]`
- Context on closures, higher-order functions
- Context constants, dependent contexts
- Why this matters for large codebases (safety at scale)
- **Exercises:** Annotate functions with contexts; predict context errors

### Unit 15 — Week 3 Assessment
- Code-reading quiz
- Mini-project: Async fraud-signal fetcher with error handling, memoization, and contexts

---

## Week 4: Practical Mastery (Sessions 16–20)

### Unit 16 — Modules, Namespaces & Code Organization
- `namespace` and `use`
- Modules and packages (newer features, awareness level)
- File structure conventions at scale
- **Exercises:** Refactor flat code into namespaced modules

### Unit 17 — Testing in Hack
- HackTest framework
- Writing test cases, data providers
- Mocking basics
- **Exercises:** Write tests for prior mini-projects

### Unit 18 — Common Patterns, Idioms & Code Reading
- Builder pattern, factory pattern in Hack
- Reading real-world Hack code (3 progressively complex examples)
- Identify patterns, anti-patterns, types
- Meta coding conventions
- **Exercises:** Annotate and explain code; suggest improvements

### Unit 19 — Capstone Project (Part 1)
- Build a complete Hack application from scratch
- Theme: simplified scam-detection pipeline
- Combines: types, classes, generics, async, error handling, attributes, contexts

### Unit 20 — Capstone Project (Part 2) & Review
- Finish and polish capstone
- Write tests for capstone
- Review weak areas
- Quick-reference cheat sheet for day 1 at Meta

---

## Reference
- Official docs: https://docs.hhvm.com/hack/
- HSL (Hack Standard Library): https://docs.hhvm.com/hsl/reference/
