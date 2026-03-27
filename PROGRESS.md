# Progress Tracker

This file is the source of truth for where we are in the curriculum.
Claude reads this at the start of every new conversation to resume seamlessly.

## Current State

- **Current Unit:** 05
- **Current Lesson Status:** in progress — ex01 predict done (5/5), ex02 mini-project created, ready to implement
- **Last Completed Unit:** 04
- **Date Last Active:** 2026-03-27 (session 12)

## Unit Completion Log

| Unit | Topic | Status | Date Completed | Notes |
|------|-------|--------|----------------|-------|
| 01 | Hello Hack & Type System Basics | complete | 2026-03-19 | Strong grasp, no weak areas |
| 02 | Collections | complete | 2026-03-20 | Strong grasp. Missed div-by-zero edge case in code reading (empty collection guard). |
| 03 | Control Flow & Type Refinement | complete | 2026-03-24 | Strong grasp. 5/5 code reading. Good use of ?as num, invariant() refinement. |
| 04 | Functions, Closures & Type Aliases | complete | 2026-03-26 | Comprehension 5/5, ex01 20/20, ex02 10/10, ex03 4/4, ex04 14/14 |
| 05 | Week 1 Assessment | in progress | | ex01 predict 5/5, ex02 mini-project ready to implement |
| 06 | Enums, Enum Classes & Shapes | not started | | |
| 07 | Classes & Interfaces | not started | | |
| 08 | Traits & Generics | not started | | |
| 09 | Nullability & Readonly | not started | | |
| 10 | Week 2 Assessment | not started | | |
| 11 | Async & Await | not started | | |
| 12 | Error Handling | not started | | |
| 13 | Attributes & Memoization | not started | | |
| 14 | Contexts & Capabilities | not started | | |
| 15 | Week 3 Assessment | not started | | |
| 16 | Modules, Namespaces & Code Organization | not started | | |
| 17 | Testing in Hack | not started | | |
| 18 | Common Patterns, Idioms & Code Reading | not started | | |
| 19 | Capstone Project (Part 1) | not started | | |
| 20 | Capstone Project (Part 2) & Review | not started | | |

## Weak Areas / Topics to Revisit

(none yet)

## Session Notes

### Session 1 — 2026-03-17
- Set up curriculum, CLAUDE.md, PROGRESS.md, .gitignore
- Installed Claude Code in devcontainer, set up memory persistence via symlink

### Session 2 — 2026-03-17
- Switched memory persistence from symlink to bind mount (~/.claude from host)
- Investigated ~/.claude.json — confirmed it's just client-side UI state, not needed in container
- Confirmed OAuth tokens live in macOS Keychain, not in .claude.json
- Fixed stop/notification hooks (afplay/osascript) failing in Linux container — wrapped with OS detection + `|| true`
- Learned about SSH known_hosts in container context (agent-forwarded, not mounted)
- Started Unit 01 lesson.md (not yet committed)

### Session 3 — 2026-03-18 to 2026-03-19
- Completed Unit 01: Hello Hack & Type System Basics
- Covered: entry points, primitive types, type annotations, tuples, string concat
- Exercises: hello world, typed functions (fraud-themed), code reading (spot type errors)
- Scored 5/5 on code reading exercise — solid type intuition
- Next: Begin Unit 02 (Collections)

### Session 4 — 2026-03-20
- Explored Claude Code internals: ~/.claude.json contents, history.jsonl vs sessions/ vs projects/ structure
- Updated CLAUDE.md and devcontainer-architecture.md with detailed persistence documentation
- Began Unit 02 (Collections): lesson taught, check questions 4/4 correct
- Completed ex01_basics (vec, dict, keyset, HSL functions) — good use of HSL, learned Keyset\keys() and Math\max()
- ex02_hsl: completed #1 (high_risk_alerts) and #2 (total_wire_amount), #3 (group_by_source) still TODO
- Noted: Str\contains vs Str\starts_with — learner used contains, works but less precise
- Created /save-progress skill for session tracking
- Updated CLAUDE.md exercise workflow: namespaces required, no hints in files, include expected output
- Discussed adding HackTest for exercises — decided to try real test framework

### Session 5 — 2026-03-20 (continued)
- Set up Composer + HackTest + fbexpect + hhvm-autoload — test runner working
- Configured hh_autoload.json (roots, devRoots, includeVendor, parse mode)
- Resolved setup snags: allow-plugins, missing tests/ dir, vendor PHP parsing crash, shell wrapper permissions
- Added Composer install to devcontainer.json postCreateCommand for rebuild persistence
- Added vendor/ to .gitignore, created tests/ with ExampleTest.hack
- Deep-dived: how autoloading works (generated map in vendor/autoload.hack), HackTest execution chain, Composer's PHP heritage
- Discussed Meta production tooling vs our setup — language identical, tooling (Buck vs Composer) differs
- Created docs/ folder: moved devcontainer-architecture.md, added composer-and-autoloading.md
- About to rebuild container to verify everything persists
- Next: Verify rebuild works, write real tests for exercises, finish ex02 #3, ex03 code reading

### Session 6 — 2026-03-20 (continued)
- Moved test files from `tests/` to colocated with exercises in unit folders
- Settled on naming convention: CamelCase filenames matching class name (e.g., `Ex01BasicsTest.hack` with class `Ex01BasicsTest`) — HackTest requires files ending in `Test.hack` and class name matching filename
- Removed `tests/` directory, cleared `devRoots` in hh_autoload.json (tests now discovered via `roots`)
- Created `Ex01BasicsTest.hack` — 5/5 passing
- Created `Ex02HslTest.hack` — 4/5 passing (testGroupBySource errors as expected, still TODO)
- Updated CLAUDE.md: exercises must have colocated test files created at the same time
- Discovered case-insensitive filesystem in devcontainer (same inode for different casings) — affected file renaming
- Next: Implement ex02 #3 (group_by_source), then ex03 code reading, finish Unit 02

