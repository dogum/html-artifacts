---
type: llm
focus: { source: file, path: triage.html }
---

Judge the JavaScript in this HTML file.

PASS if either (a) it never touches localStorage / sessionStorage / indexedDB, or (b) every access to them is inside a try/catch (or a helper function that wraps access in try/catch) so the page still works when storage throws or is empty.

FAIL if there is any bare localStorage.getItem / setItem call outside a try/catch.
