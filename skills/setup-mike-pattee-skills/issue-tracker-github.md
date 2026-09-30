# Issue tracker: GitHub

Tickets for this repo live as GitHub issues. Use the `gh` CLI for all operations. `gh` infers the repo from `git remote -v` when run inside a clone.

## Ticket references

- `#123`, or a `github.com/<owner>/<repo>/issues/123` URL.
- Branch names like `<name>/gh-123-short-description`.
- GitHub shares one number space between issues and pull requests, so `Closes #45` may name a pull request. Check with `gh issue view 45` before treating it as a ticket.

## When a skill says "fetch the relevant ticket"

Run `gh issue view <number> --comments`. Add `--json title,body,labels,state,comments` for machine-readable output.

## When a skill says "publish to the issue tracker"

Create a GitHub issue: `gh issue create --title "..." --body "..."`, using a heredoc for multi-line bodies.

## Pull requests

Pull requests are on GitHub.

- **View**: `gh pr view <number> --comments`
- **Diff**: `gh pr diff <number>`
- **Base and head commits**: `gh pr view <number> --json baseRefName,baseRefOid,headRefName,headRefOid`
