# Issue tracker: Local markdown

Tickets for this repo live as markdown files in `.scratch/`.

- One feature per folder: `.scratch/<feature-slug>/`.
- The spec is `.scratch/<feature-slug>/spec.md`.
- Tickets are one file each at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01`.
- Comments are appended at the bottom of the file under a `## Comments` heading.

## Ticket references

- A path such as `.scratch/<feature-slug>/issues/03-short-name.md`, or `<feature-slug>#03` for short.
- Branch names like `<feature-slug>-03`.

## When a skill says "fetch the relevant ticket"

Read the file at the referenced path, along with the feature's `spec.md`.

## When a skill says "publish to the issue tracker"

Create a new file under `.scratch/<feature-slug>/`, creating the folder if needed.

## Pull requests

<Pull requests are on GitHub (`gh pr view`, `gh pr diff`, `gh pr view --json baseRefOid,headRefOid`). | There are no pull requests. Review a branch against its base with `git diff <base>...<branch>`.>
