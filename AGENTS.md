# AGENTS.md

## Scope
- Location: `/home/nakamura/.codex/AGENTS.md`.
- Role: global default guidance for this environment.
- Keep here: durable, cross-project rules.
- Put closer: workspace, repository, or subdirectory rules.
- Language: write `AGENTS.md` files in English unless there is a specific reason not to.

## Maintenance
- Add reusable coding or workflow instructions here after generalizing them.
- Exclude task-specific one-off notes.
- Keep this file small.
- Avoid duplicate rules unless separation of ownership or safety requires it.
- When abstracting existing guidance, preserve key concrete examples under the abstract rule.
- Prefer a skill for detailed procedures; mention only when to use it here.
- Use `skill-creator` when creating or updating skills.
- For skill edits:
  - write skill instructions in Japanese unless a specific reason requires another language;
  - use concise, structured Markdown;
  - prefer clear headings and short lists;
  - avoid long free-form prose;
  - preserve useful existing information.

## Work Intake
- Clarify the goal before acting when intent is not sufficiently understood.
- Surface ambiguity, incorrect assumptions, and materially better alternatives.
- Ask before materially diverging from the user request or expanding scope.
- Before directly editing code files, share the edit approach and proceed after approval or explicit continuation.
- Do not create commits unless the user explicitly asks for a commit.

## Verification
- Treat important user claims as hypotheses until checked.
- Re-check your own assumptions when accuracy matters.
- Inspect rendered artifacts directly only when correctness depends on visual rendering, such as figure, layout, spacing, screenshot, image, or other visual-output changes.

## References
- Prefer primary sources, standards, and official documentation.
- Use external sources when freshness, accuracy, or completeness matters.
- State the basis when a response or change depends on a specific reference.
- Align terminology, notation, and API usage with chosen primary references.
- For PDFs:
  - place or download them under `tmp_pdf/` first;
  - extract text before prose/content review;
  - inspect page images only when layout, figures, or visual details matter;
  - inspect extracted text before judging wording affected by commands, macros, annotations, or extraction artifacts.

## Reasoning
- Prefer criteria that reflect the problem structure over surface proxies.
- If a problem persists, revisit assumptions before stacking local workarounds.
- When you make a mistake:
  - identify the concrete cause;
  - explain it plainly;
  - improve process or rules when that reduces recurrence.

## Communication
- Default to Japanese in chat unless the user requests otherwise.
- Handle translation, explanation, and summarization in chat unless the user asks for file edits.
- During longer tasks, provide periodic progress updates.
- If work becomes unexpectedly difficult or time-consuming, explain the issue and ask for guidance.
- After editing files, explain where and how they changed, not only the diff.

## Workspace Hygiene
- Remove temporary or intermediate outputs when no longer needed.
- In repositories using document rotation, treat these as read-only unless explicitly instructed otherwise:
  - `document/previous/`
  - `document/<sha>-<slug>/`

## Knowledge Capture
- Use `document-workflow` for:
  - repository documents or notes;
  - research capture;
  - reusable findings;
  - non-obvious decisions worth preserving;
  - document rotation setup or updates.
- Save worthwhile findings before treating the task as complete.

## Tooling
- Document or script repetitive work when useful.
- Put repository-wide scripts in `tool/`.
- Put skill-specific scripts inside that skill directory.
- Prefer skill-local scripts when purpose, inputs, or maintenance scope are skill-specific.
- Add usage information to each new script.

## Delegation
- Default `spawn_agent.fork_context` to `false`.
- Use `fork_context: true` only when higher-priority instructions require context inheritance.

## Coding Style
- Prefer concise names with clear meaning.
- Use stable domain abbreviations consistently.
- Do not mix abbreviated and spelled-out forms for the same concept without a strong reason.
- Avoid names that repeat context already fixed by the class, module, receiver, or argument.
- Name values and operations by semantic role, not just type.
- Choose public API names by caller-facing meaning.
- Name booleans as states, predicates, or explicit switches.
