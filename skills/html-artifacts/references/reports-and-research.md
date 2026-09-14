# Reports, Research & Explainers

Recurring documents — status updates, post-mortems, deep dives — benefit most from a bit of structure and color. People read them when they're scannable; they ignore them when they're walls of text.

## Concept explainer (for learning a new topic)

For "explain consistent hashing to me" or "how does our rate limiter actually work."

**Layout**
- Title, subtitle, and a *one-paragraph* TL;DR before any technical content. The reader should know what they're about to learn in 15 seconds.
- The "trick" or the core insight, stated as a single sentence with the most important word emphasized.
- A **live interactive demo** if the concept is the kind that benefits from manipulation (sharding, hashing, scheduling, queuing, anything geometric or stateful). Click/drag/slider that lets the reader cause the system to rearrange itself.
- A comparison table: this approach vs. the obvious naive approach, with concrete metrics.
- "Where you'll meet it" — real systems that use this. Grounds it in things the reader knows.
- A glossary, ideally **in the margin** with hover-link cross-refs from terms in the body text.
- Tabbed code samples for languages/frameworks the reader might use.

**What's load-bearing**
- The live demo. For concepts that have a spatial or stateful character, a five-second interaction beats five paragraphs of prose.
- Marginal glossary, not a glossary at the bottom. Bottom glossaries are never read; marginal ones are scanned.
- Comparison to the naive approach with numbers, not adjectives. "Better" is meaningless; "moves 1/N keys instead of (N-1)/N" is meaningful.

**Common mistakes**
- Treating it as a Wikipedia-style overview. The reader has a question — answer it sharp, then expand.
- Burying the punchline. The TL;DR should give away the answer.
- Skipping the demo because "the user can imagine it." They cannot. That's why they're reading the explainer.

## Feature explainer (for understanding code in a repo)

For "how does our auth flow work" or "explain rate limiting in this codebase."

**Layout**
- TL;DR box at the top: what it does, where it lives, key files.
- Collapsible sections for each phase of the request/feature lifecycle. Default-collapsed for the deep stuff, default-open for the overview.
- Tabbed code snippets — same logic in TypeScript, in Python, in the test, in the config. Tabs save vertical space.
- An FAQ at the bottom for the questions readers always ask after reading.
- "Where to look next" links into the codebase.

**What's load-bearing**
- Collapsibles. Code explainers are dense; let the reader expand only what they need.
- Code with annotations, not bare code blocks. The interesting lines deserve callouts.
- The FAQ. It's where the reader's actual questions live.

## Status report / weekly update

For "summarize what shipped this week."

**Layout**
- Title with the week, team, author.
- Top section: shipped / in flight / blocked, in three visually distinct columns or rows. Color-coded.
- Each item is one line with a link to the PR/ticket. Add a sentence of context only if the item needs explanation.
- A small chart somewhere — even a sparkline. Recurring reports get skimmed; a chart is a thing the eye lands on. Draw it in SVG (`data-and-charts.md`); no library.
- "Asks": specific things the author needs from the reader. Calls to action, separated visually.
- A footer: timestamp, "ping me with questions," contact.

**What's load-bearing**
- Brevity per item. A status report is read in 90 seconds or not at all. One line per item.
- Color-coded status. Shipped/in flight/blocked should be distinguishable at a glance.
- Asks separated. They get lost when intermixed with status.

## Incident report / post-mortem

For "write up the outage from yesterday."

**Layout**
- Header: incident name, severity, total duration, customer impact in a single concise summary.
- A **minute-by-minute timeline** as a vertical column with timestamps on one side and events on the other. This is the spine of the document.
- Log excerpts inline at the timestamps where they matter, in a `<pre>` block, color-coded by source/severity.
- Root cause: separate section, written for the audience that wasn't paying attention to the timeline.
- "What worked" — what made detection/response faster than it could have been.
- "What didn't" — what made it slower or worse.
- Follow-up action items as a checklist with owners and deadlines. Not a wishlist; commitments.

**What's load-bearing**
- The timeline as a real visual timeline, not a numbered list. The reader needs to see the pace — long flat stretches followed by clusters of activity.
- Action items with owners. Without owners, follow-ups don't happen.
- "What worked" alongside "what didn't." Post-mortems become punitive without it; they become educational with it.

**Common mistakes**
- Skipping the customer impact summary. Leadership reads only that and the action items.
- Burying timestamps. Every timeline event needs a clock.

## Example sketch — concept explainer with live demo

```html
<main class="explainer">
  <header>
    <h1>Consistent hashing, in one ring</h1>
    <p class="tldr">N caches, K keys. Add or remove a node and only ~K/N keys move
       — instead of ~all of them with hash mod N. Here's why.</p>
  </header>

  <section>
    <h2>The trick: hash onto a circle, not a line</h2>
    <p>Map both nodes and keys onto the same ring...</p>

    <figure class="live-demo">
      <svg id="ring" viewBox="0 0 400 400"><!-- ring rendered live --></svg>
      <div class="controls">
        <label>nodes <input type="range" id="nodes" min="2" max="12" value="4"></label>
        <label>keys  <input type="range" id="keys"  min="8" max="64" value="32"></label>
        <button id="remove">Remove a node</button>
        <button id="add">Add a node</button>
        <button id="reset">Reset</button>
      </div>
      <p class="readout">4 nodes · 32 keys · — moved on last change</p>
    </figure>
  </section>

  <section>
    <h2>Versus hash mod N</h2>
    <table class="compare">...</table>
  </section>

  <aside class="glossary">
    <dl>
      <dt>Ring</dt><dd>The hash output range, treated as a circle.</dd>
      <dt>Arc</dt><dd>The stretch of ring a node owns.</dd>
      ...
    </dl>
  </aside>
</main>
```
