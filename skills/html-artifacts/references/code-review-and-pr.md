# Code Review & PR Writeups

Diffs and call graphs are spatial information; markdown flattens them. Render the code as it actually wants to be read.

## Annotated diff (for review)

For "review this PR" or "look over this change."

**Layout**
- Title with the PR/branch name and a one-line summary.
- A short framing block: motivation, "where to focus the review."
- The diff itself, rendered with `+`/`-` line styling, syntax highlighting, and **margin annotations** — small numbered notes pinned to specific lines, not interleaved into the code.
- Severity tags inline: `blocking`, `nit`, `question`, `praise`. Color-coded *and* worded, so they survive grayscale and screen readers.
- Jump links at the top to skip to the annotated regions.
- File-by-file collapsible sections if the diff spans more than ~3 files.

**What's load-bearing**
- Margin annotations, not interleaved comments. Interleaved comments break the visual flow of the diff and you lose the ability to read the code as code. Margin notes preserve both.
- Severity color-coding. Reviewers scan for red first; help them.
- The "where to focus" framing. Reviewers don't have time for everything; tell them what matters.

**Common mistakes**
- Repeating the entire diff with `<pre>` blocks and explanations between every chunk. That's a markdown article, not a review. The diff is the spine; the annotations attach to it.
- Adding emoji-decorated bullet lists of suggestions. Pin them to the lines they refer to.

## PR writeup (for the author posting)

For "write the description for this PR."

**Layout**
- Title: short, imperative ("Add streaming support to /chat endpoint").
- Motivation: why this exists. 2–3 sentences.
- Before/after: a real visual comparison if there's any UI or output change.
- File-by-file tour: for each significant file, the *why* of the change in one or two sentences. Not a list of every change — the shape.
- "Where to focus the review": which parts the author actually wants eyes on.
- Risks / things that could go wrong / how it was tested.
- Open questions for reviewers (if any).

**What's load-bearing**
- Before/after as actual side-by-side, not "before: X, after: Y" prose.
- The file-by-file tour grouped by *theme* of change, not alphabetical order. "Plumbing" / "core logic" / "tests" / "docs."
- "Where to focus" — saves reviewer time, signals you've thought about it.

## Module map / "explain this code"

For "I'm new to this package, walk me through it" or "what does this module do."

**Layout**
- Top: a single-sentence summary of what the package does.
- Below: a boxes-and-arrows diagram (inline SVG) of the modules and how they call each other. Highlight the **hot path** — the most common call sequence — in a distinct color.
- Entry points called out explicitly: "If you're trying to do X, start at Y."
- Per-module cards below the diagram with: what it does (one line), key types/functions, gotchas.
- A "data lifecycle" trace: pick one realistic input, show how it flows through.

**What's load-bearing**
- The diagram. The whole point is that you can see the shape at a glance.
- The hot path highlight. Most readers care about the common case; help them ignore the edges first.
- Entry points by use case ("if you want to do X..."). Code is rarely read top-to-bottom; help the reader find their way in.

**Common mistakes**
- Drawing every relationship between every file. The diagram becomes a hairball. Show the structural relationships, not the textual ones.
- Treating it as documentation generation. It's an explainer, not API docs.

## Example sketch — annotated diff

```html
<main class="diff-view">
  <header>
    <h1>PR #482: Streaming support for /chat</h1>
    <p>Author: greg · 4 files · +287 −41</p>
    <nav class="jump-links">
      <a href="#ann-1">🟥 #1 backpressure</a>
      <a href="#ann-2">🟨 #2 cleanup</a>
    </nav>
  </header>

  <section class="file" id="file-handler">
    <h2>src/chat/handler.ts</h2>
    <div class="diff">
      <div class="line ctx">  function handleChat(req) {</div>
      <div class="line add">+   const stream = createStream(req);</div>
      <div class="line add" data-annotation="1">+   return pipeBackpressure(stream);</div>
      <div class="line ctx">  }</div>
    </div>
    <aside class="annotation" id="ann-1">
      <span class="severity blocking">🟥 blocking</span>
      <p>pipeBackpressure swallows errors silently when the consumer drops. Need to propagate up.</p>
    </aside>
  </section>
</main>
```
