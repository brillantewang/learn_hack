# Progress Tracker

This file is the source of truth for where we are in the curriculum.
Claude reads this at the start of every new conversation to resume seamlessly.

## Current State

- **Current Unit:** 01
- **Current Lesson Status:** not started
- **Last Completed Unit:** none
- **Date Last Active:** 2026-03-17

## Unit Completion Log

| Unit | Topic | Status | Date Completed | Notes |
|------|-------|--------|----------------|-------|
| 01 | Hello Hack & Type System Basics | not started | | |
| 02 | Collections | not started | | |
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
- Next: Begin Unit 01 teaching
