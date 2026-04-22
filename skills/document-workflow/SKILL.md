---
name: document-workflow
description: Use in any Git repository. Treat `document/` as managed by the standard document-workflow rotation model by default, install the standard setup if the required files or settings are missing unless the repository already has a deliberate alternative or the user explicitly asks not to change it, and decide whether notes belong in repository-local documentation or the global `/home/nakamura/.codex/document/` store.
---

# Document Workflow

Use this skill in any Git repository.

Treat `document/` as managed by the standard document-workflow rotation model by default.

If the standard document-workflow files or settings are missing, install them unless the repository already has a deliberate alternative or the user explicitly asks not to change it.

This skill is about document management policy and repository workflow rather than the document contents themselves.

Typical cases:
- entering a Git repository that does not yet have the standard document-workflow setup
- deciding whether a note belongs in a repository `document/` directory or in `/home/nakamura/.codex/document/`
- deciding whether a repository note should live under `document/` or `knowledge/`
- introducing or updating repository document rotation
- setting up `.githooks/`, `tool/setup_git_hooks.sh`, and related scripts for document handling
- creating a new repository and establishing its document storage rules
- standardizing document workflow setup across repositories
- finding that a repository is using document notes or temporary working docs but the document-workflow setup has not been installed yet

## Storage Policy

- Choose storage class before location: decide `document/` vs `knowledge/` first, then decide repository-local vs global scope.
- Use `document/` for notes and documents that depend on the current code state, current branch state, or specific commits.
- Use `knowledge/` for notes and documents that should remain useful even as the code changes, such as reusable findings, stable references, and general lessons.
- If a note is specific to one workspace or repository, store it in that workspace's local `document/` directory.
- If a note is not tied to any specific workspace or repository, store it in `/home/nakamura/.codex/document/`.
- If a note was discovered during repository work but its substance is about agent process, workflow mistakes, or reusable operating guidance rather than that repository's code/state, treat it as global and store it in `/home/nakamura/.codex/document/`.
- If a note remains actionable after removing repository path, branch, commit, and current code details, treat it as global.
- If one thread produces both repository-specific findings and global process findings, split them into separate notes and store each in the appropriate location instead of forcing one location for both.
- Split mixed findings only when both parts have standalone reuse value; otherwise keep the dominant note and add a one-line pointer to the other location.
- Notes stored under `/home/nakamura/.codex/document/` should be written in Japanese unless there is a clear reason to use another language.
- Record substantive research results, explicit documentation requests, and reusable or non-obvious findings unless the user explicitly asks not to.
- Default to saving a short Markdown note when a task involves non-trivial investigation, comparison, decision-making, workflow design, or reusable troubleshooting.
- Do not treat conciseness as a reason to skip documentation. When a result is worth keeping, save it as a short note rather than omitting it.
- Prefer updating an existing related Markdown note when the current task continues, refines, or corrects an existing documented thread.
- Lightweight or one-off questions that are unlikely to matter later do not need a new saved note, but they may still justify updating an existing related note when that keeps the document current.
- Do not include dates in document filenames by default. Prefer stable descriptive names and keep dates in metadata unless a date materially helps distinguish versions or chronology.

## Markdown Metadata

When creating or updating Markdown notes, use the standard structure below near the top of the file unless the user explicitly requests a different format.

Use this exact metadata block order:
- `Created:` creation timestamp
- `Updated:` last updated timestamp
- `Model:` model used to produce or revise the note
- `Reasoning-Effort:` Codex reasoning effort level such as `low`, `medium`, `high`, or `xhigh`
- `Session:` session ID when available
- `Repository:` repository name or path when relevant
- `Related-Commit:` commit hash when the note depends on a specific code state

After the metadata block, include:
- a required one-line `Purpose:` line
- a required `## Background` section
- a required `## Content` section
- a required `## References` section at the end

`Purpose:` must state why the document is worth keeping or writing in one sentence.
`Purpose:` is not a restatement of the topic or a duplicate of `Background`. Use it for the retention reason, such as what future decision, review, handoff, or reproduction this note should support.

`## Background` must appear with that exact heading name and should briefly explain the situation, trigger, or factual setup behind the note so later readers can interpret the saved result correctly.

Keep `## Background` concise. Preserve the core facts, decisions, constraints, rationale, and reproduction details.

`## Content` must appear after `## Background` with that exact heading name and should contain the document's main substance, such as findings, procedures, decisions, comparisons, or other task-specific material.

`## References` must appear at the end of the document with that exact heading name.
For now, list only external references there, such as web pages, papers, standards, or other outside documents.
Do not list internal repository documents, local notes, or other workspace-internal files in `## References` unless the user later asks to change this rule.

Keep the document concise as a whole. Omit secondary details that can be inferred from the core points unless they are needed for verification, reproduction, or future decisions. Do not repeat the whole task log, do not restate conclusions that are obvious from the main proposal or decision, and do not include nearby but separate artifacts such as implementation patches, recommended wording, or review notes unless the document's purpose specifically requires them.

When available, prefer actual runtime values over placeholders:
- read `Model:` and `Reasoning-Effort:` from the current thread's `turn_context` entry in the session log under `/home/nakamura/.codex/sessions/`
- use `CODEX_THREAD_ID` for `Session:`
- if a value cannot be retrieved, say so explicitly instead of inventing a placeholder

