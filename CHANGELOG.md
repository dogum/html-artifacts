# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project uses [semantic versioning](https://semver.org/).

## [2.0.0] - 2026-09-14

The skill was written for models that needed to be told how to write HTML. Four months later they don't. This release moves the skill's budget from mechanics to judgment and verification, fixes the facts that had gone stale, and adds the distribution and testing scaffolding a shared skill should have.

### Added
- **Universal rule 8, verify before delivering.** Render headless and screenshot when a browser is available; run a read-through checklist when it isn't. The skill never stalls on a surface without tooling.
- **Workflow section** in SKILL.md: decide, pick the reference, match the style, draft, verify.
- **Four references:** `data-and-charts.md`, `accessibility-and-print.md`, `harness-mechanics.md`, `verify-before-delivering.md`.
- **Eval suite** under `evals/` for `claude plugin eval`: four should-trigger cases and three should-not-trigger cases, graded on both whether the skill fired and what it produced. Manual CI workflow with pinned models and a cost ceiling.
- **Plugin manifests** (`.claude-plugin/plugin.json`, `marketplace.json`) so `/plugin marketplace add dogum/html-artifacts` works and Claude Code users get updates.
- **Release workflow** that builds `html-artifacts.skill` from source on every `v*` tag and attaches it to a GitHub Release. **CI workflow** that validates frontmatter, manifests, and examples on every push.
- **Scripts:** `build-skill.sh`, `check-examples.sh`, `verify-example.mjs`.
- **Three examples:** annotated code review, design-token sheet, incident post-mortem.
- **Gallery issue template** for community-made artifacts. `CONTRIBUTING.md`.

### Changed
- **SKILL.md rewritten.** Shorter, with "stay in markdown" expanded to match "reach for HTML" in weight. Frontmatter now carries `license` and `metadata.version` and uses only Agent Skills spec fields.
- **Storage guidance.** Artifacts no longer say "no localStorage"; they say storage is unreliable in sandboxed surfaces, keep state in memory, and wrap access in try/catch.
- **Theme guidance.** Dark mode is defined twice: under `prefers-color-scheme` and under `[data-theme="dark"]`, so both system preference and a manual toggle work. Baseline CSS updated accordingly.
- **Editors** must have a keyboard path for every drag-and-drop, list their shortcuts, and show export text in a textarea as well as copying it.
- **Decks** get tap-to-advance for touch devices and a print stylesheet.
- **Code review severity tags** are worded as well as colored.
- **Canonical layout** moved from `skill/` to `skills/html-artifacts/` (plugin layout). The manual install command changed to match.
- **All six original examples** now pass the skill's rules: prompt header comment, both themes, visible focus, keyboard support on the triage board, focusable flowchart nodes. Two real bugs found by the new headless check were fixed: the comparison page overflowed at desktop width, and the explainer logged SVG attribute errors on load.
- **Docs site** updated: nine examples, twelve-spoke structure diagram, three install paths.

### Removed
- The committed `html-artifacts.skill` zip. It is now a release asset built by CI, so it cannot drift from `skills/`.
- Leftover copy from the source article ("Greg or anyone else may open it on a phone") and a hardcoded path to a `frontend-design` skill.

## [0.1.0] - 2026-05-08

Initial release: `SKILL.md` with the recognition heuristic and universal rules, eight per-category references, six examples, and the GitHub Pages site.

[2.0.0]: https://github.com/dogum/html-artifacts/compare/v0.1.0...v2.0.0
[0.1.0]: https://github.com/dogum/html-artifacts/releases/tag/v0.1.0
