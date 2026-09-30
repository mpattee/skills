# Issue tracker: GitLab

Tickets for this repo live as GitLab issues. Use the [`glab`](https://gitlab.com/gitlab-org/cli) CLI for all operations. `glab` infers the repo from `git remote -v` when run inside a clone.

## Ticket references

- `#123`, or a `gitlab.com/<group>/<project>/-/issues/123` URL.
- Branch names like `123-short-description`, which is the form GitLab generates from an issue.
- `!67` is a merge request, not a ticket. GitLab numbers issues and merge requests separately.

## When a skill says "fetch the relevant ticket"

Run `glab issue view <number> --comments`. Add `-F json` for machine-readable output.

## When a skill says "publish to the issue tracker"

Create a GitLab issue: `glab issue create --title "..." --description "..."`, using a heredoc for multi-line descriptions.

## Pull requests

GitLab calls them merge requests.

- **View**: `glab mr view <number> --comments`
- **Diff**: `glab mr diff <number>`
- **Base and head commits**: `glab mr view <number> -F json`, reading `diff_refs.base_sha` and `diff_refs.head_sha`
