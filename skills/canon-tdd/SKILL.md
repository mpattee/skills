---
name: canon-tdd
description: Test-driven development worked from a test list (Kent Beck's canon TDD). Use when building a feature or fixing a bug test-first, porting code whose behaviour already has tests, or when the user says TDD or red-green-refactor.
---

# Canon TDD

Work from a **test list**: the behaviours the change must have, written down before the first test and worked through one item at a time. The list is the plan, the record of progress, and the stopping rule. The work is done when every item is ticked.

Each cycle is **red**, then **make it work**, then **make it right**, then back to the list. Keeping those apart means any failure has one cause.

If the repo has a `CONTEXT.md`, read it so list items and test names use the project's domain words.

## 1. Write the test list

List each behaviour case the change should handle, grouped by the **seam** it's tested at: the public interface where the behaviour is observed (a function, a type's methods, a CLI command, an endpoint).

- Each item is a one-line statement of what the code does, in the caller's terms: "a 304 response keeps the cached issues", not "add an etag field". Implementation ideas belong in your notes.
- Items stay one-liners until step 2 picks them. The list is a set of reminders, not test code.
- Where the items come from depends on the work:
  - **New design:** from the requirement or ticket. Confirm the seams and the list with the user before writing the first test. That is where they steer what gets tested.
  - **Bug fix:** the first item is the bug, stated as the correct behaviour. Its test is the reproduction.
  - **Port:** from the existing tests and observable behaviour of the code being ported. Each deliberate difference from the original is its own item, marked as a difference. The behaviour is already decided, so show the user the list and carry on.

Post the list as a checklist, and repost it with ticks at the end of each cycle so it survives context summarisation. When the work spans sessions, keep it in the ticket or PR as well.

Done when every behaviour the change needs is on the list and each item names its seam.

## 2. Red

Pick one item and write one test for it: real setup, a call through the seam, an assertion. Run it and watch it fail on the missing behaviour itself, as an assertion failure rather than a compile error or a typo. A test you haven't seen fail hasn't shown it can catch anything.

Order matters: it changes both how the work goes and the design that results. Start with the simplest case that exercises the seam, then take whichever item teaches the most or unblocks the most.

If the new test passes straight away, find out why before moving on. Either the behaviour already exists (tick the item and say so) or the test isn't testing what its name claims.

## 3. Make it work

Change the code until the new test and every earlier test pass. Stay on behaviour here and leave design improvements for step 4.

- When the implementation is obvious, write it.
- When it isn't, take a smaller step: hard-code the answer, then let the next item force the general version.

## 4. Make it right

With everything green, tidy what this cycle touched: remove the duplication it introduced, fix names, simplify. Rerun the tests after each change so they stay green throughout.

Tidy only as far as the code needs now. Duplication is a hint, not a command: an abstraction waits until a second or third case asks for it. When nothing needs tidying, move on.

## 5. Back to the list

Tick the item. Add any cases you discovered during the cycle. If a new case shows that earlier work went the wrong way, back it out and take the items in a different order. Then return to step 2 with the next item.

Done when the list is empty and the full test suite passes. Before calling it finished, reread the list against the requirement: a missing item is a missing behaviour.

## Tests worth keeping

When writing a test or deciding what to fake, read the examples for the project's language, [Swift](examples-swift.md), [Rust](examples-rust.md) or [Ruby](examples-ruby.md), for good and bad tests side by side. For any other language, read the Swift file.

- **Through the seam.** A test calls the public interface and asserts on what a caller can observe, so it survives a rewrite of the internals. Verify a write by reading it back through the interface.
- **Named for the behaviour:** "expired token triggers one refresh", not "test_refresh_2".
- **Independent expected values.** Take them from a literal, a worked example, the spec, or the original code's tests when porting. An expected value computed the way the code computes it passes by construction and can never disagree with the code.
- **Mocks at system boundaries only:** the network, the clock, randomness, and sometimes the database or file system. Code you own runs for real.
- **One behaviour per test.**
