---
name: html-artifacts
description: Produce a self-contained HTML artifact instead of a markdown document when the content benefits from spatial layout, color, real diagrams, interactivity, or a round-trip editor. Use when the user asks for a "doc," "writeup," "plan," "spec," "report," "explainer," "comparison," "review," "PR description," "mockup," "diagram," "flowchart," "deck," "slides," "status update," "post-mortem," "dashboard," "chart," "playground," or a one-off "editor" or "tool" for triaging, reordering, or tuning something, even without saying "HTML" or "artifact." Also when asked to "explain," "compare," "explore options for," or "walk through" a non-trivial topic. Always use it when the deliverable is an .html file or a web page, even if the user names the file or asks for HTML directly; the skill is how the page gets checked, not just written. Stay in markdown for short replies, code-only answers, terminal-style instructions, and anything the reader will read once and discard.
license: Apache-2.0
metadata:
  version: "2.0.0"
  homepage: https://dogum.github.io/html-artifacts/
---

# HTML Artifacts

Markdown is the default agent output. For anything longer than a handful of sentences it is a poor one: it cannot put two options side by side, draw a real diagram, be interactive, or be shared as a page. When the artifact *is* the deliverable, the reader will do something with it: read it carefully, share it, hand it to an implementer, paste edits back. Make it HTML.

The skill is a judgment call, not a format switch. Most of what follows is about deciding well and then checking the result, because the model already knows how to write HTML.

## Reach for HTML when any of these hold

- **Comparison.** Two or more options the reader must weigh. Side by side beats stacked.
- **Spatial information.** Diffs, call graphs, module maps, flowcharts, timelines, before/after. Position carries meaning.
- **Interaction matters.** Easing curves, parameter tuning, state machines, simulations. Things the reader needs to *feel*.
- **Reference material.** Navigated non-linearly: tabs, collapsibles, a glossary in the margin, jump links.
- **Color or hierarchy carries meaning.** Severity, status, syntax, design tokens, data series.
- **Data.** More than a dozen numbers, a trend, a distribution. A table with sort and filter, or a chart.
- **One-off editor.** The reader manipulates a thing (drags tickets, toggles flags, tunes a prompt) and needs the result back as text.
- **It will be shared.** A spec to leadership, a PR writeup to reviewers, a report to a team. People read pages; they skim files.
- **Length.** Past roughly 100 lines of markdown, navigation and layout earn their keep.

## Stay in markdown when

- The reply is conversational, or the answer is a few sentences. One question, one answer, done.
- The output is code, a config block, a command sequence, or a diff the user will apply.
- The user is iterating fast on something disposable ("just summarize this file", "what does this function do").
- The document will live in git and be diffed in PRs over time. HTML diffs are noisy. Offer an HTML *view* alongside if review would benefit.
- The user asked for markdown, a specific format, or "no formatting."

If unsure, ask one question of yourself: *will the reader do anything with this beyond reading it once?* If not, markdown. HTML costs two to four times the tokens and takes longer; don't manufacture a use case.

## Universal rules

Every artifact must satisfy all of these.

1. **One self-contained `.html` file.** CSS in `<style>`, JS in `<script>`, images as inline SVG or data URIs. No build step. External scripts only from the CDNs the target surface allows (see `references/harness-mechanics.md`), and only when a library genuinely earns its place.
2. **Readable in five seconds.** A `<title>`, a heading, and a one-paragraph framing sentence or TL;DR before any substance.
3. **Real layout, not translated markdown.** A comparison gets columns. A timeline gets drawn. A diff renders as a diff. If the page is headings and paragraphs, it should have been markdown.
4. **Tasteful by default.** Calm typography, 60 to 75 characters per line, restrained color that carries meaning. No gradient heroes, no emoji headings, no card grids for their own sake. `references/matching-your-style.md` has the baseline CSS and the list of tells to avoid.
5. **Works at phone width and in both themes.** Viewport meta, relative units, layouts that wrap. Define light tokens on `:root`, redefine them under `prefers-color-scheme: dark` and under `[data-theme="dark"]` so both system preference and a manual toggle work.
6. **Accessible baseline.** Semantic elements, labelled controls, keyboard-reachable interactions, visible focus, color never the only signal. `references/accessibility-and-print.md` has the checklist.
7. **Editors export back to text.** Non-negotiable. Anything with manipulable state ends with "copy as markdown / JSON / prompt." The round trip is the point.
8. **Verify before delivering.** If a browser is available (Playwright or Chromium in Claude Code, Cowork, or a cloud session), render the file headless, screenshot it at desktop and phone width, check the console for errors, and fix what you see. If no browser is available (Claude.ai chat, an artifact-only surface, no shell), do not stall or apologize: run the read-through checklist in `references/verify-before-delivering.md` instead and deliver. Either way, the artifact is checked once before the user sees it.

## Workflow

1. **Decide.** Run the two lists above. Say in one line what you're making and why HTML.
2. **Pick the reference.** Read the matching file from the index below. They are short; read two if the request spans categories.
3. **Match the user's style.** If the project has a design system, tokens, or a frontend-design skill, use it. Otherwise use the baseline in `references/matching-your-style.md`.
4. **Draft.** Layout first, then content, then interaction. Pre-fill any data the user gave you.
5. **Verify.** Rule 8. Fix, then deliver with the path or the artifact and one sentence on what it is.

## Category index

| If the request is about… | Read… |
|---|---|
| Option comparisons, implementation plans, exploring directions before committing | `references/exploration-and-planning.md` |
| Annotated diffs, PR writeups, code review, module maps, "explain this code" | `references/code-review-and-pr.md` |
| Design tokens, component sheets, mockups, animation and interaction prototypes | `references/design-and-prototypes.md` |
| Inline SVG figures, flowcharts, architecture diagrams | `references/diagrams-and-illustrations.md` |
| Charts, dashboards, sortable and filterable data tables, metrics | `references/data-and-charts.md` |
| Status reports, incident post-mortems, concept explainers, learning material | `references/reports-and-research.md` |
| Slide decks, arrow-key presentations | `references/decks.md` |
| One-off editors: triage boards, flag toggles, prompt tuners, labelers | `references/custom-editors.md` |
| Matching an existing visual style or design system; the safe default | `references/matching-your-style.md` |
| Accessibility and print checklist | `references/accessibility-and-print.md` |
| Where the file goes and what each surface allows: Claude Code, Claude.ai artifacts, Cowork, published artifacts | `references/harness-mechanics.md` |
| The pre-delivery check, headless and manual | `references/verify-before-delivering.md` |

## Output mechanics, briefly

- **On disk (Claude Code, Cowork, cloud sessions):** save a descriptive `kebab-case` name with `.html` in the working directory, verify, then give the user the path and how to open it. Related artifacts go in one folder.
- **Claude.ai artifacts:** one HTML artifact, not React, unless asked. Respect the artifact sandbox: allowed CDNs only, storage treated as unreliable, no relative links.
- **Published or shared artifacts:** may have runtime capabilities (persistence, live data). Use them only when the surface documents them; never assume.

Details, per surface, in `references/harness-mechanics.md`.

## What this skill is not

It is not "always answer in HTML." Where markdown is the better medium, use markdown. Bad-looking HTML is worse than good markdown, and unverified HTML is worse than either.
