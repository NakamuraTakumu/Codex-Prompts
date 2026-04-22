---
name: paper-review
description: Review academic papers and LaTeX manuscripts, with or without local revision, under explicit scholarly constraints. Use when Codex needs either (1) review findings only with no revision proposals, (2) review plus safe revision proposals without editing files, or (3) review plus safe local edits that fix issues without silently changing claims, scope, logic, terminology, or authorial voice.
---

# Paper Review

Use this skill when paper review must follow explicit scholarly constraints, whether the task stops at findings or continues into local revision work.

## Modes

- `review-only`
  Review the target and report findings only. Do not propose revisions and do not edit manuscript files. The review surface may be a `git diff` rather than the full manuscript text.
- `revision-no-change`
  Review the target and propose safe revisions, but do not edit manuscript files.
- `revision`
  Review the target and write safe local changes to the manuscript files.

When the user does not explicitly choose, infer the mode from the request:
- Requests to inspect, check, review, assess, or summarize issues default to `review-only`.
- Requests to suggest, propose, recommend, or outline revisions default to `revision-no-change`.
- Requests to fix, revise, polish, clean up, or adjust text default to `revision`.

## Shared Workflow

1. Fix the scope first.
   Decide whether the target is the whole manuscript, a section, a diff, or a narrow issue such as citations or front matter.
2. List the in-scope items before judging or editing them.
   If the task is narrow, enumerate the relevant objects first, such as all citations in a section.
   When the input is a `git diff`, define in-scope items as reviewable change units rather than raw diff lines or whole hunks.
   Group changes by issue type when that yields a cleaner review. If multiple changed regions reflect the same local issue pattern, they may be treated as one in-scope item even when they occur at separate sites.
3. Remove review blockers.
   Check for fatal build failures, unresolved references, unresolved citations, or missing bibliography output that make downstream judgment unreliable.
4. Choose the review criteria for this request.
   Load only the relevant parts of [references/criteria.md](references/criteria.md).
5. Choose the evidence needed for those criteria.
   Decide whether source, PDF, build log, diff, or author guidelines are needed. Do not rely only on source when rendering or compliance matters.
6. Review all in-scope items under the selected criteria.
   Do not suppress important issues just because they do not fit neatly into the listed criteria.
   When reviewing a `git diff`, split genuinely different issues into separate findings, but merge repeated instances of the same issue pattern into one finding when that reduces redundancy.
   If one candidate finding would point to multiple revision sites, keep them together only when the same review rationale, severity, and revision judgment applies across those sites.
7. Judge safe local revisions according to mode.
   In `review-only`, stop at problem identification. In `revision-no-change` and `revision`, prefer the smallest sufficient revision that resolves the issue.
8. Preserve meaning unless the user asked for substantive change.
   Keep claims, implications, logic, attribution, hedging, and scope stable by default.
9. Treat citation fixes as prose fixes when revision is allowed.
   In `revision-no-change` and `revision`, revise sentence rhetoric as a whole rather than only swapping citation macros.
10. Stop when a sound fix is no longer local.
   If a problem requires broader restructuring, new content, or changed claims, leave it as a finding instead of silently widening the revision.
11. Handle the judged safe revisions according to mode.
   In `review-only`, do not include revision proposals. In `revision-no-change`, record safe revisions without editing files. In `revision`, apply them to the manuscript files.
12. Re-check any proposed or applied revision against the original intent when the mode allows revision.
   Confirm that the revision solved the local issue without accidental drift.
13. Save or update a Markdown review note before treating the task as complete.
   Use `document-workflow` to decide the storage location and keep the note aligned with the final judged findings and any applied revisions.
14. Report findings with explicit severity labels, including any unresolved issues that were too risky or too broad to revise safely.

## Guardrails For Revision

- Do not broaden edits to unrelated issues just because they are nearby.
- Do not add new claims, evidence, examples, comparisons, caveats, or interpretations unless requested.
- Do not replace the manuscript's style with more sophisticated but less faithful prose.
- Do not break established terminology, notation, definitions, abbreviations, references, or citation conventions.
- If a requested fix conflicts with meaning preservation or local-only editing, say so explicitly.

## Verification

