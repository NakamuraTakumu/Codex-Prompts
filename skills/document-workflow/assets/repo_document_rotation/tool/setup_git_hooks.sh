#!/usr/bin/env bash
#
# 使い方:
#   ./tool/setup_git_hooks.sh
#
# 目的:
#   このリポジトリが .githooks/ 配下で version 管理された hook を
#   使うように設定する。

set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

git config core.hooksPath .githooks
chmod +x .githooks/pre-commit
chmod +x tool/rotate_document_before_commit.sh
chmod +x tool/setup_git_hooks.sh

echo "core.hooksPath=.githooks を設定しました"
