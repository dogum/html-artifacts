# Decks

A handful of `<section>` tags and twenty lines of JavaScript is a slide deck. Use this for short presentations the user wants to arrow-key through in a meeting — no Keynote, no export step, no PowerPoint roundtrip.

## When to make a deck

- The user explicitly says "deck," "slides," or "presentation."
- The content is going to be presented *to others*, in a meeting, with someone narrating.
- The user wants ~5–20 slides with strong visual hierarchy and minimal per-slide text.
- The content has natural "beats" — points the speaker wants to land one at a time.

If the content is dense reference material that the reader will study on their own, a deck is wrong. Use the report/explainer pattern instead.

## Layout

- One `<section>` per slide, with a class like `slide`.
- A presenter view that shows just the current slide, full-viewport. Not a scroll.
- Arrow keys (`←`/`→`, optionally space) advance and reverse.
- A small slide counter in the corner: `4 / 12`.
- Optional: a thumbnail strip toggleable with `Esc` or a button, so the speaker can jump.
- Optional: presenter notes accessible with a key (e.g., `n`) — a side panel with notes for the current slide. Useful when the deck is rehearsed.

## Per-slide structure

- One **idea** per slide. If a slide has two ideas, split it. The whole point of slides is forced focus.
- Big type. The body text on a slide should be readable from the back of a room. Default to 32–48px for body, larger for titles.
- Minimal words. A slide is a visual aid for a speaker, not a document. If there's a paragraph on the slide, the speaker is competing with their own slide.
- Strong visual hierarchy: title, the one main thing (chart/quote/image/code), maybe a small footnote. That's it.

## What's load-bearing

- Keyboard navigation. A deck without arrow keys is a webpage that has slides on it.
- Real fullscreen behavior. Add a "press F to fullscreen" hint or a button. Browser chrome is distracting in a presentation.
- Slide counter. The presenter and audience both want to know where they are.
- Aspect-ratio handling. Default to 16:9 with letterboxing on other aspect ratios — don't let layout shift between slides.

## Common mistakes

- Making each slide a markdown-rendered card. Slides are visual; one slide should be a chart, the next should be a quote, the next should be a photo. Don't homogenize them.
- Cramming. If a slide has 5 bullets, it's two slides. Or a table on one slide.
- Cute transition animations. Skip them. They distract and they break when the user clicks fast.
- Forgetting the dark version. Most rooms project on dark. Make sure light-on-dark renders cleanly, or at minimum that the deck can be flipped with a key. A deck is the one artifact that can commit to a single theme; if it does, paint background and text explicitly instead of relying on `prefers-color-scheme`.
- Ignoring touch. On a phone or tablet, tap the right half to advance and the left half to go back; the arrow keys don't exist there.

## Example skeleton

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1"/>
  <title>Deck title</title>
  <style>
    html, body { margin:0; height:100%; background:#0b0b10; color:#f4f4f7;
                 font: 24px/1.4 system-ui, sans-serif; }
    .slide { display:none; height:100vh; padding:6vh 8vw; box-sizing:border-box;
             align-items:center; justify-content:center; flex-direction:column; }
    .slide.active { display:flex; }
    .slide h1 { font-size: 6vmin; margin: 0 0 .4em; }
    .slide h2 { font-size: 4vmin; margin: 0; opacity: .8; }
    .counter { position:fixed; bottom: 1em; right: 1em; opacity:.6; font-size:.7em; }
  </style>
</head>
<body>
  <section class="slide active">
    <h1>Why HTML beats markdown</h1>
    <h2>For the things agents now make</h2>
  </section>

  <section class="slide">
    <h1>Information density</h1>
    <p>Tables, SVG, color, interactivity — markdown can't.</p>
  </section>

  <section class="slide">
    <!-- a chart or figure as the whole slide -->
    <svg viewBox="0 0 400 200">...</svg>
  </section>

  <div class="counter"><span id="i">1</span> / <span id="n"></span></div>

  <script>
    const slides = document.querySelectorAll('.slide');
    let i = 0;
    document.getElementById('n').textContent = slides.length;
    function go(n) {
      i = Math.max(0, Math.min(slides.length - 1, n));
      slides.forEach((s, idx) => s.classList.toggle('active', idx === i));
      document.getElementById('i').textContent = i + 1;
    }
    document.addEventListener('keydown', e => {
      if (e.key === 'ArrowRight' || e.key === ' ') go(i + 1);
      else if (e.key === 'ArrowLeft') go(i - 1);
      else if (e.key === 'f') document.documentElement.requestFullscreen();
    });
    document.addEventListener('click', e => {
      if (e.target.closest('a, button')) return;
      go(e.clientX > innerWidth / 2 ? i + 1 : i - 1);
    });
  </script>
</body>
</html>
```

That's the whole substrate. Twenty lines of JS, no build step, opens directly in a browser.
