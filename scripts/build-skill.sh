#!/usr/bin/env bash
# Build html-artifacts.skill — the zip Claude.ai accepts under Settings → Capabilities → Skills.
#
# The zip contains a single top-level folder, html-artifacts/, holding SKILL.md and references/.
# Its frontmatter is restricted to Agent Skills spec fields (name, description, license,
# compatibility, metadata, allowed-tools); anything Claude Code-specific fails the upload.
#
# Usage: scripts/build-skill.sh [output-path]   (default: dist/html-artifacts.skill)
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src="$root/skills/html-artifacts"
out="${1:-$root/dist/html-artifacts.skill}"

# Reject Claude Code-only frontmatter keys before packaging.
forbidden='^(when_to_use|argument-hint|arguments|disable-model-invocation|user-invocable|disallowed-tools|model|effort|context|agent|background|hooks|paths|shell):'
if awk 'NR==1 && $0!="---"{exit} NR>1 && $0=="---"{exit} NR>1{print}' "$src/SKILL.md" | grep -Eq "$forbidden"; then
  echo "SKILL.md contains Claude Code-only frontmatter; remove it before packaging for Claude.ai." >&2
  exit 1
fi

mkdir -p "$(dirname "$out")"
stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT
mkdir -p "$stage/html-artifacts"
cp "$src/SKILL.md" "$stage/html-artifacts/"
cp -R "$src/references" "$stage/html-artifacts/"
rm -f "$out"
# -X drops extended attributes, -D drops directory entries: byte-stable across machines.
( cd "$stage" && find html-artifacts -type f | LC_ALL=C sort | zip -X -D -q "$out" -@ )
echo "built $out"
unzip -l "$out"
