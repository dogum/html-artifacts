# Exploration & Planning

For when the user is trying to *decide* something and needs to weigh options, or has decided and needs a plan dense enough to hand off.

## Side-by-side option comparison

The single biggest win HTML has over markdown. Three approaches in markdown is three sequential sections the reader has to hold in their head simultaneously. Three approaches in HTML is three columns next to each other.

**Layout**
- One column per option (or one card per option in a responsive grid for 4+ options).
- Each column has the same internal structure — same heading order, same sub-sections — so the reader can scan horizontally to compare.
- Inside each column: a short framing sentence, the actual artifact (code snippet / mockup / sketch), a Pro/Con table, and a row of hard metrics.
- A recommendation block at the bottom that picks one and explains why. Not "it depends" — actually pick.

**What's load-bearing**
- The pro/con as a *two-column table*, not a bulleted list. Bullets read as a sequence; a table reads as a comparison.
- The hard metrics row at the bottom of each option (bundle size, complexity, testability, "SSR safe?", whatever's relevant). Numbers force the recommendation to be defensible.
- Identical structure across columns. If approach 1 has a "Reuse" metric and approach 2 doesn't, the reader assumes approach 2 is bad at reuse — even if you just forgot to fill it in.

**Common mistakes**
- Putting all the code in one block at the top and the comparison underneath. The whole point is that the code is *part* of the comparison.
- Refusing to recommend. If the request was "show me three ways," the user wants to pick one — help them.
- Three approaches that are actually one approach with minor variations. If they share 80% of the code, it's one approach with parameters.

## Visual design exploration

For "I'm not sure what direction to take this UI." Generate 4–6 *meaningfully different* directions in a single grid. Vary layout, density, tone, palette — not just font size.

**Layout**
- Grid of mini-mockups, each with a short caption explaining what tradeoff it's making ("dense, info-first" vs "calm, single-task focus").
- Each mockup is a real rendered HTML region, not a screenshot — the user can resize the browser to see how it responds.
- Optional: clicking a mockup opens it full-width to inspect details.

**Common mistakes**
- Six variations of the same layout with different colors. Vary the *layout*, the *information hierarchy*, and the *interaction model* before varying surface treatment.
- All six look like the default Tailwind dashboard. Push for distinct directions; one of them should feel almost wrong, to anchor the others.

## Implementation plan

When the user has decided what to build and needs a plan dense enough to hand to an implementer (human or another agent).

**Layout**
- Title and a one-paragraph problem statement.
- A milestones strip at the top — visual timeline with phases, not a numbered list.
- A data-flow diagram (inline SVG) showing what talks to what.
- Inline mockups for any UI being touched.
- The "risky code" — the 2–3 snippets that are load-bearing, with annotations on the tricky lines.
- A risk table: risk / likelihood / mitigation.
- Print-friendly. Plans get printed for meetings; see `accessibility-and-print.md`.
- A "what we're explicitly not doing" section. Equally important.

**What's load-bearing**
- The data-flow diagram. Don't skip it. If the system has more than two components, the reader cannot hold the topology in their head from prose alone.
- The risk table. Risks expressed as paragraphs disappear; risks in a table get addressed.
- The "not doing" section. It prevents scope creep before it starts.

**Common mistakes**
- Treating this as a markdown plan with HTML wrapping. Use the format. Render the timeline as a timeline; render the data flow as a diagram.
- Listing every file that will be touched. The reader doesn't need that — they need the shape of the change.

## Example sketch

A three-approach comparison, structurally:

```html
<main>
  <header>
    <h1>Three ways to implement debounced search</h1>
    <p>Prompt that produced this · which option I'd pick</p>
  </header>

  <section class="grid grid-cols-3">
    <article>
      <h2>01. Inline useEffect + setTimeout</h2>
      <p>One-line summary of the approach.</p>
      <pre><code>...the code...</code></pre>
      <table class="pros-cons">
        <tr><th>Pro</th><th>Con</th></tr>
        <tr><td>Zero abstraction</td><td>Logic duplicated</td></tr>
        ...
      </table>
      <dl class="metrics">
        <dt>Bundle</dt><dd>+0kb</dd>
        <dt>Reuse</dt><dd>low</dd>
      </dl>
    </article>
    <article>...02...</article>
    <article>...03...</article>
  </section>

  <footer>
    <h2>Recommendation</h2>
    <p>Go with 02 — here's why...</p>
  </footer>
</main>
```
