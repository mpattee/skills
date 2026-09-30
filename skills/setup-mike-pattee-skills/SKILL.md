---
name: setup-mike-pattee-skills
description: Configure this repo for Mike Pattee's skills by recording where tickets live, how they are referenced, where pull requests are reviewed, and where the domain docs are. Run once per repo before the other skills, or again to switch trackers.
disable-model-invocation: true
---

# Setup Mike Pattee's Skills

The other skills in this collection are written generically. They say "fetch the relevant ticket" or "read the domain docs" and leave the details to each repo. This skill writes those details down, in files the skills read:

- **`docs/agents/issue-tracker.md`**: where tickets live, what their IDs look like, how to fetch and create them, and where pull requests are reviewed.
- **`docs/agents/domain.md`**: where `CONTEXT.md` and the architecture decision records (ADRs) live, and how to use them.
- **An `## Agent skills` section** in `CLAUDE.md` or `AGENTS.md` pointing at both files, so an agent finds them even when a skill doesn't name the path.

The files use the same paths and section headings as Matt Pocock's `setup-matt-pocock-skills`, so a repo set up by either skill works with both collections. This skill adds sections to those files. It never removes or rewrites what's already there.

This is a prompt-driven skill, not a script. Explore, show the user what you found, confirm, then write.

## 1. Explore

Read whatever exists. Don't assume.

- `git remote -v`: is the code on GitHub, GitLab, or somewhere else? That is where pull requests are reviewed.
- `CLAUDE.md` and `AGENTS.md` at the repo root: which exists, and does either already have an `## Agent skills` section?
- `docs/agents/`: does a previous run of this skill, or of `setup-matt-pocock-skills`, already exist? If so, read each file and note which of the sections listed in step 3 are missing.
- Tracker signals: ticket-like IDs in recent commit messages and branch names (`git log --oneline -30`, `git branch -a`), such as `#123`, `ABC-123`, or tracker URLs. Which tracker tools are available: a Linear or Jira MCP server, `gh`, `glab`? A `.scratch/` folder means local markdown issues are in use.
- Domain docs: `CONTEXT.md` or `CONTEXT-MAP.md` at the root, and ADR folders (`docs/adr/`, `doc/adr/`, `doc/architecture/decisions/`, `docs/decisions/`).
- Platforms: does the repo hold more than one app or codebase that a single ticket might touch (for example an iOS and an Android app side by side, or a client and a server)?

If `setup-matt-pocock-skills` is installed and `docs/agents/` doesn't exist yet, suggest running it first so its sections are in place, then continue here to add the rest. Don't make it a requirement.

## 2. Present findings and ask

Summarise what's present and what's missing. Then go through the questions one at a time, leading each with the answer exploration suggests so the user can accept it in a word. Skip a question when exploration already settled it, or when the existing file already answers it.

**A. Where do tickets live?**

- **GitHub Issues**: uses the `gh` CLI. Propose this when the remote is GitHub and no other tracker shows up.
- **GitLab Issues**: uses the `glab` CLI. Propose this when the remote is GitLab.
- **Linear**: uses the Linear MCP server. Propose this when commits or branches carry `ABC-123` style IDs and a Linear MCP is available. Ask for the team, and the default project if there is one.
- **Local markdown**: files under `.scratch/`. Good for solo work or repos without a remote.
- **Other** (Jira, or more than one tracker at once): ask the user to describe it in a paragraph, and write the file from that description.

**B. How are tickets referenced?** List the ID formats you found (for example `#123`, `ABC-123`, tracker URLs, branch names like `mike/abc-123-short-name`) and ask the user to confirm or correct them. Skills use this list to find the ticket a pull request or commit belongs to.

**C. Where are pull requests reviewed?** Usually the host in `git remote -v`. Ask only when it's unclear, or when the tracker and the code host differ (Linear tickets with GitHub pull requests is common, and needs no question).

**D. Where are the domain docs?** Default to a single `CONTEXT.md` at the root and whichever ADR folder you found, or `docs/adr/` when there is none. Offer a multi-context layout (a root `CONTEXT-MAP.md` pointing at one `CONTEXT.md` per context) only in a genuinely multi-package repo. Note any platforms found in step 1, so skills know to consider each one a change might touch.

## 3. Confirm and write

Show the user a draft of every file and section you'll write, and let them edit it before anything is saved.

**`docs/agents/issue-tracker.md`**

If the file doesn't exist, start from the template for the chosen tracker in this folder:

- [issue-tracker-github.md](issue-tracker-github.md)
- [issue-tracker-gitlab.md](issue-tracker-gitlab.md)
- [issue-tracker-linear.md](issue-tracker-linear.md)
- [issue-tracker-local.md](issue-tracker-local.md)

For "Other", write it from the user's description, using the same section headings.

If the file already exists, keep everything in it and add only the sections below that are missing. Put new sections after the existing ones.

The skills in this collection read these sections by their exact headings:

- `## Ticket references`: the ID formats from question B, and where they show up (pull request titles, descriptions, branch names, commit messages). When a repo uses more than one tracker, say which format belongs to which.
- `## When a skill says "fetch the relevant ticket"`: how to read a ticket, with its comments.
- `## When a skill says "publish to the issue tracker"`: how to create one.
- `## Pull requests`: the host, and the commands to view a pull request, its diff, and its current head commit.

**`docs/agents/domain.md`**

If it doesn't exist, start from [domain.md](domain.md) and fill in the real ADR path, the layout, and any platforms. If it exists, leave it alone unless the user asks for a change, or it's missing a `## Platforms` section and step 1 found more than one.

**The `## Agent skills` section**

If `CLAUDE.md` exists, edit it. Otherwise, if `AGENTS.md` exists, edit that. If neither exists, ask the user which to create. Never create one when the other already exists.

If an `## Agent skills` section already exists, update its `### Issue tracker` and `### Domain docs` entries in place, and leave any other subsections alone. Otherwise add:

```markdown
## Agent skills

### Issue tracker

[One line: where tickets live and how they're referenced.] See `docs/agents/issue-tracker.md`.

### Domain docs

[One line: the layout, and the ADR folder.] See `docs/agents/domain.md`.
```

## 4. Done

Tell the user which files were created or changed, and which sections were added. Mention that they can edit `docs/agents/*.md` directly later. Rerunning this skill is only needed to switch trackers or start again.
