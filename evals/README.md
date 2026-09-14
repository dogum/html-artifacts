# Evals

Behavioural tests for the skill, run with [`claude plugin eval`](https://code.claude.com/docs/en/plugin-evals). Two groups:

- `should-trigger/` — requests the skill must pick up, with graders on both *whether* it fired and *what* it produced (a file exists, it's responsive and themed, an editor has an export and keyboard support, charts are SVG, a post-mortem has a real timeline).
- `should-not-trigger/` — requests where the skill's own carve-out says markdown. These are the ones that matter most: a skill that turns every question into a page is worse than no skill. Graders assert the skill did not fire, no `.html` was written, and the reply is short.

Each case runs three times with the plugin and three times without, so the report shows what the skill *adds* (`Δ`), not just whether Claude can do the task.

## Run locally

From the repo root (Claude Code v2.1.269 or later; runs bill to your account):

```bash
claude plugin eval . --allow-tools Write
```

Iterate on one case cheaply:

```bash
claude plugin eval . --allow-tools Write --case "should-not-trigger/*" --runs 1 --ablation none
```

`--allow-tools Write` is required: runs never prompt for permissions, and the should-trigger cases need to write a file.

## In CI

`.github/workflows/evals.yml` runs the suite on `workflow_dispatch` with pinned models and a cost ceiling. It needs an `ANTHROPIC_API_KEY` repository secret. It is manual rather than per-push on purpose; every run is real model calls.

## Adding a case

One directory per case with a `prompt.md` (frontmatter for limits, body is the prompt as a user would type it) and one grader per file under `graders/`. Prefer `regex` and `file_exists` graders over `llm` ones for anything long; keep `llm` rubrics as concrete PASS/FAIL conditions. See the two groups here for the shapes.

`evals/results/` is written by each run and is gitignored.
