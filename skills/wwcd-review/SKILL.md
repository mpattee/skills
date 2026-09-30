---
name: wwcd-review
description: "Review a pull request against an independent implementation plan derived from its linked ticket and the repository code. Use when the user asks for a ticket-grounded PR review, a comparison of a PR with what the ticket calls for, or invokes wwcd-review."
---

# WWCD Review

Review the ticket first, derive the implementation the ticket calls for from the existing code, then compare the PR's changes with that plan. Report meaningful differences and explain which approach better satisfies the ticket and why.

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

1. **Identify and pin the PR.** Resolve the supplied PR number or URL. Read its title, description, repository, base/head commits, and changed files. Find ticket references in the title, description, and branch name, using the formats in `## Ticket references`. A reference that resolves to a pull request rather than a ticket is not a ticket. If multiple tickets appear, determine which is the primary ticket from the PR's stated purpose and list related tickets separately. If no ticket is referenced or the reference is ambiguous, ask the user for the ticket before proceeding. Record the head SHA so findings are tied to a specific revision.

2. **Read the ticket.** Fetch the live ticket and its comments as `docs/agents/issue-tracker.md` describes, routing by reference format when the repo uses more than one tracker. Read its description, acceptance criteria, comments, linked issues, and any explicit decisions or exclusions relevant to the PR. Separate binding requirements from background discussion and unresolved proposals. If the tracker is inaccessible, say so and do not present a ticket-grounded verdict as complete.

3. **Derive an independent implementation plan.** `git fetch` first (the local checkout is often stale), then inspect `CLAUDE.md` or `AGENTS.md`, the domain docs and ADRs that `docs/agents/domain.md` points to, and source on the PR's base revision (read via `git show <base>:<path>`, not the working tree). If the repo holds more than one platform or codebase and the ticket spans them, plan each one. Trace the behavior through callers, state or persistence, and consumers as needed. Use the ticket requirements and existing architecture to describe the smallest coherent implementation that would satisfy the ticket. Include expected behavior, affected code paths, error/lifecycle handling, and necessary tests. Keep this plan independent: do not inspect or use the PR diff until the plan is written down in your working notes.

4. **Compare the PR.** Inspect the complete PR diff and surrounding code at the pinned head. Map each plan item to the implementation: satisfied, partial, missing, or implemented differently. Identify scope that is unsupported by the ticket, and assess whether it creates risk or is justified by the existing design. Consider tests and edge cases required by the ticket. Do not treat a different design as a defect when it meets the same requirement safely.

5. **Judge differences with evidence.** For each material difference, state the ticket/plan expectation, what the PR does, and which approach you prefer with a concrete reason tied to behavior, architecture, safety, maintainability, or coverage. Cite exact ticket criteria and PR file/line locations. Distinguish confirmed defects from tradeoffs or uncertain assumptions. If the PR's approach is better, say so; the independent plan is a comparison baseline, not a predetermined winner.

6. **Check review freshness and report.** Confirm the live PR head still matches the pinned SHA. If it changed, refresh the diff and recheck affected findings before giving a final review. Report validation actually performed and gaps without implying tests ran when they did not. Do not modify code or post review comments unless the user explicitly asks.

## Output

Start with the ticket, PR, and reviewed head SHA, then give a concise verdict. Organize findings by severity (`P0`–`P3`) and include only actionable or decision-relevant items. For each finding include:

- **Difference:** what the independent plan expected and what the PR implements.
- **Preference:** which approach better meets the ticket and why.
- **Evidence:** ticket criterion plus PR file and line (or a clear statement that the concern is a tradeoff, not a defect).
- **Impact and correction:** consequence and the smallest useful change, when a correction is warranted.

Follow with covered plan items, validation performed, and remaining gaps. If no material differences or defects remain, state that explicitly; do not invent findings to fill the format.
