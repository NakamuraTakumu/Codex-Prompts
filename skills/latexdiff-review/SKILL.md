---
name: latexdiff
description: Use when the user wants to generate a LaTeX manuscript diff against Git revisions or the current working tree, especially for multi-file projects that need `latexdiff-vc --git --flatten` and a concise record of artifact-generation caveats.
---

# Latexdiff

## Overview

This skill creates a `latexdiff` artifact for a LaTeX project and records the practical caveats around generating that artifact.

Use it for Git-backed LaTeX projects with a master `.tex` file and included section files.

## When To Use

- The user wants a visual diff PDF rather than a raw `git diff`.
- The LaTeX project spans multiple included files and needs `--flatten`.
- The user wants confirmation that the diff artifact generation is faithful and usable.
- The user wants the workflow documented so it can be repeated later.

## Workflow

1. Identify the baseline revision and the master LaTeX file.
   Common baseline: `HEAD`.
   Common master file: `main.tex` or the project manuscript root such as `learnerParaLens.tex`.

2. Generate a flattened diff with `latexdiff-vc`.
   Run from the LaTeX project root.
   Choose the output directory according to the workspace policy.

```bash
latexdiff-vc --git --flatten --force -d diff -r HEAD learnerParaLens.tex
```

Replace `HEAD` and `learnerParaLens.tex` as needed.

3. Report artifact-generation caveats, not just existence.
   Call out whether the diff is faithful, noisy, or hard to review.
   Typical sources of noise:
- bibliography flattening into a large `thebibliography` block
- citation command changes that render as output-level additions and deletions
- list environment rewrites that produce awkward visual markup
- missing auxiliary files or class/style dependencies that affect compilation later

## Only-Changes Caveat

`latexdiff-vc --only-changes` can be useful when the full diff output is too long, but it may depend on extra LaTeX packages such as `zref`. If that mode fails, say so explicitly and fall back to the standard diff artifact instead of spending time forcing a fragile setup.

## Outputs

- `<diff-dir>/<master>.tex`
- Optionally, a Markdown note describing the exact command sequence and any environment-specific caveats when the result should be preserved

Follow the workspace or repository policy for where diff artifacts and notes belong. If no policy is present, prefer a descriptive subdirectory under `document/` or another existing artifact area over ad hoc scratch locations.

## Reporting Checklist

- State the baseline revision used.
- State the master file used.
- State the output paths created.
- State the main caveats that affect readability or completeness.
