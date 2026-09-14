#!/usr/bin/env bash
# Static checks that every example in docs/examples/ satisfies the skill's universal rules.
# Cheap, no browser. The Playwright pass in scripts/verify-example.mjs is the real one.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
fail=0
for f in docs/examples/*.html; do
  n=$(basename "$f"); problems=()
  grep -q '<title>' "$f"                          || problems+=("no <title>")
  grep -q 'name="viewport"' "$f"                  || problems+=("no viewport meta")
  grep -q 'Produced by the html-artifacts skill' "$f" || problems+=("no prompt header comment")
  grep -q ':focus-visible' "$f"                   || problems+=("no :focus-visible style")
  grep -Eq 'https?://' "$f" && ! grep -Eq 'https?://(github\.com|dogum\.github\.io|thariqs\.github\.io|x\.com|fonts\.googleapis\.com|fonts\.gstatic\.com)' "$f" && problems+=("external URL")
  grep -q '<script src=' "$f"                     && problems+=("external script")
  grep -Eq '^(html|body|header|\.hero|main|h1)[^{]*\{[^}]*gradient' "$f" && problems+=("gradient on a page-level element")
  # Dark theme: either both the media query and the data-theme block, or an explicitly single-theme deck.
  if ! grep -q 'single-theme' "$f"; then
    grep -q 'prefers-color-scheme: dark' "$f"     || problems+=("no dark media query")
    grep -q 'data-theme="dark"' "$f"              || problems+=("no data-theme=dark block")
  fi
  # Anything with manipulable state must export and must have keyboard handling.
  if grep -q 'draggable' "$f"; then
    grep -Eqi 'copy as|clipboard' "$f"           || problems+=("editor without export")
    grep -q 'keydown' "$f"                        || problems+=("editor without keyboard support")
  fi
  if [ ${#problems[@]} -gt 0 ]; then fail=1; printf '%s: %s\n' "$n" "$(IFS=';'; echo "${problems[*]}")"; else echo "$n: ok"; fi
done
exit $fail
