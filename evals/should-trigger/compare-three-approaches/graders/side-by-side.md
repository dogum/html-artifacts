---
type: llm
focus: { source: file, path: retries.html }
weight: 2
---

You are judging an HTML file that compares three retry strategies.

PASS if all of the following hold:
- The three options are laid out side by side (a CSS grid or flex row of three columns or cards that sit next to each other on a wide screen), not as three sequential sections stacked down the page.
- Each option has the same internal structure (same sub-headings in the same order), and includes a pros/cons table or an equivalent structured tradeoff, not just prose.
- There is an explicit recommendation that picks one option and gives a reason.

FAIL if the options are stacked vertically as headings and paragraphs, if the structures differ between options, or if the page ends with "it depends" without picking.
