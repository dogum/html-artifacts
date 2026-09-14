# Accessibility & Print

Shared artifacts get read by screen readers, keyboard-only users, and printers. The baseline is cheap; do it every time.

## The baseline, every artifact

- **Landmarks.** `<header>`, `<main>`, `<nav>`, `<aside>`, `<footer>`. One `<h1>`. Headings in order.
- **Language.** `<html lang="en">` (or the content's language). When publishing to a surface that supplies the skeleton, skip this.
- **Controls have names.** Every `<button>` has text or `aria-label`. Every input has a `<label>`. Icon-only buttons get `aria-label`.
- **Keyboard.** Anything clickable is a `<button>`, `<a href>`, or has `tabindex="0"` with `keydown` handling for Enter and Space. Drag-and-drop has a keyboard alternative (select then arrow keys, or "move to…" buttons). Custom shortcuts are listed on the page.
- **Focus is visible.** Don't `outline: none` without a replacement. `:focus-visible { outline: 2px solid var(--accent); outline-offset: 2px }` is enough.
- **Color is never the only signal.** Severity gets an icon or a word next to the color. Chart series get direct labels or distinct shapes. Status columns get a heading.
- **Contrast.** Body text at 4.5:1 against its background in both themes. Muted text at 4.5:1 too; "muted" means smaller or lighter weight, not gray on gray.
- **Motion.** Anything that animates on its own respects `@media (prefers-reduced-motion: reduce)`.
- **SVG.** `role="img"` with `<title>` for figures; `aria-hidden="true"` for decoration. Text as `<text>`, not paths.
- **Live regions.** Editors that update counts or status announce them: `aria-live="polite"` on the readout element.
- **Tables.** `<th scope="col">`, a `<caption>`. Don't build tables from `<div>`s.
- **Collapsibles.** Use `<details>`/`<summary>`; they're accessible for free.

## Print

Reports, post-mortems, specs, and plans get printed or saved to PDF. Twelve lines of CSS:

```css
@media print {
  :root { --bg: #fff; --ink: #000; --ink-soft: #333; --rule: #bbb; }
  body { max-width: none; margin: 0; font-size: 11pt; }
  nav, .toolbar, .export, button, .no-print { display: none; }
  details > summary { list-style: none; }
  a[href^="http"]::after { content: " (" attr(href) ")"; font-size: .85em; }
  pre, table, figure, article { break-inside: avoid; }
  h1, h2, h3 { break-after: avoid; }
}
```

`<details>` can't be opened from CSS. If a page has collapsed sections the printed copy needs, open them on `beforeprint`:

```js
addEventListener('beforeprint', () => document.querySelectorAll('details').forEach(d => d.open = true));
```

Decks are the exception: a deck prints one slide per page with `@page { size: landscape }` and `.slide { break-after: page; display: flex }`, or doesn't print at all. Editors don't print; hide the toolbar and let the state table print instead.

## Quick self-check

Tab through the whole page once in your head: can you reach every control, and can you tell where you are? Read the page with the colors stripped: does every status still make sense? Print preview: does anything essential disappear? Three questions, thirty seconds.
