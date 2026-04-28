#!/usr/bin/env bash
set -euo pipefail

# 使い方:
#   extract_session_metadata.sh [--thread-id <id>] [--sessions-root <dir>] [--format markdown|json]
#
# 目的:
#   現在の Codex セッションログを読み、config.toml に依存せず
#   記録用メタデータ field を出力する。
#
# 入力:
#   --thread-id <id>      任意。既定値は $CODEX_THREAD_ID。
#   --sessions-root <dir> 任意。既定値は /home/nakamura/.codex/sessions。
#   --format <fmt>        任意。markdown または json。既定値は markdown。
#
# 出力:
#   Model、Reasoning-Effort、Session のメタデータを stdout に書く。
#   markdown format では、Created/Updated の後に挿入できる形式で出力する。

thread_id="${CODEX_THREAD_ID:-}"
sessions_root="/home/nakamura/.codex/sessions"
format="markdown"

require_value() {
  local option="$1"
  local value="${2:-}"

  if [[ -z "$value" ]]; then
    echo "$option には値が必要です。" >&2
    exit 1
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --thread-id)
      require_value "$1" "${2:-}"
      thread_id="${2:-}"
      shift 2
      ;;
    --sessions-root)
      require_value "$1" "${2:-}"
      sessions_root="${2:-}"
      shift 2
      ;;
    --format)
      require_value "$1" "${2:-}"
      format="${2:-}"
      shift 2
      ;;
    -h|--help)
      sed -n '1,18p' "$0"
      exit 0
      ;;
    *)
      echo "不明な argument: $1" >&2
      exit 1
      ;;
  esac
done

missing_commands=()
for command_name in find rg jq; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    missing_commands+=("$command_name")
  fi
done

if [[ "${#missing_commands[@]}" -gt 0 ]]; then
  echo "必要な command が見つかりません: ${missing_commands[*]}" >&2
  exit 1
fi

if [[ -z "$thread_id" ]]; then
  echo "CODEX_THREAD_ID が未設定で、--thread-id も指定されていません。" >&2
  exit 1
fi

if [[ ! -d "$sessions_root" ]]; then
  echo "sessions root が見つかりません: $sessions_root" >&2
  exit 1
fi

session_file="$(
  find "$sessions_root" -type f -name "*${thread_id}*.jsonl" | sort | tail -n 1
)"

if [[ -z "$session_file" ]]; then
  echo "thread に対応する session log が見つかりません: $thread_id" >&2
  exit 1
fi

turn_context_line="$(rg '"type":"turn_context"' "$session_file" | tail -n 1 || true)"

if [[ -z "$turn_context_line" ]]; then
  echo "session log に turn_context entry が見つかりません: $session_file" >&2
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
    echo "未対応の format: $format" >&2
    exit 1
    ;;
esac
