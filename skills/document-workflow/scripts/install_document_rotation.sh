#!/usr/bin/env bash
#
# 使い方:
#   ./scripts/install_document_rotation.sh [target_repo]
#   ./scripts/install_document_rotation.sh --force [target_repo]
#
# 目的:
#   このスキルの文書ローテーションテンプレートを対象リポジトリに
#   コピーする。既定では現在の作業ディレクトリを使う。
#   --force はテンプレート導入対象ファイルを上書きする。
#   コピー先が directory の場合は --force でも停止する。

set -euo pipefail

force=0
if [[ "${1:-}" == "--force" ]]; then
  force=1
  shift
fi

target_arg="${1:-$PWD}"
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
skill_dir=$(cd "$script_dir/.." && pwd)
template_dir="$skill_dir/assets/repo_document_rotation"

if ! target_repo=$(git -C "$target_arg" rev-parse --show-toplevel 2>/dev/null); then
  echo "install_document_rotation: 対象は Git リポジトリではありません: $target_arg" >&2
  exit 1
fi

sources=(
  "$template_dir/.githooks/pre-commit"
  "$template_dir/.document-rotation.env"
  "$template_dir/tool/rotate_document_before_commit.sh"
  "$template_dir/tool/setup_git_hooks.sh"
)

destinations=(
  "$target_repo/.githooks/pre-commit"
  "$target_repo/.document-rotation.env"
  "$target_repo/tool/rotate_document_before_commit.sh"
  "$target_repo/tool/setup_git_hooks.sh"
)

if [[ "$force" -ne 1 ]]; then
  conflicts=()
  for dest in "${destinations[@]}"; do
    if [[ -e "$dest" ]]; then
      conflicts+=("$dest")
    fi
  done

  if [[ "${#conflicts[@]}" -gt 0 ]]; then
    echo "install_document_rotation: コピー先が既に存在するため、何もコピーしません:" >&2
    printf '  %s\n' "${conflicts[@]}" >&2
    echo "install_document_rotation: 上書きするには --force 付きで再実行してください" >&2
    exit 1
  fi
fi

copy_file() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  if [[ -d "$dest" ]]; then
    echo "install_document_rotation: コピー先は directory のため上書きできません: $dest" >&2
    exit 1
  fi

  cp "$src" "$dest"
}

for i in "${!sources[@]}"; do
  copy_file "${sources[$i]}" "${destinations[$i]}"
done

chmod +x \
  "$target_repo/.githooks/pre-commit" \
  "$target_repo/tool/rotate_document_before_commit.sh" \
  "$target_repo/tool/setup_git_hooks.sh"

echo "文書ローテーションテンプレートを導入しました: $target_repo"
echo "この clone の hook を有効化するには、そのリポジトリ内で ./tool/setup_git_hooks.sh を実行してください。"