### Session 7 — 2026-03-20 (continued)
- Completed Unit 02: finished ex02 #3 (group_by_source) using Dict\group_by + Dict\map, ex03 code reading scored 4.5/5 (missed div-by-zero edge case), comprehension check 2/2
- Added idx(), C\find(), Vec\concat(), Keyset\intersect() to Unit 02 lesson
- Updated CLAUDE.md: lesson content must be thorough, code-reading exercises don't need test files
- Began Unit 03 (Control Flow & Type Refinement): wrote lesson covering if/else, switch, loops, is/as/?as, invariant(), refinement invalidation, ??, break/continue
- Lesson refined through Q&A: fixed switch fallthrough info (is allowed with // FALLTHROUGH comment), clarified ?? vs idx() defaults, clarified invariant() vs as, explained erased generics terminology, explained refinement invalidation mechanics
- Feedback: don't claim things are "common at Meta" without evidence — rephrased as core Hack features
- Comprehension check 4/4 passed
- Created ex01_control_flow.hack + Ex01ControlFlowTest.hack — ready to implement
- Next: Learner implements ex01, then ex02 (refinement), ex03 (code reading), finish Unit 03

### Session 8 — 2026-03-24
- Completed Unit 03: ex01 10/10 (missed default case in switch first try), ex02 14/14 (including unhappy paths), ex03 code reading 5/5
- Added unhappy path tests (toThrow for TypeAssertionException, HH\InvariantException)
- Updated CLAUDE.md: unhappy path tests, run hh-autoload after creating files, cross-check lessons against docs
- Learned: Hack's `.` operator silently converts null to empty string (not a type error)
- Began Unit 04 (Functions, Closures & Type Aliases): lesson written covering default/variadic params, function types, function references, lambdas, capture-by-value, pipe operator, type/newtype aliases

### Session 9 — 2026-03-25
- Deep-dived into newtype: multiple rounds of Q&A to build accurate mental model
  - newtype = compile-time access control for a type, file is the abstraction boundary
  - Defining file sets the rules (exported functions = the API), outside files restricted to API
  - Without constraint: full encapsulation, outside can only use exported functions
  - With `as` constraint: outside files can also treat as the constrained type (e.g. `as arraykey` for dict keys)
  - `===` always works on same type even without constraint
  - Learned that local variable types can widen (adding int key to dict<UserId, string> widens to dict<arraykey, string>)
- Created runnable newtype demo files (newtype_demo_types.hack, newtype_demo_outside.hack) showing both variants
- Added lambda vs named function scope difference to lesson
- Updated CLAUDE.md: cross-check lessons against official docs before presenting
- Next: Comprehension check for Unit 04, then exercises

### Session 10 — 2026-03-25 (continued)
- Comprehension check 5/5: capture-by-value, double<> vs double(), newtype outside-file restrictions, pipe rewrite, closure-in-a-loop (Hack vs Python vs TS with let/var)
- Learner correctly pushed back on TS closure-in-a-loop claim — `let` creates per-iteration binding, so TS with `let` matches Hack behavior
- Created exercises: ex01 (functions), ex02 (pipes), ex03 (predict/code-reading), ex04 (newtype with defining + outside files)
- Added spread operator exercise (#3 combine_risk_scores) and newtype exercise (ex04) after cross-checking lesson coverage
- Updated CLAUDE.md: cross-check exercises against lesson.md for coverage gaps
- Ex01 completed 20/20 — used pipe operator in #1 (valid but wasn't the point), used Math\sum_float for variadics, learned Math\maxva = "variadic arguments" version of Math\max
- Next: ex02 (pipes), ex03 (predict), ex04 (newtype)

### Session 11 — 2026-03-26
- Completed Unit 04: ex02 10/10 (pipes), ex03 4/4 (predict), ex04 14/14 (newtype)
- Ex02: noted style feedback — keep entire pipeline in one pipe expression rather than breaking into intermediate variable + Str\join
- Ex03: learned that (string) cast on whole-number floats (e.g. 220.0) drops the ".0" in Hack
- Ex04: clean newtype usage — correctly used API for opaque TransactionId, direct comparison for RiskLevel (as num), Math\max for comparable types
- Updated CLAUDE.md: predict-output exercises now split into two files — bare exercise file (snake_case) with blank YOUR ANSWER blocks, and a CamelCase answers file (e.g. Ex03PredictAnswers.hack) with concept categories, explanations, and correct answers. Grading appended to exercise file after review.
- Next: Unit 05 (Week 1 Assessment)

### Session 12 — 2026-03-27
- Began Unit 05 (Week 1 Assessment)
- ex01 predict (code reading quiz): 5/5 — covered pipes, closures, capture-by-value, type refinement, collections
- Created ex02 mini-project: Transaction Alert Pipeline (CLI data processor)
  - 5 functions: parse_transactions, score_transaction, score_all, filter_high_risk, build_report
  - Includes <<__EntryPoint>> main for CLI output (hardcoded sample data — no file I/O yet)
  - Introduces shapes (preview of Unit 06) as a natural fit for structured transaction data
  - Uses newtype (RiskScore), type aliases, pipes, function references, HSL functions
  - Tests in Ex02MiniProjectTest.hack (13 tests including end-to-end pipeline)
- Next: Learner implements ex02 mini-project, then Unit 05 complete
