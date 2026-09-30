# Issue tracker: Linear

Tickets for this repo live in Linear, team **<team name>**. Use the Linear MCP server for all operations.

## Ticket references

- `<KEY>-123`, where `<KEY>` is the team's issue prefix, or a `linear.app/<workspace>/issue/<KEY>-123` URL.
- Branch names like `<name>/<key>-123-short-description`, the form Linear's "copy git branch name" produces.

## When a skill says "fetch the relevant ticket"

Fetch the issue with the Linear MCP's get-issue tool, then its comments with the list-comments tool.

## When a skill says "publish to the issue tracker"

Create a Linear issue in team **<team name>**<, project **<project name>**,> with the Linear MCP's save-issue tool.

## Pull requests

Pull requests are on <GitHub | GitLab>. Linear links them to tickets through the ticket key in the branch name or title.

- **View**: `gh pr view <number> --comments`
- **Diff**: `gh pr diff <number>`
- **Base and head commits**: `gh pr view <number> --json baseRefName,baseRefOid,headRefName,headRefOid`
