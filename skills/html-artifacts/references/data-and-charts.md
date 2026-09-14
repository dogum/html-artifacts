# Data & Charts

Numbers are where markdown fails hardest: a table of 40 rows is unreadable, a trend is invisible, and there is no sorting. HTML gets real tables, inline SVG charts, and filtering for free. Keep it honest and keep it small.

## Which form

| The data is… | Make… |
|---|---|
| Under a dozen numbers the reader compares | A short table, or a row of stat tiles with a label, value, and delta |
| A trend over time | A line or area chart; a sparkline if it's one series in a report |
| Categories compared | A horizontal bar chart, sorted, labels at the bar ends |
| A part-to-whole with fewer than five parts | A stacked bar. Not a pie |
| A distribution | A histogram or a dot strip |
| Two variables' relationship | A scatter plot |
| Many rows the reader will search | A data table with sort, filter, and a count |
| A cross-tab of two dimensions | A heatmap with a legible scale |

If a chart's message can't be stated in one sentence, the chart isn't ready. Put that sentence in the caption.

## Charts: draw them in SVG

No charting library for fewer than a few hundred points. A bar chart is rectangles; a line chart is one `<path>`. Hand-drawn SVG is smaller, has no CDN dependency, works offline, and uses the page's theme tokens.

**Load-bearing**
- Axes with labelled ticks in round numbers. A y-axis that starts at zero for bars. A stated unit.
- Direct labels on series where possible instead of a legend the eye has to bounce to.
- Series colors from a small, distinct palette that survives grayscale and color-blindness (vary lightness, not just hue). Never more than six series; group the rest as "other."
- `<title>` on the SVG and a caption under it that says what the reader should take away.
- Ink in `currentColor` or theme tokens so the chart works in dark mode.
- A `<table>` with the same data, visually hidden or in a `<details>`, for screen readers and copy-paste.

**Common mistakes**
- Truncated bar axes that exaggerate differences.
- Rainbow palettes, gradients on bars, 3D anything, drop shadows.
- Tooltips as the only way to read a value. Label the important ones on the chart.
- Grid lines darker than the data.

If a library is genuinely warranted (thousands of points, zooming, brushing), load one pinned version from an allowed CDN and keep the fallback table.

## Data tables

For anything past ~15 rows: sortable column headers (click toggles ascending/descending, an arrow shows which), a text filter that matches any cell, a live row count ("38 of 212"), and sticky headers. Numeric columns right-aligned in a tabular-figure font (`font-variant-numeric: tabular-nums`). Rows under 40px tall. Zebra striping only if columns are many.

Every table with interaction has an export: "Copy as CSV" and "Copy as markdown" of the *currently filtered and sorted* rows. Rule 7 applies.

Under 40 lines of vanilla JS covers sort, filter, and export. Don't reach for a table library.

## Dashboards

A dashboard is a page whose only job is "how are we doing." Structure:

- A row of three to five stat tiles: label, value, delta with direction and color, a sparkline if there's history.
- One or two main charts that answer the question in the title.
- A table for the detail.
- A timestamp of the data and where it came from.

Resist the twelve-widget grid. If the reader can't say what the page is telling them in ten seconds, remove widgets until they can.

## Example sketch: bar chart plus table

```html
<figure class="chart">
  <svg viewBox="0 0 480 200" role="img" aria-labelledby="t1">
    <title id="t1">p95 latency by endpoint, ms, last 7 days</title>
    <g class="axis" stroke="currentColor" opacity=".3">
      <line x1="120" y1="10" x2="120" y2="180"/>
      <line x1="120" y1="180" x2="470" y2="180"/>
    </g>
    <!-- one <g> per bar: label left, rect, value right -->
    <g><text x="112" y="40" text-anchor="end">/search</text>
       <rect x="120" y="28" width="300" height="18" fill="var(--accent)"/>
       <text x="426" y="40">412</text></g>
    <g><text x="112" y="70" text-anchor="end">/checkout</text>
       <rect x="120" y="58" width="180" height="18" fill="var(--accent)"/>
       <text x="306" y="70">247</text></g>
    ...
  </svg>
  <figcaption>/search is the outlier: 1.7× the next endpoint. Bars sorted descending; axis starts at 0.</figcaption>
  <details><summary>Data</summary><table>...</table></details>
</figure>
```
