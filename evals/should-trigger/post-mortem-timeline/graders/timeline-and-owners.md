---
type: llm
focus: { source: file, path: postmortem.html }
weight: 2
---

Judge this post-mortem HTML page.

PASS if all hold:
- There is a visual timeline: timestamps aligned in one column with events beside them (or an equivalent drawn structure), not a plain numbered list in prose.
- The customer impact (about 23 minutes, roughly 8% of sessions) appears near the top, before the timeline.
- Action items are listed with an owner and a deadline each (Maya/Friday, Tomas/next sprint, Priya/this week).

FAIL if the timeline is just paragraphs, if impact is buried at the bottom, or if any action item lacks its owner.
