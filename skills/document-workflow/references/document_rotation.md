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

## 導入前確認

文書ローテーションを導入または更新する前に、対象リポジトリで次を確認する:

- `.githooks/` の有無
- `tool/` の有無
- 既存の commit workflow
- 明示的な代替文書 workflow
- 標準 hook がローテーション対象ディレクトリ配下の index を commit 直前に再構成し、部分 stage を保持しない副作用を許容できるか

ファイル作成、上書き、既存 workflow 統合が必要な場合は、導入方針と対象ファイルを示し、ユーザーの承認または明示的な続行指示を待つ。

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

## 導入手順

1. 対象リポジトリで **導入前確認** を行う。
2. `/home/nakamura/.codex/skills/document-workflow/scripts/install_document_rotation.sh <target_repo>` を優先して使う。
3. 非 `--force` 実行でコピー先衝突が出た場合は、何もコピーせず、統合方針を決める。
4. `--force` は既存の `pre-commit` workflow を置き換える意図がある場合だけ使う。
5. installer を使わない場合は、`assets/repo_document_rotation/` から hidden file を含めてコピーする。
6. リポジトリ固有の変更が必要な場合は、template コピー後に `.document-rotation.env` またはコピー済みファイルを patch する。
7. clone 後に `./tool/setup_git_hooks.sh` を実行する必要があることを、最終報告または repository documentation で案内する。

## 標準 hook

標準 hook の正本は `assets/repo_document_rotation/.githooks/pre-commit` とする。

hook は `.document-rotation.env` または `ROTATE_DOCUMENT_CONFIG` で指定された設定を読み、`ROTATE_DOCUMENT_DIR` を安全な repository root 相対パスとして検証し、`tool/rotate_document_before_commit.sh` を実行する。その後、ローテーション対象ディレクトリ配下の tracked changes と、`gitignore` 対象でない untracked files を stage する。

## 最小 setup

clone ごとの hook 有効化の正本は `assets/repo_document_rotation/tool/setup_git_hooks.sh` とする。

setup script は `core.hooksPath` を `.githooks` に設定し、標準 hook とローテーションスクリプトの実行ビットを直す。

## 重要な制約

- `core.hooksPath` は自動では clone されない。
- hook path は clone ごとに設定する必要がある。
- リポジトリレベルの setup script が、これを再現可能にする最も単純な方法である。
- テンプレートの導入と hook の有効化は別ステップである。
- 追跡済みファイルの `post-commit` cleanup は可能だが、リポジトリを dirty にするため推奨しない。
- `document/<HEAD shortsha>-<HEAD slug>/` が既に存在する場合は、`previous/` を混ぜずに non-zero で停止する。

## 記録メタデータ

Markdown 記録のメタデータ field、順序、取得不能時の扱いは `SKILL.md` の **Markdown 記録を書く > 書式契約** を正本とする。ローテーション仕様側ではメタデータ field set を重複定義しない。
