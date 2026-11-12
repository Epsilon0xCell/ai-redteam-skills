#!/usr/bin/env bash
# Install the skills in this pack into a local agent skills directory.
# Default target: ~/.claude/skills. Override with SKILLS_DIR.
set -euo pipefail
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"
DEST="${SKILLS_DIR:-$HOME/.claude/skills}"
mkdir -p "$DEST"
for skill in "$SRC"/*/; do
  name="$(basename "$skill")"
  mkdir -p "$DEST/$name"
  cp -R "$skill"/* "$DEST/$name/"
  echo "installed: $name -> $DEST/$name"
done
echo "Done. The skills are plain markdown; any agent that reads SKILL.md files can use them."
