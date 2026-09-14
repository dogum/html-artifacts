# Design & Prototypes

HTML *is* the medium design ships in (eventually, even when the surface is React or Swift). That makes it the natural format for talking *about* design. It's also the only honest way to prototype motion and interaction.

## Living design system

For "show me our design tokens" or "lay out our color/type/spacing system."

**Layout**
- Section per token category: colors, typography, spacing, radii, shadows, motion.
- Each token rendered as itself: colors as swatches, type as actual rendered text at the actual scale, spacing as visible gaps with labels, shadows as shadow examples on a card.
- Each swatch / specimen has a "copy" button that copies the token's name (`--color-accent-500`) or value (`#5B6CFF`) to clipboard. Both, ideally — value on click, name on shift-click, or two buttons.
- Pulled from the codebase if possible. Read the CSS / Tailwind config / theme file rather than making up plausible-looking tokens.

**What's load-bearing**
- Rendering tokens as themselves. A `#5B6CFF` next to a swatch is way better than `#5B6CFF` alone.
- Copy buttons. The artifact is half-reference, half-tool. The copy action is the whole point.
- Source-of-truth fidelity. If the artifact diverges from the actual tokens, it's worse than nothing.

## Component variants sheet (contact sheet)

For "show me every variant of our button/input/card."

**Layout**
- One component, every state on a single page: sizes × intents × states (hover, focus, disabled, loading, error).
- Group by axis: a row per size, columns per intent; or vice versa.
- Render the *real* component (or the closest HTML/CSS approximation) — not a screenshot, not a description.
- Underneath each variant: the props used to produce it.

**Common mistakes**
- Skipping the "weird" states (loading, empty, error). Those are exactly the states design systems forget to specify and engineering ad-libs.
- Mixing components on one page. One component per sheet. Multi-component pages turn into a tour, which is a different format.

## Animation/interaction prototype

For "I want to play with this animation/transition before wiring it in."

**Layout**
- The thing being animated, in isolation, big and centered.
- Sliders and toggles for every parameter that matters: duration, delay, easing curve, distance, color shift. Live update as the user drags.
- A "play" button that re-triggers the animation (so the user doesn't have to wait for a natural trigger).
- A code block at the bottom that shows the current parameters as CSS / JS / framer-motion config — and updates as the sliders move. Plus a "copy" button.
- Optional: a few preset combinations the user can toggle between to compare.

**What's load-bearing**
- The live code output. The whole reason this exists is so the user can tune values and copy them back into their real codebase. Without the copy step, this is just a demo.
- Easing curve visualization (a small graph) is dramatically better than just a dropdown of names. Users tune curves visually.
- Re-triggerable. One-shot animations are useless for tuning.

**Common mistakes**
- Building a generic "animation playground" instead of prototyping the specific animation the user asked about. Stay scoped to the one transition.
- No way to copy the result. The artifact then can't graduate into the real code.

## Clickable interaction flow

For "let me feel whether this multi-screen flow works."

**Layout**
- 3–6 screens linked together in their natural order.
- Real (enough) buttons: clicking "next" actually advances. Clicking "back" actually goes back.
- A "screen tray" thumbnail strip showing all screens, current one highlighted — so you can jump anywhere.
- Just enough fidelity to test the *shape* of the flow. Don't render every form field; render the ones the flow turns on.

**Common mistakes**
- Trying to make it pixel-perfect. That's a different artifact. This is for "does the sequence feel right."
- No way to jump between screens. Users want to compare screen 1 to screen 4 directly.

## Example sketch — animation prototype

```html
<main>
  <section class="stage">
    <button class="checkout-btn" id="target">Place order</button>
  </section>

  <aside class="controls">
    <label>Duration <input type="range" id="dur" min="100" max="2000" value="400">
           <output>400ms</output></label>
    <label>Easing <select id="ease">
      <option>cubic-bezier(.2,.8,.2,1)</option>
      <option>ease-out</option>
      ...
    </select></label>
    <label>End color <input type="color" id="color" value="#7c3aed"></label>
    <button id="play">▶ Replay</button>
  </aside>

  <pre id="code">/* live updates as sliders move */</pre>
  <button id="copy">Copy CSS</button>
</main>
```
