---
name: paper-review
description: Review academic papers and LaTeX manuscripts, with or without local revision, under explicit scholarly constraints. Use when Codex needs either (1) review findings only with no revision proposals, (2) review plus safe revision proposals without editing files, or (3) review plus safe local edits that fix issues without silently changing claims, scope, logic, terminology, or authorial voice.
---

# Paper Review

Use this skill when paper review must follow explicit scholarly constraints, whether the task stops at findings or continues into local revision work.

## Modes

- `review-only`
  - Report findings only.
  - Do not propose revisions.
  - Do not edit manuscript files.
  - The review surface may be a `git diff` rather than the full manuscript text.
- `revision-no-change`
  - Report findings.
  - Propose safe revisions.
  - Do not edit manuscript files.
- `revision`
  - Report findings.
  - Apply safe local revisions to manuscript files.

## Mode Inference

- Requests to inspect, check, review, assess, or summarize issues default to `review-only`.
- Requests to suggest, propose, recommend, or outline revisions default to `revision-no-change`.
- Requests to fix, revise, polish, clean up, or adjust text default to `revision`.

## Workflow

1. Fix the scope.
   - Decide whether the target is the whole manuscript, a section, a diff, or a narrow issue such as citations or front matter.
   - Do not read files outside the review target unless the user explicitly asks for broader coverage or a concrete blocker makes extra local context strictly necessary.
2. Enumerate the in-scope review units.
   - If the task is narrow, list the relevant objects first, such as all citations in a section.
   - If the input is a `git diff`, define in-scope items as reviewable change units rather than raw diff lines or whole hunks.
   - Group repeated local issue patterns when that reduces redundancy.
3. Remove review blockers.
   - Check for fatal build failures, unresolved references, unresolved citations, or missing bibliography output that would make later judgment unreliable.
4. Select criteria and evidence.
   - Load only the relevant parts of [references/criteria.md](references/criteria.md).
   - Load [references/revision-principles.md](references/revision-principles.md) when revision is in scope, and also when `review-only` is used to judge manuscript changes in a `git diff`.
   - Choose only the evidence needed for this request: source, PDF, build log, diff, author guidelines, or other directly relevant artifacts.
   - Prefer a target-bound evidence set: reviewed file(s), corresponding rendered artifact(s), and corresponding build log(s).
5. Review all in-scope items.
   - Do not suppress important issues just because they do not fit neatly into the selected criteria.
   - If the review surface is a `git diff`, split genuinely different issue types into separate findings, but allow one finding to cover repeated sites when the rationale, severity, and revision judgment are the same.
6. Judge and handle revisions according to mode.
   - `review-only`: stop at problem identification.
   - `revision-no-change`: record safe revisions, but do not edit files.
   - `revision`: apply the smallest sufficient safe local revision.
   - Preserve meaning unless the user asked for substantive change.
   - Treat citation fixes and other macro-affected wording as prose revision, not as macro substitution only.
   - If a sound fix is no longer local, keep it as a finding instead of silently widening the revision.
7. Re-check and report.
   - Re-check any proposed or applied revision against the original intent and nearby context.
   - Save or update a Markdown review note before treating the task as complete.
   - Use `document-workflow` to choose the storage location and keep the note aligned with the final findings and revision status.
   - Report findings with explicit severity labels, including unresolved issues that were too risky or too broad to revise safely.

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
- When wording may be affected by LaTeX commands, macros, annotations, or PDF extraction artifacts, inspect the extracted PDF text directly before judging the phrasing.
- Unless the user explicitly asks for a broader review, keep verification tied to the review target and its directly corresponding artifacts; do not read unrelated files just to gather extra context.

## Reporting

- Lead with findings and keep summary secondary.
- Distinguish between review findings, safe revisions that were identified, and revisions that were actually applied.
- Order findings by source order when the task is about a manuscript, section, or diff, unless the user explicitly asks for severity-first reporting.
- When the review surface is a `git diff`, do not map findings mechanically to diff lines or whole hunks; report findings at the level of separable semantic changes.
- Prefer grouping repeated issue patterns over repeating near-duplicate findings.
- Order unresolved issues by severity.
- Cite concrete file or artifact locations when possible.

## Output Markdown Format

- Save or update a Markdown note for every `paper-review` task before treating the task as complete, unless a higher-priority instruction explicitly says not to.
- Use `document-workflow` to choose the storage location and the standard outer document structure.
- Keep the title, metadata block, `Purpose:`, `## Background`, `## Content`, and trailing `## References` aligned with `document-workflow`.
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

- Repeat the `Findings` item schema as needed.
- Use `Issue Location` and `Issue Reason` so the same schema works for pure review, proposal-only revision work, and applied revision work.
- Keep `Revision` as a nested block with `Content` and `Nuance Shift`.
- If the input is a `git diff`, one hunk may produce multiple findings, and one finding may cover multiple changed sites when they belong to the same issue pattern.
- `Issue Location` may name multiple local sites when one finding intentionally groups repeated instances of the same issue.
- Split a grouped finding only when the grouped sites require different reasoning, severity, or revision judgment.
- Because detailed diffs can be inspected separately in popup review, do not require full original/revised sentence pairs in `Findings` unless they materially help disambiguate the issue.
- When a `latexdiff-popup-review` is produced for the same changes, use the same substantive review criteria and map them into per-diff popup comments rather than treating popup review as a separate review standard.
- Keep `## References` for external references only, following `document-workflow`.

## Mode-Specific Output Rules

- `review-only`
  - Set `Revision -> Content` and `Revision -> Nuance Shift` to `none` for every finding.
  - Keep `Safe Revisions Identified` and `Revisions Applied` as `none`.
- `revision-no-change`
  - Keep `Revisions Applied` as `none` even when safe revisions were identified.
- `revision`
  - `Safe Revisions Identified` and `Revisions Applied` should normally match unless some were intentionally left unapplied.

## References

- Load [references/criteria.md](references/criteria.md) for review criteria.
- Load [references/revision-principles.md](references/revision-principles.md) for revision constraints, and also for `review-only` diff review when judging whether a manuscript change is safe, local, and meaning-preserving.
