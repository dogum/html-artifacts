---
description: A one-off editor request. Should produce a pre-filled board with keyboard support and a copy-as-markdown export.
tags: [trigger, editor]
max_turns: 15
timeout_seconds: 420
allowed_tools: [Read, Glob, Grep, Skill]
---

I need to triage these tickets for next cycle into Now / Next / Later / Cut. Give me something I can drag them around in and then paste the result into Linear. Save it as triage.html.

- PLAT-410 Rotate signing keys without downtime (security asked twice)
- PLAT-412 Migrate cron jobs off the legacy box
- PLAT-415 Flaky integration test in billing webhooks
- PLAT-418 Add request IDs to all log lines
- PLAT-421 Dashboard for queue depth per tenant
- PLAT-423 Upgrade Postgres 14 → 16 on staging
- PLAT-427 Remove the feature flag for the new checkout (100% for 3 months)
- PLAT-430 Investigate 2% of exports timing out
