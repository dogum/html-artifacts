---
type: regex
pattern: "linear-gradient|radial-gradient|backdrop-filter"
match: not_contains
target: { source: file, path: retries.html }
---
