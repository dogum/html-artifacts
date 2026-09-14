# Custom Editors

The most distinctive use of the format. The user has a one-off task — triage 30 tickets, tune a regex, reorder steps in a flow, curate a dataset, pick exact easing values — and a text-box prompt is the wrong shape for it. Build a throwaway editor: a single HTML file, purpose-built for the one task, that always ends with an export button.

## The non-negotiable rule

**Every editor must end with an export.** "Copy as markdown," "copy as JSON," "copy as prompt," "download as CSV" — whatever turns the UI state into something the user can paste back into Claude Code, into a commit, into a Linear comment, into the next prompt. Without the export, the editor is a toy. With it, the editor closes the loop and the user stays in control.

If you find yourself making an editor without an export path, stop. Add the export *first*, then build the rest.

## When to build a custom editor

The signal: the user is trying to express something that's hard to type in a chat.

- Reordering / triaging / bucketing many items (tickets, test cases, support emails, todos).
- Editing structured config with constraints (feature flags, env vars, JSON/YAML where some keys depend on others).
- Tuning prompts or templates with live preview against sample inputs.
- Curating a dataset: approve/reject, tag, label.
- Annotating something: a transcript, a diff, a screenshot.
- Picking values that are painful to express in text: colors, easing curves, crop regions, cron schedules, regex with live test strings.

If the task is one-off and the input is structured, this pattern fits.

## Layout

- The work area is the dominant focus. Header, controls, and export sit around it.
- A short header: what this editor is for, in one sentence.
- The pre-loaded data (if any) ready to manipulate. Don't make the user paste their own input — accept it as part of the prompt and have it pre-filled.
- The interaction primitives appropriate to the data: drag-and-drop for ordering, toggles for booleans, selects for enums, sliders for ranges, text inputs for strings.
- A live "current state" indicator: how many items in each bucket, character count, validation errors visible immediately.
- The export bar at the bottom: one or more buttons that produce the user's chosen output format. Often: "Copy as markdown" + "Copy as JSON" + "Reset."
- Optional: an undo/redo stack. Worth it for editors with many small actions.

## What's load-bearing

- **The export, again.** Without it, nothing else matters.
- **Pre-filled data.** The user already gave you the data in the prompt. Don't make them type it twice.
- **Constraints visible.** If toggling flag A requires flag B, show the warning at the moment of the conflict, not as a footer disclaimer.
- **State persistence within the session.** If the user accidentally refreshes, they shouldn't lose 30 minutes of triage. For a file opened from disk, `localStorage` is fine and worth using. In a Claude.ai artifact, storage may be blocked or empty: keep state in memory, wrap every storage read and write in `try/catch`, and never make the page depend on it. (Details in `harness-mechanics.md`.)
- **Keyboard support, always.** If the user is going to label 100 examples, they need `j`/`k` or `1`/`2`/`3`, not just clicks. And every drag-and-drop needs a keyboard path (select an item, arrow keys or number keys to move it) or the editor is unusable for keyboard and screen-reader users. List the shortcuts on the page.
- **Export shows the text, too.** Clipboard access can fail in sandboxed iframes. The export button copies *and* reveals the text in a `<textarea>` the user can select by hand. Never rely on a download link; script-started downloads are blocked on several surfaces.

## Common mistakes

- **Making it generic.** This is a *throwaway* tool for *this* task. Don't build a "task management system" — build the triage board for *cycle 14's* 24 specific tickets.
- **Skipping the export.** Already mentioned. Skipping it again because it's the most common failure mode.
- **Adding settings.** Settings are for products. This isn't a product, it's a tool.
- **Server-style state.** No backend, no API, no auth. Everything in one file, everything in memory.
- **Pretty over usable.** A custom editor is judged by whether the user can finish their task and leave. Make it fast and direct.

## Three example shapes

### Triage board

Drag tickets across columns (Now / Next / Later / Cut), pre-sorted. Export = markdown with one bucket per heading and a one-line rationale per ticket.

```html
<main>
  <header>
    <h1>Cycle 14 triage</h1>
    <p>24 tickets, pre-sorted into a best guess. Drag until the cut feels right,
       then copy out as markdown.</p>
  </header>

  <div class="board">
    <section class="col" data-bucket="now"><h2>Now</h2><ul></ul></section>
    <section class="col" data-bucket="next"><h2>Next</h2><ul></ul></section>
    <section class="col" data-bucket="later"><h2>Later</h2><ul></ul></section>
    <section class="col" data-bucket="cut"><h2>Cut</h2><ul></ul></section>
  </div>

  <footer>
    <span id="counts" aria-live="polite">Now 6 · Next 8 · Later 7 · Cut 3</span>
    <button id="reset">Reset</button>
    <button id="copy-md">Copy as markdown</button>
  </footer>

  <script>
    const tickets = [/* pre-filled from the prompt */];
    /* render, drag-drop with HTML5 DnD, keep state in a Map */
    /* keyboard: j/k move focus, 1-4 move focused ticket to a bucket */
    /* on copy-md: ## Now\n- TICK-101: short title\n... */
  </script>
</main>
```

### Feature flag editor

Toggles grouped by area; warnings when a prerequisite is off; export = the diff against the input config, just the changed keys.

```html
<main>
  <h1>Feature flags — staging</h1>

  <fieldset>
    <legend>Checkout</legend>
    <label><input type="checkbox" data-key="checkout.express"> Express checkout</label>
    <label><input type="checkbox" data-key="checkout.applePay" data-requires="checkout.express">
      Apple Pay <span class="warn" hidden>requires Express checkout</span></label>
  </fieldset>
  <fieldset><legend>Search</legend>...</fieldset>

  <footer>
    <button id="copy-diff">Copy diff</button>
  </footer>
</main>
```

### Prompt tuner

Editable template on the left with `{{variable}}` slots highlighted; sample inputs on the right that re-render the filled prompt live; character/token counter; copy.

```html
<main class="split">
  <section class="editor">
    <h2>Prompt template</h2>
    <textarea id="tmpl">You are a {{role}}. Given {{input}}, respond with...</textarea>
  </section>
  <section class="preview">
    <h2>Filled samples</h2>
    <article><h3>Sample 1</h3><pre id="out-1"></pre></article>
    <article><h3>Sample 2</h3><pre id="out-2"></pre></article>
    <article><h3>Sample 3</h3><pre id="out-3"></pre></article>
    <p><span id="chars">0 chars</span> · <span id="tokens">~0 tokens</span></p>
    <button id="copy">Copy filled prompt</button>
  </section>
</main>
```

In all three: pre-filled, focused, exportable. That's the pattern.
