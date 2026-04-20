#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   extract_session_metadata.sh [--thread-id <id>] [--sessions-root <dir>] [--format markdown|json]
#
# Purpose:
#   Read the current Codex session log and print note metadata fields without
#   relying on config.toml.
#
# Inputs:
#   --thread-id <id>      Optional. Defaults to $CODEX_THREAD_ID.
#   --sessions-root <dir> Optional. Defaults to /home/nakamura/.codex/sessions.
#   --format <fmt>        Optional. One of: markdown, json. Defaults to markdown.
#
# Output:
#   Writes metadata for Model, Reasoning-Effort, and Session to stdout.
#   In markdown format, the output is suitable for direct insertion into a note.

thread_id="${CODEX_THREAD_ID:-}"
sessions_root="/home/nakamura/.codex/sessions"
format="markdown"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --thread-id)
      thread_id="${2:-}"
      shift 2
      ;;
    --sessions-root)
      sessions_root="${2:-}"
      shift 2
      ;;
    --format)
      format="${2:-}"
      shift 2
      ;;
    -h|--help)
      sed -n '1,18p' "$0"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if [[ -z "$thread_id" ]]; then
  echo "CODEX_THREAD_ID is not set and --thread-id was not provided." >&2
  exit 1
fi

if [[ ! -d "$sessions_root" ]]; then
  echo "Sessions root not found: $sessions_root" >&2
  exit 1
fi

session_file="$(
  find "$sessions_root" -type f -name "*${thread_id}*.jsonl" | sort | tail -n 1
)"

if [[ -z "$session_file" ]]; then
  echo "Session log not found for thread: $thread_id" >&2
  exit 1
fi

turn_context_line="$(rg -m 1 '"type":"turn_context"' "$session_file" || true)"

if [[ -z "$turn_context_line" ]]; then
  echo "No turn_context entry found in session log: $session_file" >&2
  exit 1
fi

model="$(
  printf '%s\n' "$turn_context_line" |
    jq -r '.payload.model // "unavailable (payload.model missing)"'
)"

reasoning="$(
  printf '%s\n' "$turn_context_line" |
    jq -r '.payload.collaboration_mode.settings.reasoning_effort // .payload.effort // "unavailable (reasoning effort missing)"'
)"

case "$format" in
  markdown)
    printf -- '- Model: %s\n' "$model"
    printf -- '- Reasoning-Effort: %s\n' "$reasoning"
    printf -- '- Session: %s\n' "$thread_id"
    ;;
  json)
    jq -n \
      --arg model "$model" \
      --arg reasoning_effort "$reasoning" \
      --arg session "$thread_id" \
      '{model: $model, reasoning_effort: $reasoning_effort, session: $session}'
    ;;
  *)
    echo "Unsupported format: $format" >&2
    exit 1
    ;;
esac