Preferred helper:
- use `scripts/extract_session_metadata.sh` to print `Model`, `Reasoning-Effort`, and `Session` for the current thread without relying on `config.toml`

Example:

```bash
/home/nakamura/.codex/skills/document-workflow/scripts/extract_session_metadata.sh
```

Standard template:

```md
# Title

- Created: 2026-04-19 08:00 UTC
- Updated: 2026-04-19 08:00 UTC
- Model: gpt-5.4
- Reasoning-Effort: medium
- Session: <session-id-if-available>
- Repository: <repo-name-or-path>
- Related-Commit: <commit-if-relevant>

Purpose: <one-line statement of why this document should be kept or what future work it should support>

## Background

This note records <the key situation or decision>. It explains the immediate setup, trigger, or constraint behind the note so later readers can interpret the saved result correctly.

## Content

<write the main contents of the document here>

## References

- <external source 1>
- <external source 2>
```

## Repository Document Rotation

Use the rotation workflow below as the default behavior for `document/` in Git repositories.

Target layout:

```text
document/
  previous/
  <shortsha>-<slug>/
```

Meaning:
- `document/` root contains current working documents before rotation
- `document/previous/` contains the generation that will be associated with the next commit
- `document/<shortsha>-<slug>/` contains a finalized snapshot associated with a past commit
- `knowledge/` is outside the rotation workflow and is meant for code-independent notes

Scope:
- `document/` is the rotation-managed area by default
- if some documents should not be rotation-managed, keep them in `knowledge/` or use a deliberate alternative workflow
- if a repository mixes stable docs and temporary working docs, introduce a separate folder layout rather than weakening the default rotation rule

Commit-time behavior:
1. If `document/previous/` exists and `HEAD` exists, move it to `document/<HEAD shortsha>-<HEAD slug>/`.
2. Move working files from `document/` root into `document/previous/`.
3. Stage `document/` changes before the commit continues.

Prefer `pre-commit` or a commit wrapper for this workflow. Do not prefer `post-commit` deletion for tracked files, because it leaves the repository dirty after commit.

## Implementation Pattern

For repository setup, prefer this split:

- `.document-rotation.env`
  - repository-local config file that defines the rotation target directory
- `.githooks/pre-commit`
  - thin wrapper that reads the config, calls the rotation script, and stages the configured directory
- `tool/rotate_document_before_commit.sh`
  - main document rotation logic
- `tool/setup_git_hooks.sh`
  - one-time setup that sets `core.hooksPath` to `.githooks` and fixes execute bits
- `assets/repo_document_rotation/`
  - template files copied into the target repository during setup
- `scripts/install_document_rotation.sh`
  - helper script that copies the template files into a repository

Installation method:
- Default to copying the prepared template files from `assets/repo_document_rotation/`.
- Prefer `scripts/install_document_rotation.sh` when it fits the repository as-is.
- If you need a manual install path, still use explicit `cp` commands from `assets/repo_document_rotation/`; do not retype the script files from scratch.
- Configure the rotation target by editing the copied `.document-rotation.env` file instead of hard-coding a repository-specific path into the scripts.
- Only patch the copied files after the copy step, and only when the repository needs a deliberate variation.

Why:
- the behavior works for normal Git commits, not just Codex-driven edits
- the implementation lives in the repository and can be cloned
- the setup step is explicit and lightweight
- the template files stay versioned in one place and can be reused across repositories
- the rotation model gives `document/` a single clear meaning across repositories

## Clone Behavior

- Files under `.githooks/` and `tool/` are cloned normally.
- The hook path setting is not cloned automatically.
- After cloning, the user must run `./tool/setup_git_hooks.sh` once in that clone.
- Installing templates and activating hooks are separate steps.

When asked about clone behavior, be explicit that repository files clone, but Git hook activation does not.

## When Implementing

Before editing a repository to add document rotation:
1. Check whether the repository already has `.githooks/`, `tool/`, or an existing commit workflow.
2. Prefer copying the templates from `assets/repo_document_rotation/` by using `scripts/install_document_rotation.sh`.
3. If you do not use the installer script, copy the needed files with `cp` from `assets/repo_document_rotation/`; do not manually recreate `.document-rotation.env`, `.githooks/pre-commit`, `tool/rotate_document_before_commit.sh`, or `tool/setup_git_hooks.sh`.
4. Configure the target path by editing the copied `.document-rotation.env`; keep `ROTATE_DOCUMENT_DIR=document` as the default unless the repository deliberately needs a different directory.
5. Treat `document/` as rotation-managed by default; if the repository wants a different meaning for those files, use a separate folder or a deliberate alternative workflow.
6. Use `knowledge/` for code-independent notes that should not rotate with commits.
7. If the repository already has a pre-commit workflow, integrate manually rather than overwriting it blindly.
8. Keep the hook thin and the main logic in `tool/`.
9. Add a short note in repo documentation explaining that clones must run `./tool/setup_git_hooks.sh`.
10. Only after copying templates should you patch them for repository-specific variations.
11. In a Git repository, if the standard document-workflow setup is missing, install it by default rather than waiting for the user to name the missing files explicitly.
