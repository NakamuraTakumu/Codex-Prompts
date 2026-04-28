# 文書ローテーション参照

## 想定される挙動

これは Git リポジトリ内の `document/` に対する既定ワークフローである。

このワークフローは、一時的な作業文書を Git に残したいが、コミットをまたいで `document/` 直下に未管理ファイルを放置したくないリポジトリのためのもの。

現在のコード状態やコミット履歴から独立して有用であるべき記録には `knowledge/` を使う。

このモデルは世代単位で考える:

- 現在世代:
  - `document/` 直下のファイル
- 保留世代:
  - `document/previous/` 配下のファイル
- 確定世代:
  - `document/<shortsha>-<slug>/` 配下のファイル

確定世代は directory として判定する。`document/` 直下の file は名前が `<shortsha>-<slug>` 形式でも現在世代として扱う。

ローテーション管理すべきでない文書がある場合は、`knowledge/` に置くか、明示的な代替ワークフローを使う。

## ローテーション時点

ローテーションはコミット後ではなくコミット前に実行する。

理由:
- コミットがローテーション済み状態を直接記録する
- コミット後も working tree が clean なまま残る
- 追跡済みファイルがコミット後に削除されない

`pre-commit` ローテーションを標準選択肢として扱う。追跡済みファイルの `post-commit` cleanup を既定にしない。

リポジトリに明示的な文書ワークフローが既にある場合は、この方式を強制せず既存方式を保つ。

## コミット時の動作

1. `document/previous/` が存在し、`HEAD` も存在する場合、それを `document/<HEAD shortsha>-<HEAD slug>/` に移動する。
2. `document/` 直下の作業ファイルを `document/previous/` に移動する。
3. コミット継続前に、移動後の tracked changes と untracked files を stage する。

`pre-commit` はローテーション対象ディレクトリ配下の未 stage 変更と untracked files を自動でローテーションする。移動後の tracked changes と、移動後 path で `gitignore` 対象でない untracked files は stage する。移動後 path で `gitignore` 対象の untracked files は移動するが stage しない。標準 hook はローテーション対象ディレクトリ配下の index を commit 直前に再構成し、部分 stage は保持しない。リポジトリがこの副作用を許容しない場合は、標準 hook をそのまま導入せず、明示的な代替ワークフローを使う。

ローテーション対象ディレクトリは repository root からの相対パスに限る。空文字、絶対パス、`.` または `..` path 成分を含むパスは拒否する。

## 最小ファイルセット

```text
.document-rotation.env
.githooks/pre-commit
tool/rotate_document_before_commit.sh
tool/setup_git_hooks.sh
```

これらのファイルは、再利用可能テンプレートとして次の場所に置く:

```text
assets/repo_document_rotation/
```

セットアップ時に各対象リポジトリへコピーする。

コピーには次を使う:

```text
scripts/install_document_rotation.sh
```

installer script を使わない場合は、次の形で hidden file を含めて直接コピーする。コピー後にリポジトリ固有の明示的な変更のために patch する必要がある場合を除き、hook や shell script の内容を手作業で打ち直さない。

```bash
cp -R /home/nakamura/.codex/skills/document-workflow/assets/repo_document_rotation/. <target_repo>/
chmod +x <target_repo>/.githooks/pre-commit <target_repo>/tool/rotate_document_before_commit.sh <target_repo>/tool/setup_git_hooks.sh
```

コピー後の `.document-rotation.env` ファイルが、対象ディレクトリを設定する場所である。`ROTATE_DOCUMENT_DIR=document` を既定として保ち、リポジトリが別 path を必要とする場合はこのコピー後ファイルを変更する。

## 標準 hook 形

```bash
#!/usr/bin/env bash

set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

config_file="${ROTATE_DOCUMENT_CONFIG:-.document-rotation.env}"
if [[ -f "$config_file" ]]; then
  set -a
  . "$config_file"
  set +a
fi

rotate_dir="${ROTATE_DOCUMENT_DIR:-document}"
rotate_dir="${rotate_dir%/}"

if [[ -z "$rotate_dir" ]]; then
  echo "pre-commit: ROTATE_DOCUMENT_DIR は空にできません" >&2
  exit 1
fi

if [[ "$rotate_dir" == /* || "$rotate_dir" =~ (^|/)\.\.?($|/) ]]; then
  echo "pre-commit: ROTATE_DOCUMENT_DIR は repository root からの安全な相対パスにしてください: $rotate_dir" >&2
  exit 1
fi

./tool/rotate_document_before_commit.sh
git add -u -- "$rotate_dir"
git ls-files --others --exclude-standard -z -- "$rotate_dir" | xargs -0 -r git add --
```

## 最小 setup 形

```bash
#!/usr/bin/env bash
set -euo pipefail

git config core.hooksPath .githooks
chmod +x .githooks/pre-commit
chmod +x tool/rotate_document_before_commit.sh
chmod +x tool/setup_git_hooks.sh
```

## 重要な制約

- `core.hooksPath` は自動では clone されない。
- hook path は clone ごとに設定する必要がある。
- リポジトリレベルの setup script が、これを再現可能にする最も単純な方法である。
- テンプレートの導入と hook の有効化は別ステップである。
- 追跡済みファイルの `post-commit` cleanup は可能だが、リポジトリを dirty にするため推奨しない。
- `document/<HEAD shortsha>-<HEAD slug>/` が既に存在する場合は、`previous/` を混ぜずに non-zero で停止する。

## 記録メタデータ

Markdown 記録のメタデータ field、順序、取得不能時の扱いは `SKILL.md` の **Markdown メタデータ** を正本とする。ローテーション仕様側ではメタデータ field set を重複定義しない。
