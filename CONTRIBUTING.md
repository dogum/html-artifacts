# Contributing

Thanks for helping. This is a small repo and the bar is simple: the skill should make Claude's artifacts better, and never make it produce HTML when markdown was right.

## Layout

- `skills/html-artifacts/SKILL.md` is the entry point. Keep it under about 100 lines; it is in context every time the skill fires.
- `skills/html-artifacts/references/` hold the per-category and cross-cutting guidance. Each file should stay short enough to read in a minute.
- `evals/` are behavioural tests. `docs/` is the site and the examples. `scripts/` are the checks.

## Before you open a PR

```bash
scripts/check-examples.sh                         # static rules over docs/examples
node scripts/verify-example.mjs docs/examples/*.html docs/index.html   # needs Playwright + Chromium
scripts/build-skill.sh                            # the Claude.ai zip still builds
claude plugin validate .                          # manifests are valid
```

If you changed anything that affects *when* the skill triggers (the description, the "reach for" or "stay in markdown" lists), also run the evals and paste the summary table in the PR:

```bash
claude plugin eval . --allow-tools Write
```

Runs cost real model calls. Use `--case` and `--runs 1 --ablation none` while iterating.

## Rules of thumb for skill content

- **Judgment over mechanics.** Don't add instructions for things current models already do. Add instructions for decisions they get wrong.
- **Facts go in `harness-mechanics.md`.** Anything about a specific surface (Claude.ai, Claude Code, Cowork, CDN lists, storage rules) lives there and nowhere else, so it can go stale in one place.
- **Every "must" needs a reason** in the same sentence. Skills that read as rulebooks get ignored.
- **No hardcoded paths.** Skills load in many places.
- **Frontmatter stays spec-only.** `name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools`. Claude Code-only fields break the Claude.ai upload; `scripts/build-skill.sh` will refuse to package them.

## Adding an example

1. Write the artifact the way the skill would: one file, no network, both themes, viewport meta, `<title>`, visible focus, and a header comment with the prompt.
2. Make it pass `scripts/check-examples.sh` and `scripts/verify-example.mjs`.
3. Add a card to `docs/index.html` and a row to the README table.

## Releasing

1. Bump `version` in both `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`, and in `metadata.version` in `SKILL.md`.
2. Add a section to `CHANGELOG.md`.
3. Tag `vX.Y.Z` and push the tag. The release workflow builds the zip and creates the GitHub Release with the changelog section as notes.
