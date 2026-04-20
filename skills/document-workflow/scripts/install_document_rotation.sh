#!/usr/bin/env bash
#
# Usage:
#   ./scripts/install_document_rotation.sh [target_repo]
#   ./scripts/install_document_rotation.sh --force [target_repo]
#
# Purpose:
#   Copy the document rotation templates from this skill into a target
#   repository. By default, the current working directory is used.

set -euo pipefail

force=0
if [[ "${1:-}" == "--force" ]]; then
  force=1
  shift
fi

target_repo="${1:-$PWD}"
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
skill_dir=$(cd "$script_dir/.." && pwd)
template_dir="$skill_dir/assets/repo_document_rotation"

if [[ ! -d "$target_repo/.git" ]]; then
  echo "install_document_rotation: target is not a git repository: $target_repo" >&2
  exit 1
fi

copy_file() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  if [[ -e "$dest" && "$force" -ne 1 ]]; then
    echo "install_document_rotation: destination already exists: $dest" >&2
    echo "install_document_rotation: rerun with --force to overwrite" >&2
    exit 1
  fi

  cp "$src" "$dest"
}

copy_file "$template_dir/.githooks/pre-commit" "$target_repo/.githooks/pre-commit"
copy_file \
  "$template_dir/.document-rotation.env" \
  "$target_repo/.document-rotation.env"
copy_file \
  "$template_dir/tool/rotate_document_before_commit.sh" \
  "$target_repo/tool/rotate_document_before_commit.sh"
copy_file \
  "$template_dir/tool/setup_git_hooks.sh" \
  "$target_repo/tool/setup_git_hooks.sh"

chmod +x \
  "$target_repo/.githooks/pre-commit" \
  "$target_repo/tool/rotate_document_before_commit.sh" \
  "$target_repo/tool/setup_git_hooks.sh"

echo "Installed document rotation templates into: $target_repo"
echo "Run ./tool/setup_git_hooks.sh inside that repository to activate the hooks for this clone."
