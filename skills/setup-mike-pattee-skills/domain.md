# Domain docs

How skills should use this repo's domain documentation when exploring the code.

## Before exploring, read these

- **`CONTEXT.md`** at the repo root: the glossary of domain terms. In a multi-context repo, **`CONTEXT-MAP.md`** at the root points at one `CONTEXT.md` per context. Read each one relevant to the work.
- **`<adr folder>`**: architecture decision records. Read the ones that touch the area you're working in.

If any of these don't exist, carry on without them. Don't flag their absence or suggest creating them.

## Layout

```
/
├── CONTEXT.md
├── <adr folder>/
└── <source folders>
```

## Platforms

<Delete this section for a single-codebase repo.> This repo holds <e.g. an iOS app in `App/` and an Android app in `Android/`>. When a change touches behaviour shared across them, consider each one.

## Use the glossary's words

When naming a domain concept in a ticket, a test, a review or a proposal, use the term as `CONTEXT.md` defines it. If the concept isn't in the glossary, either you're inventing language the project doesn't use, or there's a gap worth noting.

## Flag ADR conflicts

If your output contradicts an existing ADR, say so explicitly rather than silently overriding it:

> _Contradicts ADR-0007 (event-sourced orders), but worth reopening because…_
