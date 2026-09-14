---
description: An incident writeup. Should render a real timeline, action items with owners, and a print-friendly page.
tags: [trigger, report]
max_turns: 15
timeout_seconds: 420
allowed_tools: [Read, Glob, Grep, Skill]
---

Write up yesterday's outage as a post-mortem I can send to the team. Save it as postmortem.html.

What happened: at 14:02 UTC the deploy of api v2.31.0 went out. 14:06 p95 latency on /search went from 180ms to 2.4s. 14:09 pager fired for latency SLO. 14:12 Maya acknowledged. 14:18 we saw the new query planner setting (jit=on) in the release notes and suspected it. 14:25 rolled back to v2.30.4. 14:29 latency recovered. Customer impact: search slow or timing out for ~23 minutes, roughly 8% of sessions in that window. Root cause: the migration enabled JIT on the search read replicas, and the planner chose JIT compilation for a hot query that runs 400 times a second. Follow-ups: pin jit=off in the replica config (owner: Maya, by Friday), add a p95 latency check to the deploy canary (owner: Tomas, next sprint), document the rollback procedure we used (owner: Priya, this week).
