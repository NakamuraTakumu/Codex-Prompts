#!/usr/bin/env bash
#
# 使い方:
#   ./tool/rotate_document_before_commit.sh
#
# 目的:
#   設定されたディレクトリ配下の文書をコミット前にローテーションする。
#   - <dir>/previous/ を <dir>/<HEAD shortsha>-<HEAD slug>/ に確定する。
#   - <dir>/ 直下の現在の作業ファイルを <dir>/previous/ に移動する。
#
# ローテーションを安全に完了できない場合は non-zero で終了する。

set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

config_file="${ROTATE_DOCUMENT_CONFIG:-.document-rotation.env}"
if [[ -f "$config_file" ]]; then
  set -a
  # shellcheck disable=SC1090
  . "$config_file"
  set +a
fi

doc_dir="${ROTATE_DOCUMENT_DIR:-document}"
doc_dir="${doc_dir%/}"

validate_doc_dir() {
  local value="$1"

  if [[ -z "$value" ]]; then
    echo "rotate_document_before_commit: ROTATE_DOCUMENT_DIR は空にできません" >&2
    exit 1
  fi

  if [[ "$value" == /* || "$value" =~ (^|/)\.\.?($|/) ]]; then
    echo "rotate_document_before_commit: ROTATE_DOCUMENT_DIR は repository root からの安全な相対パスにしてください: $value" >&2
    exit 1
  fi
}

validate_doc_dir "$doc_dir"

previous_dir="$doc_dir/previous"

if [[ ! -d "$doc_dir" ]]; then
  exit 0
fi

has_head=0
if git rev-parse --verify HEAD >/dev/null 2>&1; then
  has_head=1
fi

slugify_head() {
  git log -1 --format=%f HEAD
}

finalize_previous() {
  local shortsha slug archive_dir

  [[ -d "$previous_dir" ]] || return 0

  shortsha=$(git rev-parse --short HEAD)
  slug=$(slugify_head)
  archive_dir="$doc_dir/${shortsha}-${slug}"

  if [[ -e "$archive_dir" ]]; then
    echo "rotate_document_before_commit: archive already exists: $archive_dir" >&2
    exit 1
  fi

  mv "$previous_dir" "$archive_dir"
}

merge_dir_into_dir() {
  local src dst child
  src="$1"
  dst="$2"

  mkdir -p "$dst"

  shopt -s nullglob dotglob
  for child in "$src"/*; do
    local base target
    base=$(basename "$child")
    target="$dst/$base"

    if [[ -e "$target" ]]; then
      if [[ -d "$child" && -d "$target" ]]; then
        merge_dir_into_dir "$child" "$target"
        rmdir "$child"
      else
        echo "rotate_document_before_commit: 移動先は既に存在します: $target" >&2
        exit 1
      fi
    else
      mv "$child" "$target"
    fi
  done
  shopt -u nullglob dotglob
}

move_root_entries_to_previous() {
  local moved=0 path
  mkdir -p "$previous_dir"

  shopt -s nullglob dotglob
  for path in "$doc_dir"/*; do
    local base
    base=$(basename "$path")

    if [[ "$base" == "previous" ]]; then
      continue
    fi

    if [[ -d "$path" && "$base" =~ ^[0-9a-f]{7,40}- ]]; then
      continue
    fi

    if [[ -d "$path" && -d "$previous_dir/$base" ]]; then
      merge_dir_into_dir "$path" "$previous_dir/$base"
      rmdir "$path"
    else
      mv "$path" "$previous_dir"/
    fi
    moved=1
  done
  shopt -u nullglob dotglob

  if [[ "$moved" -eq 0 ]]; then
    rmdir "$previous_dir" 2>/dev/null || true
  fi
}

if [[ "$has_head" -eq 1 ]]; then
  finalize_previous
fi

move_root_entries_to_previous
