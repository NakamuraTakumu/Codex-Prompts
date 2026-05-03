#!/usr/bin/env bash
set -euo pipefail

# 使い方:
#   generate_document_note.sh [options]
#   generate_document_note.sh --help
#
# 目的:
#   document-workflow 標準の Markdown 記録 skeleton を生成する。
#   timestamp、session metadata、repository metadata を可能な範囲で埋める。
#
# 入力:
#   --title <title>             任意。既定値は「題名」。
#   --responsibility <text>     任意。Responsibility 行の初期値。
#   --background <text>         任意。Background section の初期値。
#   --result <text>             任意。Result section の初期値。
#   --notes <text>              任意。Notes section の初期値。
#   --references <text>         任意。References section の初期値。
#   --repository <value|auto|none>
#                               任意。既定値は auto。
#   --related-commit <value|auto|none>
#                               任意。既定値は none。
#   --thread-id <id>            任意。既定値は $CODEX_THREAD_ID。
#   --sessions-root <dir>       任意。既定値は /home/nakamura/.codex/sessions。
#   --output <file>             任意。指定時は file に書く。未指定時は stdout。
#   --force                     任意。--output の既存 file を上書きする。
#
# 出力:
#   Markdown 記録 skeleton を stdout または --output file に書く。

title="題名"
responsibility="ユーザーが求めた結果に対して、この文書が何を整理、列挙、比較、説明、記録、または検証するかを一文で書く。"
background="この文書を作ることになった経緯を短く書く。"
result="Responsibility に直接対応する情報、一覧、まとめ、比較、説明、記録、または検証結果を書く。"
notes="Responsibility に直接対応しない補助情報を書く。"
references=""
repository="auto"
related_commit="none"
thread_id="${CODEX_THREAD_ID:-}"
sessions_root="/home/nakamura/.codex/sessions"
output=""
force=0

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

usage() {
  sed -n '1,35p' "$0"
}

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
    --title)
      require_value "$1" "${2:-}"
      title="$2"
      shift 2
      ;;
    --responsibility)
      require_value "$1" "${2:-}"
      responsibility="$2"
      shift 2
      ;;
    --background)
      require_value "$1" "${2:-}"
      background="$2"
      shift 2
      ;;
    --result)
      require_value "$1" "${2:-}"
      result="$2"
      shift 2
      ;;
    --notes)
      require_value "$1" "${2:-}"
      notes="$2"
      shift 2
      ;;
    --references)
      require_value "$1" "${2:-}"
      references="$2"
      shift 2
      ;;
    --repository)
      require_value "$1" "${2:-}"
      repository="$2"
      shift 2
      ;;
    --related-commit)
      require_value "$1" "${2:-}"
      related_commit="$2"
      shift 2
      ;;
    --thread-id)
      require_value "$1" "${2:-}"
      thread_id="$2"
      shift 2
      ;;
    --sessions-root)
      require_value "$1" "${2:-}"
      sessions_root="$2"
      shift 2
      ;;
    --output)
      require_value "$1" "${2:-}"
      output="$2"
      shift 2
      ;;
    --force)
      force=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "不明な argument: $1" >&2
      exit 1
      ;;
  esac
done

timestamp="$(date -u '+%Y-%m-%d %H:%M UTC')"

metadata_output=""
if [[ -x "$script_dir/extract_session_metadata.sh" ]]; then
  metadata_output="$(
    "$script_dir/extract_session_metadata.sh" \
      --thread-id "${thread_id:-unavailable}" \
      --sessions-root "$sessions_root" \
      --format markdown 2>/dev/null || true
  )"
fi

model="$(printf '%s\n' "$metadata_output" | sed -n 's/^- Model: //p' | tail -n 1)"
reasoning="$(printf '%s\n' "$metadata_output" | sed -n 's/^- Reasoning-Effort: //p' | tail -n 1)"
session="$(printf '%s\n' "$metadata_output" | sed -n 's/^- Session: //p' | tail -n 1)"

if [[ -z "$model" ]]; then
  model="unavailable (session metadata could not be read)"
fi
if [[ -z "$reasoning" ]]; then
  reasoning="unavailable (session metadata could not be read)"
fi
if [[ -z "$session" ]]; then
  if [[ -n "$thread_id" ]]; then
    session="$thread_id"
  else
    session="unavailable (CODEX_THREAD_ID unset)"
  fi
fi

resolve_repository() {
  case "$repository" in
    auto)
      if command -v git >/dev/null 2>&1 && git_root=$(git rev-parse --show-toplevel 2>/dev/null); then
        printf '%s\n' "$git_root"
      else
        printf '%s\n' "none (not in a Git repository)"
      fi
      ;;
    none)
      printf '%s\n' "none"
      ;;
    *)
      printf '%s\n' "$repository"
      ;;
  esac
}

resolve_related_commit() {
  case "$related_commit" in
    auto)
      if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        git rev-parse HEAD 2>/dev/null || printf '%s\n' "unavailable (HEAD missing)"
      else
        printf '%s\n' "none (not in a Git repository)"
      fi
      ;;
    none)
      printf '%s\n' "none"
      ;;
    *)
      printf '%s\n' "$related_commit"
      ;;
  esac
}

repository_value="$(resolve_repository)"
related_commit_value="$(resolve_related_commit)"

render() {
  cat <<EOF
# $title

- Created: $timestamp
- Updated: $timestamp
- Model: $model
- Reasoning-Effort: $reasoning
- Session: $session
- Repository: $repository_value
- Related-Commit: $related_commit_value

Responsibility: $responsibility

## Background

$background

## Result

$result

## Notes

$notes

## References

$references
EOF
}

if [[ -n "$output" ]]; then
  if [[ -e "$output" && "$force" -ne 1 ]]; then
    echo "出力先が既に存在します。上書きするには --force を指定してください: $output" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$output")"
  render >"$output"
else
  render
fi
