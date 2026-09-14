---
type: regex
pattern: "<html|<!doctype html|```html"
flags: i
match: not_contains
target: last_message
arm: both
---
