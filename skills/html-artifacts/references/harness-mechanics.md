# Harness Mechanics

Everything surface-specific lives here so the rest of the skill stays portable. This is the file most likely to go stale; when a surface changes its rules, fix it here and nowhere else.

## Quick table

| Surface | Where the artifact goes | Browser for verification | Storage | External scripts |
|---|---|---|---|---|
| Claude Code (CLI, desktop, IDE) | File on disk in the working directory | Usually yes: Playwright or a local Chromium | `localStorage` fine | Any, but prefer none |
| Claude Code on the web / cloud sessions | File on disk; may also publish as an Artifact | Chromium is pre-installed | File: fine. Published artifact: unreliable | Allowlisted CDNs for published artifacts |
| Claude Cowork | File in the working folder | Sometimes | Fine for files | Any, prefer none |
| Claude.ai chat | HTML artifact in the side panel | No | Unreliable; in-memory primary | Allowlisted CDNs only |
| Published artifact (claude.ai link) | Hosted page, private by default | Publish, then read it back if you can | Unreliable; runtime capability if declared | Allowlisted CDNs only |

## Claude Code: files on disk

- Save with a descriptive `kebab-case` name and `.html`: `onboarding-explorations.html`, `pr-1234-review.html`, `cycle-14-triage.html`.
- A web of related artifacts (explorations, mockups, plan) goes in one folder so it can be opened and shared as a unit.
- Tell the user the path, and how to open it: `open file.html` on macOS, `xdg-open file.html` on Linux, `start file.html` on Windows. Offer to open it once; don't nag.
- If the user has a `frontend-design` skill, a design system file, or a `design-system.html` in the project, read it before drafting.
- Verification: see `verify-before-delivering.md`. Chromium via Playwright is the common path; `python -m http.server` plus a screenshot tool works too.

## Claude.ai chat: HTML artifacts

- Output one `text/html` artifact. Not React, not Mermaid, not bare SVG, unless the request calls for it.
- The artifact runs in a sandboxed iframe. Treat `localStorage`, `sessionStorage`, and IndexedDB as unreliable: they may be blocked, empty, or throw. Keep state in memory; if you persist, wrap every read and write in `try/catch` and make the page work without it.
- No relative links to other files. One page; in-page anchors are fine.
- External scripts and stylesheets load only from the allowlist: `cdnjs.cloudflare.com`, `cdn.jsdelivr.net/npm/`, `cdn.tailwindcss.com`, `code.jquery.com`, and Google Fonts (`fonts.googleapis.com` and `fonts.gstatic.com`). Everything else fails silently. Pin exact versions. Prefer inlining; a chart or diagram rarely needs a library.
- No browser to verify with. Do the manual read-through in `verify-before-delivering.md` and deliver.

## Published artifacts (claude.ai links from Claude Code or Cowork)

Published pages are hosted and shareable. They have extra rules on top of the chat rules:

- The page is wrapped in a document skeleton at publish time; put `<title>` and `<style>` at the top of the file and don't emit your own `<html>`/`<head>`/`<body>`.
- Theme has three states. Define the full light palette on `:root`; redefine tokens under `@media (prefers-color-scheme: dark)` guarded as `:root:not([data-theme="light"])`; redefine again under `:root[data-theme="dark"]`. Give `body` an explicit background.
- Runtime capabilities (persistent state shared across viewers, knowing the viewer, live connected data, asking Claude, file downloads) exist on some plans and must be declared at publish time. Use them only when the surface's own documentation or skill is present in the session. Never write code against a capability you haven't confirmed.
- Downloads started by page script are inert for viewers. An "export" is a copy-to-clipboard button plus a visible `<textarea>` fallback, not a download link.
- Rendered size limit is 16 MB including data URIs.

## Cowork and other file-based agents

Same as Claude Code: a file in the working folder, verified if a browser is reachable, otherwise read-through. If the harness can't run shell commands at all, say so in one line and deliver the file; do not wait on a verification step that can't happen.

## Any other agent (Agent Skills spec)

This skill uses only spec fields in its frontmatter, so it loads in any Agent Skills-compatible runtime. Where the runtime has a file system, follow the Claude Code section. Where it only has a chat surface, follow the Claude.ai section. When in doubt: one file, no network, verify if you can, deliver either way.
