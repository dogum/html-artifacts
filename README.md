# html-artifacts

A Claude skill for producing self-contained HTML artifacts instead of markdown when the task warrants it. And for knowing when it doesn't.

> Markdown has become the dominant file format used by agents to communicate with us. It's simple, portable, has some rich text capability and is easy for you to edit. But as agents have become more and more powerful, I have felt that markdown has become a restricting format.
>
> — Thariq Shihipar, [*The Unreasonable Effectiveness of HTML*](https://thariqs.github.io/html-effectiveness/)

This skill operationalizes the recognition heuristic and per-category patterns from Thariq's post. It triggers on requests where HTML lands harder than markdown (comparisons, plans, code reviews, explainers, post-mortems, dashboards, custom editors) and stays out of the way for everything else.

**[→ See the live examples](https://dogum.github.io/html-artifacts/)** · **[Changelog](CHANGELOG.md)** · **[Latest release](https://github.com/dogum/html-artifacts/releases/latest)**

## What's new in 2.0

The first version taught Claude *how* to write HTML. Models no longer need that. Version 2.0 spends the skill's budget on judgment and verification instead:

- **Verify before delivering.** A new universal rule: if a browser is available, render the file headless, screenshot it at desktop and phone width, check the console, fix what you see. If no browser is available (Claude.ai chat, a surface without a shell), a read-through checklist runs instead, and the skill never stalls waiting for tooling it doesn't have. This one rule fixes more bad artifacts than any styling advice.
- **A sharper "stay in markdown" section.** Over-triggering is the failure mode Thariq warned about. The carve-outs are now concrete, and the eval suite tests them.
- **Four new references.** Data and charts (SVG, no library), accessibility and print, harness mechanics (the one file that knows which surface you're on), and the pre-delivery check.
- **Facts fixed.** Storage rules in artifacts, the CDN allowlist, the `data-theme` toggle alongside `prefers-color-scheme`, no hardcoded paths.
- **Evals.** Seven behavioural cases for `claude plugin eval`, four that should trigger and three that must not. Every run compares against a no-skill baseline, so the number you see is what the skill *adds*.
- **Distribution.** A plugin marketplace, so Claude Code users get updates. A release workflow builds the Claude.ai zip from source so it can't drift.
- **Examples.** Nine now, up from six: annotated code review, design-token sheet, and incident post-mortem are new. All nine pass the skill's own rules, including keyboard support and both themes, and were rendered headless before shipping.

## Install

### Claude Code (recommended)

```
/plugin marketplace add dogum/html-artifacts
/plugin install html-artifacts@html-artifacts
```

Updates arrive with `/plugin update`.

### Claude.ai, Cowork, cloud sessions

1. Download `html-artifacts.skill` from the [latest release](https://github.com/dogum/html-artifacts/releases/latest).
2. Open Claude.ai → Settings → Capabilities → Skills.
3. Upload the file. Re-upload to update.

### Manual, or any Agent Skills-compatible runtime

```bash
git clone https://github.com/dogum/html-artifacts.git
cp -r html-artifacts/skills/html-artifacts ~/.claude/skills/
```

The folder containing `SKILL.md` is what loads. The frontmatter uses only [Agent Skills](https://agentskills.io) spec fields, so it works outside Claude too.

## What this skill does

Markdown is fine for chat replies, code snippets, and quick summaries. It's a poor format for content that benefits from spatial layout, color, real diagrams, interactivity, or a round-trip editor. This skill teaches Claude to recognize when a task is in the second bucket, produce a single self-contained `.html` file, check it, and hand it over.

It is not "always answer in HTML." There is an explicit carve-out for short replies, code-only outputs, terminal-style answers, disposable summaries, and files that live in git. The evals hold the skill to that.

## How it's structured

```
.claude-plugin/
├── plugin.json                         # plugin manifest
└── marketplace.json                    # lets /plugin marketplace add dogum/html-artifacts work
skills/html-artifacts/
├── SKILL.md                            # recognition, carve-outs, universal rules, workflow, index
└── references/
    ├── exploration-and-planning.md     # side-by-side comparisons, implementation plans
    ├── code-review-and-pr.md           # annotated diffs, PR writeups, module maps
    ├── design-and-prototypes.md        # design tokens, component sheets, animation prototypes
    ├── diagrams-and-illustrations.md   # inline SVG figures, flowcharts
    ├── data-and-charts.md              # SVG charts, sortable tables, dashboards        (new)
    ├── reports-and-research.md         # status reports, post-mortems, concept explainers
    ├── decks.md                        # arrow-key slide presentations
    ├── custom-editors.md               # throwaway editing UIs that round-trip back to text
    ├── matching-your-style.md          # taste, baseline CSS, design-system-from-codebase trick
    ├── accessibility-and-print.md      # the baseline every artifact meets                (new)
    ├── harness-mechanics.md            # per-surface rules: Claude Code, Claude.ai, Cowork (new)
    └── verify-before-delivering.md     # headless check, or the read-through fallback    (new)
evals/                                  # claude plugin eval cases; see evals/README.md
docs/                                   # GitHub Pages site and the nine examples
scripts/
├── build-skill.sh                      # builds the Claude.ai zip from skills/
├── check-examples.sh                   # static checks against the universal rules
└── verify-example.mjs                  # Playwright render at three viewports
```

`SKILL.md` is always in context when the skill triggers. References load only when relevant; most artifacts need one or two.

## Evals

```bash
claude plugin eval . --allow-tools Write
```

Runs each case three times with the skill and three without, and reports the delta. See [`evals/README.md`](evals/README.md) for the cases, the graders, and how to add one. The CI workflow is manual (`workflow_dispatch`) because each run makes real model calls.

## How this addresses Thariq's worry

In the original post, Thariq writes:

> I'm a little bit afraid that people will read this article and turn it into a /html skill or something. While there might be some value in that, I want to emphasize that you don't need to do much to get Claude to do this.

That worry is legitimate, and it's the reason 2.0 looks the way it does:

- The recognition heuristic is about *when* HTML helps, and the "stay in markdown" list is as long as the "reach for HTML" list.
- The should-not-trigger evals exist to catch the skill turning a two-sentence question into a page.
- `references/matching-your-style.md` heads off the default-AI look with a list of tells to avoid and a baseline CSS that doesn't lean on card grids.
- The verify rule means an ugly or broken artifact gets caught by the model, not by the reader.

If the defaults still produce output you don't like, fork it, or put a `design-system.html` next to your project and the skill will read it first.

## Examples

Each is a single `.html` file produced by the skill from the prompt shown. View them on the [site](https://dogum.github.io/html-artifacts/) or open `docs/examples/` directly.

| Pattern | Prompt | File |
|---|---|---|
| Side-by-side comparison | "Compare three ways to do SSE streaming in a Hono backend" | [`01-sse-comparison.html`](docs/examples/01-sse-comparison.html) |
| Concept explainer with live demo | "Explain how a quarter-car model computes IRI from a road profile" | [`02-iri-explainer.html`](docs/examples/02-iri-explainer.html) |
| Custom editor with export | "Triage these 8 tickets into Now/Next/Later/Cut, copy-as-markdown export" | [`03-triage-editor.html`](docs/examples/03-triage-editor.html) |
| Weekly status report | "Write the platform team's weekly status report" | [`04-status-report.html`](docs/examples/04-status-report.html) |
| Annotated flowchart | "Diagram our deploy pipeline with happy path and failure paths" | [`05-flowchart.html`](docs/examples/05-flowchart.html) |
| Slide deck | "Make a short deck on the case for HTML over markdown" | [`06-deck.html`](docs/examples/06-deck.html) |
| Annotated code review | "Review this PR: add retry with backoff to the API client" | [`07-code-review.html`](docs/examples/07-code-review.html) |
| Design-token sheet | "Lay out our design tokens as a reference page" | [`08-design-tokens.html`](docs/examples/08-design-tokens.html) |
| Incident post-mortem | "Write up yesterday's search latency outage as a post-mortem" | [`09-postmortem.html`](docs/examples/09-postmortem.html) |

Made something with the skill you're proud of? [Open a gallery issue](https://github.com/dogum/html-artifacts/issues/new?template=gallery.yml).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Short version: change the skill, run the static checks and the Playwright render, and if you touched triggering behaviour, run the evals.

## Acknowledgments

This skill is a direct response to [Thariq Shihipar](https://x.com/trq212)'s [*The Unreasonable Effectiveness of HTML*](https://thariqs.github.io/html-effectiveness/) and its companion site. The categories, the recognition framing, and several of the example shapes come from his examples. The recognition heuristic, the carve-outs, the verification rule, and the evals are extensions.

Version 1 was authored with Anthropic's [skill-creator](https://github.com/anthropics/skills) workflow; version 2 was tested with [`claude plugin eval`](https://code.claude.com/docs/en/plugin-evals).

## License

Apache 2.0. See [`LICENSE`](LICENSE).
