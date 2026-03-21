# Progress Tracker

This file is the source of truth for where we are in the curriculum.
Claude reads this at the start of every new conversation to resume seamlessly.

## Current State

- **Current Unit:** 02
- **Current Lesson Status:** in progress (lesson taught, ex01 done, ex02 partially done)
- **Last Completed Unit:** 01
- **Date Last Active:** 2026-03-20 (session 6)

## Unit Completion Log

| Unit | Topic | Status | Date Completed | Notes |
|------|-------|--------|----------------|-------|
| 01 | Hello Hack & Type System Basics | complete | 2026-03-19 | Strong grasp, no weak areas |
| 02 | Collections | in progress | | ex01 done, ex02 in progress (1&2 done, #3 TODO) |
| 03 | Control Flow & Type Refinement | not started | | |
| 04 | Functions, Closures & Type Aliases | not started | | |
| 05 | Week 1 Assessment | not started | | |
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
