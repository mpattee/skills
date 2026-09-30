# Skills

My agent skills, shared between Claude Code and Codex. Each skill is a folder under `skills/` holding a `SKILL.md` in the [Agent Skills](https://agentskills.io) format, which both tools read.

## Install

```bash
git clone https://github.com/mpattee/skills.git ~/source/skills
~/source/skills/install.sh
```

`install.sh` symlinks each skill into `~/.claude/skills` (Claude Code) and `~/.agents/skills` (Codex). The links point into the clone, so `git pull` updates every installed skill, and editing a skill in the clone changes it for both tools at once. Rerun the script after adding or removing a skill. Restart Codex to pick up changes.

The script skips any skill whose name is already taken by a real folder in either location, rather than overwriting it. To bring in a skill from another machine, move its folder into `skills/`, then rerun.

To use the skills without cloning, `npx skills add mpattee/skills` copies them into place instead of linking them.

## Adding a skill

- One folder per skill, directly under `skills/`. Keep the layout flat: a Codex plugin can only point at one skills folder, and Codex drops symlinks when it installs a plugin, so a flat `skills/` keeps the option of publishing this repo as a Claude or Codex plugin later.
- `agents/openai.yaml` in a skill's folder is optional. It sets the name and one-line summary Codex shows.
- Nothing employer-specific goes here, because the repo is public. Work-only skills belong in a private repo.

## Skills

- **canon-tdd:** test-driven development worked from a test list, following Kent Beck's [Canon TDD](https://newsletter.kentbeck.com/p/canon-tdd): list the behaviours, then red, make it work, make it right, and back to the list.

## Credits

`canon-tdd`'s rules for good tests, and the examples in its `examples-*.md` files, are adapted from Matt Pocock's [tdd skill](https://github.com/mattpocock/skills), used under the MIT licence: Copyright (c) 2026 Matt Pocock.
