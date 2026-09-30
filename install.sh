#!/usr/bin/env bash
# Links every skill in skills/ into the folders Claude Code and Codex read:
#   ~/.claude/skills  Claude Code
#   ~/.agents/skills  Codex, and other harnesses that follow the Agent Skills layout
# Each link points back into this repo, so a `git pull` updates the installed
# skills. Safe to rerun. It never replaces a folder it didn't create.
set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"
dests=("$HOME/.claude/skills" "$HOME/.agents/skills")
status=0

for dest in "${dests[@]}"; do
  mkdir -p "$dest"

  # Remove links to skills that are no longer in the repo.
  for link in "$dest"/*; do
    [ -L "$link" ] || continue
    case "$(readlink "$link")" in
      "$repo"/skills/*)
        if [ ! -e "$link" ]; then
          rm "$link"
          echo "removed $link (no longer in the repo)"
        fi
        ;;
    esac
  done

  for src in "$repo"/skills/*/; do
    src="${src%/}"
    [ -f "$src/SKILL.md" ] || continue
    link="$dest/$(basename "$src")"

    if [ -L "$link" ] && [ "$(readlink "$link")" = "$src" ]; then
      continue
    fi
    if [ -e "$link" ] || [ -L "$link" ]; then
      echo "skipped $link: something else is already there. Move it into $repo/skills/ or delete it, then rerun." >&2
      status=1
      continue
    fi

    ln -s "$src" "$link"
    echo "linked $link"
  done
done

exit "$status"
