# Diagrams & Illustrations

Inline SVG gives the agent a real pen. The output is vector art the user can tweak by hand and copy out. Don't fall back to ASCII or "imagine a flowchart that…" prose — render it.

## Figure sheet for a post or doc

For "make me the diagrams for this article" or "draw the figures I'll use in the writeup."

**Layout**
- One figure per section, each in its own `<figure>` with a caption.
- Each figure is inline `<svg>`, sized for both light and dark backgrounds (use CSS variables or `currentColor`).
- A "copy SVG" button below each figure. The whole point is that the user pastes them into their real document.
- Consistent visual language across figures: same line weight, same arrowhead style, same palette, same type face. They should look like a set.

**What's load-bearing**
- Visual consistency across the set. A scattered visual language reads as amateurish even if each figure is fine on its own.
- Copy buttons per figure. Without them the user has to view-source. With them this is a usable workflow.
- Sizing that survives reuse: don't hard-code colors that won't work in the destination doc.

## Annotated flowchart

For "diagram our deploy pipeline" or "show me how a request flows through the system."

**Layout**
- The flowchart as inline SVG, drawn properly: nodes with labels, edges with directionality, branching paths visually distinct from the main path.
- Click any node to expand a side panel with: what runs there, expected duration, what failure looks like, links to source.
- Highlight the **happy path** in a distinct color; failure/retry paths in a muted secondary color.
- A legend in the corner.

**What's load-bearing**
- Click-to-expand. The flowchart is the navigation, the panel is the content. Don't try to fit everything on the chart itself. Nodes are focusable (`tabindex="0"`) and open on Enter as well as click.
- Happy path highlight. Most of the time the reader cares about the common case; let them tune out the edges initially.
- Direction indicators on edges. Without arrows, a flowchart is just a graph.

**Common mistakes**
- Auto-layout via Mermaid that produces a tangled mess. If the layout is bad, hand-place the nodes. SVG positions are just numbers.
- Drawing every possible edge case. A flowchart with 40 nodes is unreadable; abstract the rare branches into a single "error handling" subgraph.
- Using only color to distinguish states. Use shape *and* color so it survives colorblind viewing and grayscale printing.

## SVG craftsmanship notes

For both figure sheets and flowcharts:

- **Use `viewBox`, not fixed `width`/`height`.** Lets the figure scale.
- **Use `currentColor` for ink** where possible. Lets the figure inherit text color and adapt to dark mode.
- **Round numbers.** `x="120"` not `x="119.7843"`. Easier for a human to tweak by hand.
- **Group with `<g>` and label.** A user editing the SVG needs to find things by structure, not coordinates.
- **Type set in SVG, not as `<text>`-rendered-as-paths.** Selectable, copyable, accessible.
- **No raster fallbacks.** If a thing can be drawn, draw it. PNGs of diagrams defeat the whole purpose.

## Example sketch — labeled flow

```html
<figure>
  <svg viewBox="0 0 600 200" role="img" aria-labelledby="title">
    <title id="title">Request lifecycle</title>
    <defs>
      <marker id="arrow" viewBox="0 0 10 10" refX="8" refY="5"
              markerWidth="6" markerHeight="6" orient="auto">
        <path d="M0,0 L10,5 L0,10 z" fill="currentColor"/>
      </marker>
    </defs>

    <g class="node" data-step="ingress">
      <rect x="20" y="80" width="120" height="40" rx="6"
            fill="none" stroke="currentColor"/>
      <text x="80" y="105" text-anchor="middle">ingress</text>
    </g>
    <g class="node" data-step="auth">
      <rect x="180" y="80" width="120" height="40" rx="6"
            fill="none" stroke="currentColor"/>
      <text x="240" y="105" text-anchor="middle">auth</text>
    </g>
    <line x1="140" y1="100" x2="180" y2="100"
          stroke="currentColor" marker-end="url(#arrow)"/>
    ...
  </svg>
  <figcaption>Happy-path request flow. Click any step for details.</figcaption>
  <button onclick="copySvg(this)">Copy SVG</button>
</figure>
```
