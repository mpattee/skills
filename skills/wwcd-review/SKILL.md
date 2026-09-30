---
name: wwcd-review
description: "Review a pull request against an independent implementation plan derived from its linked ticket and the repository code. Use when the user asks for a ticket-grounded PR review, a comparison of a PR with what the ticket calls for, or invokes wwcd-review."
---

# WWCD Review

WWCD stands for "What Would Claude Do": before looking at the PR, decide how you would implement the ticket, then hold the PR up against that.

Review the ticket first, derive the implementation the ticket calls for from the existing code, then compare the PR's changes with that plan. Report meaningful differences and explain which approach better satisfies the ticket and why.

The plan is **blind**: written from the ticket and the base code alone, before reading anything the PR's author wrote about the change. A PR's description, commits, changed-file list and diff all describe its solution. Read any of them first and the plan converges on the PR, and the comparison stops finding anything.

## Repo configuration

This skill reads two files that `/setup-mike-pattee-skills` writes (Matt Pocock's `/setup-matt-pocock-skills` writes compatible ones):

- **`docs/agents/issue-tracker.md`**: ticket ID formats (`## Ticket references`), how to fetch a ticket (`## When a skill says "fetch the relevant ticket"`), and the pull request commands (`## Pull requests`).
- **`docs/agents/domain.md`**: where `CONTEXT.md` and the ADRs live, and any platforms a change may span.

If either is missing, or lacks the section you need, work it out instead:

- **Code host:** `git remote -v`. Use `gh` for GitHub and `glab` for GitLab.
- **Ticket references:** look in the PR title, description and branch name for issue numbers, `ABC-123` style keys, or tracker URLs. Match them to the tracker tools available (a Linear or Jira MCP server, `gh`, `glab`).
- **Domain docs:** `CLAUDE.md` or `AGENTS.md`, `CONTEXT.md`, and any ADR folder (`docs/adr/`, `doc/adr/`, `doc/architecture/decisions/`, `docs/decisions/`).

If you still can't tell where the ticket lives, ask the user. After the review, suggest running `/setup-mike-pattee-skills` so the next review doesn't have to guess.

## Workflow

1. **Identify and pin the PR, reading only its metadata.** Resolve the supplied PR number or URL. Read its title, branch name, repository, base and head commits, and when it was opened. Record the head SHA so findings are tied to a specific revision. Find ticket references in the title, branch name and description using the formats in `## Ticket references`, but pull them out with a pattern match (for example `gh pr view <n> --json body --jq .body | grep -oE '<reference pattern>'`) rather than reading the description. A reference that resolves to a pull request rather than a ticket is not a ticket. If several tickets appear, the primary one is the one the title or a closing keyword (`Closes`, `Fixes`, `Resolves`) names; list the rest as related. If no ticket is referenced, or it's still ambiguous, ask the user for the ticket before proceeding. Leave the description, commits, changed files and diff for step 4.

2. **Read the ticket.** Fetch the live ticket and its comments as `docs/agents/issue-tracker.md` describes, routing by reference format when the repo uses more than one tracker. Read its description, acceptance criteria, comments, linked issues, and any explicit decisions or exclusions relevant to the PR. Separate binding requirements from background discussion and unresolved proposals. Comments posted after the PR was opened, on the ticket or on linked tickets, often describe the PR's solution, so keep them blind too: note that they exist, and read them in step 4. If the tracker is inaccessible, say so and do not present a ticket-grounded verdict as complete.

3. **Write the blind plan.** `git fetch` first (the local checkout is often stale), then inspect `CLAUDE.md` or `AGENTS.md`, the domain docs and ADRs that `docs/agents/domain.md` points to, and source on the PR's base revision (read via `git show <base>:<path>`, not the working tree). If the repo holds more than one platform or codebase and the ticket spans them, plan each one. Trace the behavior through callers, state or persistence, and consumers as needed. Use the ticket requirements and existing architecture to describe the smallest coherent implementation that would satisfy the ticket. Include expected behavior, affected code paths, error/lifecycle handling, and necessary tests. Write the plan down in your working notes before step 4. Until then, the only PR material you have read is the metadata from step 1.

4. **Compare the PR.** Now read the PR description, its commits, the ticket comments held back in step 2, and the complete diff and surrounding code at the pinned head. Where the description records a decision or a deliberate difference, judge it on its merits in step 5; it isn't evidence that the plan was wrong. Map each plan item to the implementation: satisfied, partial, missing, or implemented differently. Identify scope that is unsupported by the ticket, and assess whether it creates risk or is justified by the existing design. Consider tests and edge cases required by the ticket. Do not treat a different design as a defect when it meets the same requirement safely.

5. **Judge differences with evidence.** For each material difference, state the ticket/plan expectation, what the PR does, and which approach you prefer with a concrete reason tied to behavior, architecture, safety, maintainability, or coverage. Cite exact ticket criteria and PR file/line locations. Distinguish confirmed defects from tradeoffs or uncertain assumptions. If the PR's approach is better, say so; the blind plan is a comparison baseline, not a predetermined winner.

6. **Check review freshness and report.** Confirm the live PR head still matches the pinned SHA. If it changed, refresh the diff and recheck affected findings before giving a final review. Report validation actually performed and gaps without implying tests ran when they did not. Do not modify code or post review comments unless the user explicitly asks.

## Output

Start with the ticket, PR, and reviewed head SHA, then give a concise verdict. Include the blind plan in brief, as it stood before step 4, so the reader can see what the comparison was made against. Organize findings by severity (`P0`–`P3`) and include only actionable or decision-relevant items. For each finding include:

- **Difference:** what the blind plan expected and what the PR implements.
- **Preference:** which approach better meets the ticket and why.
- **Evidence:** ticket criterion plus PR file and line (or a clear statement that the concern is a tradeoff, not a defect).
- **Impact and correction:** consequence and the smallest useful change, when a correction is warranted.

Follow with covered plan items, validation performed, and remaining gaps. If no material differences or defects remain, state that explicitly; do not invent findings to fill the format.
