---
description: A side-by-side comparison request. Should produce an HTML page with columns and a recommendation.
tags: [trigger, comparison]
max_turns: 15
timeout_seconds: 420
allowed_tools: [Read, Glob, Grep, Skill]
---

Compare three ways to handle retries in a Node HTTP client for our payments service: a naive retry loop, exponential backoff with jitter, and a circuit breaker in front of the client. I need to pick one this week, so show the tradeoffs properly and tell me which you'd choose. Save the writeup as retries.html in the current directory.
