# Document Rotation Reference

## Intended Behavior

This is the default workflow for `document/` in Git repositories.

The workflow is for repositories that want to keep temporary working documents in Git, but avoid leaving uncontrolled files directly under `document/` across commits.

Use `knowledge/` for notes that should remain useful independently of the current code state or commit history.

The model is generation-based:

- current generation:
  - files directly under `document/`
- pending generation:
  - files under `document/previous/`
- finalized generations:
  - files under `document/<shortsha>-<slug>/`

If some documents should not be rotation-managed, keep them under `knowledge/` or use a deliberate alternative workflow.

## Rotation Timing

Run rotation before commit, not after commit.

Reasons:
- the commit records the rotated state directly
- the working tree remains clean after commit
- tracked files are not deleted after the commit

Treat pre-commit rotation as the standard choice. Do not treat post-commit cleanup of tracked files as the default.

If a repository already has a deliberate document workflow, preserve that instead of forcing this one.

## Minimal File Set

```text
.document-rotation.env
.githooks/pre-commit
tool/rotate_document_before_commit.sh
tool/setup_git_hooks.sh
```

These files should be kept as reusable templates under:

```text
assets/repo_document_rotation/
```

and copied into each target repository during setup.

Use:

```text
scripts/install_document_rotation.sh
```

to perform that copy.

If the installer script is not used, copy the files directly from
`assets/repo_document_rotation/` with `cp`. Do not manually retype the hook
or shell script contents unless a copied template must then be patched for a
deliberate repository-specific variation.

The copied `.document-rotation.env` file is the supported place to configure
the target directory. Keep `ROTATE_DOCUMENT_DIR=document` as the default, and
change that copied file when a repository needs a different path.

## Minimal Hook Shape

```bash
#!/usr/bin/env bash
set -euo pipefail

set -a
. ./.document-rotation.env
set +a

./tool/rotate_document_before_commit.sh
git add -A -- "$ROTATE_DOCUMENT_DIR"
```

## Minimal Setup Shape

```bash
#!/usr/bin/env bash
set -euo pipefail

git config core.hooksPath .githooks
chmod +x .githooks/pre-commit
chmod +x tool/rotate_document_before_commit.sh
chmod +x tool/setup_git_hooks.sh
```

## Important Constraints

- `core.hooksPath` is not cloned automatically.
- The hook path must be configured per clone.
- A repository-level setup script is the simplest way to make this repeatable.
- Installing the templates and activating the hooks are separate steps.
- `post-commit` cleanup of tracked files is possible but not preferred because it leaves the repository dirty.

## Note Metadata

For Markdown notes produced under this workflow, prefer a short metadata block near the top with at least:

- `Created:`
- `Updated:`
- `Model:`
- `Reasoning-Effort:`
- `Session:` when available
- `Related-Commit:` when relevant

Prefer real values from the active session log when available. Use `CODEX_THREAD_ID` for the session identifier, and use config defaults only as a fallback when session-level values cannot be read.
