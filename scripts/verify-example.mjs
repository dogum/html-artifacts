// Render HTML artifacts headless and report layout overflow and script errors.
// Usage: node scripts/verify-example.mjs [--shots DIR] file.html [more.html ...]
// Needs Playwright with Chromium (PLAYWRIGHT_BROWSERS_PATH honoured). Screenshots go to --shots if given.
import { chromium } from 'playwright';
import { pathToFileURL } from 'node:url';
import { basename } from 'node:path';

const args = process.argv.slice(2);
let shots = null;
if (args[0] === '--shots') { shots = args[1]; args.splice(0, 2); }
if (!args.length) { console.error('usage: verify-example.mjs [--shots DIR] file.html ...'); process.exit(2); }

const views = [
  { name: 'desktop-light', width: 1280, height: 800, scheme: 'light' },
  { name: 'desktop-dark',  width: 1280, height: 800, scheme: 'dark' },
  { name: 'phone',         width: 400,  height: 800, scheme: 'light' },
];
const browser = await chromium.launch();
let failed = 0;
for (const file of args) {
  const problems = [];
  for (const v of views) {
    const page = await browser.newPage({ viewport: { width: v.width, height: v.height }, colorScheme: v.scheme });
    page.on('pageerror', e => problems.push(`${v.name}: pageerror ${e.message}`));
    page.on('console', m => m.type() === 'error' && problems.push(`${v.name}: console ${m.text()}`));
    page.on('requestfailed', r => problems.push(`${v.name}: request failed ${r.url()}`));
    await page.goto(pathToFileURL(file).href);
    await page.waitForTimeout(250);
    const overflow = await page.evaluate(() => {
      const d = document.documentElement;
      return d.scrollWidth > d.clientWidth + 1 ? `${d.scrollWidth}px wide in ${d.clientWidth}px` : null;
    });
    if (overflow) problems.push(`${v.name}: horizontal overflow ${overflow}`);
    const title = await page.title();
    if (!title) problems.push(`${v.name}: empty <title>`);
    if (shots) await page.screenshot({ path: `${shots}/${basename(file, '.html')}-${v.name}.png`, fullPage: true });
    await page.close();
  }
  if (problems.length) { failed++; console.log(`FAIL ${file}\n  ` + problems.join('\n  ')); }
  else console.log(`ok   ${file}`);
}
await browser.close();
process.exit(failed ? 1 : 0);
