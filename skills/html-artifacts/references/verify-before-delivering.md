# Verify Before Delivering

Unverified HTML is the most common way this skill produces a bad result: a layout that overflows on a phone, a script error that leaves an editor dead, a dark theme with invisible text. One check before delivery catches most of it. Do the headless check when you can and the read-through when you can't. Never skip both, and never stall waiting for a browser that isn't there.

## If a browser is available

Claude Code, Cowork, and cloud sessions usually have Chromium via Playwright (`PLAYWRIGHT_BROWSERS_PATH` or a system install). One script, three screenshots, a console check:

```js
// verify.mjs  —  node verify.mjs path/to/artifact.html
import { chromium } from 'playwright';
import { pathToFileURL } from 'node:url';

const file = pathToFileURL(process.argv[2]).href;
const browser = await chromium.launch();
const errors = [];
const shots = [
  { name: 'desktop-light', width: 1280, height: 800, scheme: 'light' },
  { name: 'desktop-dark',  width: 1280, height: 800, scheme: 'dark'  },
  { name: 'phone',         width: 400,  height: 800, scheme: 'light' },
];
for (const s of shots) {
  const page = await browser.newPage({ viewport: { width: s.width, height: s.height }, colorScheme: s.scheme });
  page.on('pageerror', e => errors.push(`${s.name}: ${e.message}`));
  page.on('console', m => m.type() === 'error' && errors.push(`${s.name}: ${m.text()}`));
  await page.goto(file);
  await page.waitForTimeout(300);
  const wide = await page.evaluate(() => document.documentElement.scrollWidth > document.documentElement.clientWidth + 1);
  if (wide) errors.push(`${s.name}: page scrolls horizontally`);
  await page.screenshot({ path: `verify-${s.name}.png`, fullPage: true });
  await page.close();
}
await browser.close();
console.log(errors.length ? errors.join('\n') : 'ok');
process.exit(errors.length ? 1 : 0);
```

Then **look at the screenshots** (the Read tool renders images). Check, in this order:

1. Nothing overflows or clips at 400px. No horizontal scroll.
2. Dark mode has readable text everywhere, including inside `<pre>`, tables, and SVG.
3. The five-second test: title, framing line, and the shape of the content are visible above the fold.
4. Interactive parts respond: click the first control, press the keyboard shortcut, trigger the export and check the output text.
5. Console is clean.

Fix what you find, re-run, then deliver. Delete the screenshots and the script unless the user wants them.

If Playwright isn't installed, don't install a browser on the user's machine without asking. `npx playwright screenshot --viewport-size=400,800 file.html out.png` works when a browser is already present; otherwise fall through to the read-through.

## If no browser is available

Claude.ai chat, artifact-only surfaces, or a harness without a shell. Do this read-through of your own output before sending. It takes a minute and catches most of what the screenshots would:

- **Structure.** `<title>` set. Viewport meta present. One `<h1>`. Framing sentence right under it.
- **Layout at 400px.** Every grid or flex row can wrap or collapse to one column. No fixed widths wider than the screen. Tables and code blocks are in an `overflow-x: auto` container. Images and SVGs have `max-width: 100%`.
- **Theme.** Every color is a token defined on `:root`, redefined for dark. No hard-coded `#fff` backgrounds or `#000` text. SVG ink uses `currentColor` or a token.
- **Script.** Every `getElementById` matches an id that exists. Event listeners are attached after the elements exist (script at the end of body, or `DOMContentLoaded`). No references to `localStorage` outside a `try/catch`. No external URL outside the allowlist.
- **Interaction.** Every button does something. Keyboard shortcuts documented on the page. Export button produces text that round-trips.
- **Content.** Data the user supplied is pre-filled, not placeholders. Numbers add up. Nothing says "lorem" or "TODO".
- **Taste.** Fewer than three of the default-AI tells in `matching-your-style.md`.

Then deliver. Say in one line that it was checked by read-through rather than rendered, only if the user is likely to care (a shared deliverable, a demo). Don't apologize for the surface.

## When verification finds something you can't fix

Say what it is in one sentence and deliver anyway. A known rough edge that the user can see beats a stalled session.