- Use PDF when layout, cross-references, figures, captions, front matter, or citation integration may differ after rendering.
- Use build logs for compile failures, unresolved references, unresolved citations, and bibliography generation issues.
- Re-read any proposed or revised passage against the original text and nearby context when revision is in scope.
- For LaTeX manuscripts, prefer both source and PDF verification when citation wording or presentation is involved.

## Reporting

- Lead with findings and keep summary secondary.
- Distinguish between review findings, safe revisions that were identified, and revisions that were actually applied.
- Order findings by source order when the task is about a manuscript, section, or diff, unless the user explicitly asks for severity-first reporting.
- When the review surface is a `git diff`, do not map findings mechanically to diff lines or whole hunks; report findings at the level of separable semantic changes.
- Prefer grouping repeated issue patterns over repeating near-duplicate findings. One finding may cover multiple local sites when the rationale and disposition are materially the same.
- Order unresolved issues by severity.
- Cite concrete file or artifact locations when possible.

## Output Markdown Format

- Save or update a Markdown note for every `paper-review` task before treating the task as complete, unless a higher-priority instruction explicitly says not to.
- Use `document-workflow` to choose the storage location and the standard outer document structure.
- In other words, keep the title, metadata block, `Purpose:`, `## Background`, `## Content`, and trailing `## References` aligned with `document-workflow`.
- `paper-review` only standardizes what goes inside `## Content`.

```md
## Content

### Summary

<brief review summary>

### Findings

1. <short finding title>
   - Issue Location: <section / paragraph / sentence / file / page>
   - Severity: <major | moderate | minor | nit>
   - Issue Reason: <why this should be revised>
   - Revision:
     - Content: <rough description of the intended change, or `none` if no change is being proposed>
     - Nuance Shift: <how the wording or meaning would shift, or `none` if intended to preserve meaning>

2. <short finding title>
   - Issue Location: <section / paragraph / sentence / file / page>
   - Severity: <major | moderate | minor | nit>
   - Issue Reason: <why this should be revised>
   - Revision:
     - Content: <rough description of the intended change, or `none` if no change is being proposed>
     - Nuance Shift: <how the wording or meaning would shift, or `none` if intended to preserve meaning>

### Revision Status

- Mode: <review-only | revision-no-change | revision>
- Safe Revisions Identified: <list or none>
- Revisions Applied: <list or none>
- Unresolved Issues: <brief note or none>

### Verification

- Source: <what was checked>
- PDF: <what was checked or not checked>
- Build Log: <what was checked or not checked>
- Other Evidence: <diff / guideline / style file / none>
```

- In `Findings`, list items in source order by default rather than grouping them under severity headings.
- Use `Severity:` inside each finding item instead of creating `Major` / `Moderate` / `Minor` / `Nit` subsections.
- Use `Issue Location` / `Issue Reason` so the same schema works for pure review, proposal-only revision work, and applied revision work.
- Keep `Revision` as a nested block with `Content` and `Nuance Shift`; use `none` for `Content` when no concrete revision is being proposed.
- In `review-only`, set `Revision -> Content` and `Revision -> Nuance Shift` to `none` for every finding.
- When the input is a `git diff`, let one diff hunk produce multiple findings if it contains genuinely different issue types, and let one finding cover multiple changed lines or sites when they belong to the same issue pattern.
- `Issue Location` may name multiple local sites when one finding intentionally groups repeated instances of the same issue. Split the finding only when the grouped sites would require different reasoning, severity, or revision judgment.
- Because detailed diffs can be inspected separately in popup review, do not require full original/revised sentence pairs in `Findings` unless they materially help disambiguate the issue.
- When a `latexdiff-popup-review` is produced for the same changes, use the same substantive review criteria and map them into per-diff popup comments rather than treating popup review as a separate review standard.
- In `review-only`, keep `Safe Revisions Identified` and `Revisions Applied` as `none`.
- In `revision-no-change`, keep `Revisions Applied` as `none` even when safe revisions were identified.
- In `revision`, `Safe Revisions Identified` and `Revisions Applied` should normally match unless some were intentionally left unapplied.
- Keep `## References` for external references only, following `document-workflow`.

## References

- Load [references/criteria.md](references/criteria.md) for review criteria.
- Load [references/revision-principles.md](references/revision-principles.md) for revision constraints.
