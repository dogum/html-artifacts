---
type: regex
pattern: "chart\\.js|plotly|d3\\.min|echarts|recharts"
flags: i
match: not_contains
target: { source: file, path: signups.html }
---
