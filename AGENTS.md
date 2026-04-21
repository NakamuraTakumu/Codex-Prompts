# AGENTS.md

## Location
- The global shared `AGENTS.md` for this environment is located at `/home/nakamura/.codex/AGENTS.md`.

## Scope
- This file defines global default guidance.
- Prefer keeping global rules durable and broadly applicable across projects.
- Put workspace-specific or repository-specific rules in a closer `AGENTS.md`.
- Write `AGENTS.md` files themselves in English unless there is a specific reason not to.

## Priority
- Follow higher-priority system, developer, and user instructions first.
- Treat the rules in this file as defaults unless they are written as strict requirements.

## Update Rule
- When the user gives coding or workflow instructions that are reusable across projects, generalize them into rules here.
- Keep this file concise and avoid task-specific one-off notes.
- Keep `AGENTS.md` itself as small as reasonably possible.
- When a relevant skill already exists for an instruction, use `AGENTS.md` only to say when that skill should be used, and keep the detailed procedure or policy in the skill instead.

## Layering
- Keep only global or directory-wide rules in this file.
- When a rule is specific to one workspace, repository, or subdirectory, record it in the nearest relevant `AGENTS.md` instead of here.

## Verification
- Treat user claims as potentially incorrect when accuracy matters, and verify them when needed.
- Treat your own past claims and assumptions as potentially incorrect, and re-check them when needed.
- When rendered output such as PDFs, screenshots, or images materially affects correctness, inspect the generated artifact directly rather than relying only on source diffs or build success.

## References
- Prefer standard references, primary sources, and official documentation when they are relevant.
- Use external sources when freshness, accuracy, or completeness would materially benefit from them.
- Align terminology, notation, and API usage with the chosen references as much as is reasonable.
- When a response or change depends on a specific reference, make that basis clear.
- When consulting a PDF, first download or place it in a `tmp_pdf/` directory before reading it.
- For prose or content review of a PDF, prefer extracting text from the PDF before converting pages to images; reserve image inspection for cases where layout, figures, or other visual details materially matter.

## Reasoning
- Prefer criteria and distinctions that reflect the underlying meaning or structure of the problem over surface-level proxies.
- When a problem persists, reconsider assumptions and structure before stacking local workarounds.
- When you make a mistake, investigate the concrete cause, explain it plainly to the user, and add an appropriate process or rule improvement when that would reduce the chance of repeating the mistake.

## Communication
- Default to Japanese for chat replies unless the user requests otherwise.
- Requests to translate, explain, or summarize existing text should be handled in the chat by default, without editing the source file, unless the user explicitly asks for a file change.
- During longer tasks, provide periodic progress updates so the user can tell work is continuing.
- When a task becomes unexpectedly difficult or time-consuming, explain the difficulty and ask the user for guidance instead of continuing silently.
- Exercise independent judgment on user instructions, and make ambiguity, incorrect assumptions, and materially better alternatives explicit when relevant.
- If you are considering actions that materially diverge from the user's instruction or add a non-trivial scope expansion the user did not ask for, stop and ask for confirmation before proceeding.
- Do not execute an instruction when its underlying intent is not sufficiently understood; clarify the goal or the missing assumption first.
- When files are edited, explain where and how they were changed, not only the diff.
- Before directly editing code files, first share the edit approach with the user; proceed after approval or when the user explicitly instructs you to continue.

## Workspace Hygiene
- Clean up intermediate outputs and temporary files produced during conversion or verification once they are no longer needed.

## Knowledge Capture
- When a task produces research results, reusable knowledge, or non-obvious decisions worth preserving, create or update documentation by using the `document-workflow` skill.
- When a task needs documents, notes, research capture, or repository document management, use the `document-workflow` skill.
- When exploring repository documents, notes, or where relevant documentation should live, consider the `document-workflow` skill.
- In a Git repository, use the `document-workflow` skill when document rotation or its setup may need to be introduced or updated.
- When findings are worth preserving in repository documentation, do not wait for an explicit follow-up asking to save them; create or update the note before treating the task as complete.

## Tooling
- When a task becomes repetitive, improve efficiency by documenting the procedure as a manual or by turning it into a script when appropriate.
- When stable repetitive work becomes visible, consider consolidating the procedure into a script or tool.
- Place newly created scripts in a `tool/` directory.
- If a tool or script is intended to be used only by a specific skill, place it inside that skill's directory instead of a shared `tool/` directory.
- For each newly created script, include usage information in the file itself so the execution method, main arguments, and inputs/outputs are clear.

## Coding Style
- Prefer concise names as long as the meaning remains clear in context.
- Use abbreviations when they are stable within the project or domain, and keep each concept tied to one abbreviation consistently.
- Do not mix abbreviated and spelled-out forms for the same concept within the same codebase unless there is a strong reason.
- Avoid redundant names that repeat information already fixed by the class, module, receiver, or argument context.
- Prefer names that express the actual semantic role of a value or operation over names that merely restate its type.
- For public APIs, choose names based on caller-facing meaning rather than internal implementation details.
- For booleans, use names that read as states, predicates, or explicit switches.
