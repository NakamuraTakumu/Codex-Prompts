# Document Workflow Mechanism

- Created: 2026-04-19 09:12:47 UTC
- Updated: 2026-04-19 09:18:45 UTC
- Model: gpt-5.4
- Reasoning-Effort: high
- Session: 019da41a-c86a-74d2-9e86-ecd68de45f38
- Repository: global
- Related-Commit: n/a
- Status: active

## Overview

このメモは、現在のドキュメント管理の標準運用をまとめたものである。

考え方は単純で、文書を二種類に分ける。

- `document/`
  - 現在のコード状態、branch 状態、または特定 commit に依存する文書
  - commit に合わせて回転させる
- `knowledge/`
  - コード状態に依存せず、将来も再利用したい知識
  - 回転させない

## Role Split

### `AGENTS.md`

`AGENTS.md` は導線だけを持つ。

- ドキュメント、ノート、調査結果の記録、またはリポジトリのドキュメント管理が必要になったら `document-workflow` skill を使う
- Git リポジトリで標準 setup が無ければ導入する

詳細な保存先、rotation、テンプレート、clone 後の操作、メタデータ規約は skill 側に置く。

### `document-workflow` skill

`document-workflow` skill は実際の運用ルールを持つ。

対象:
- `document/` と `knowledge/` の使い分け
- `document/` の rotation
- `.githooks/` と `tool/` の標準構成
- clone 後の有効化手順
- Markdown メタデータ規約

## Main Files

- Global guide:
  - `/home/nakamura/.codex/AGENTS.md`
- Skill:
  - `/home/nakamura/.codex/skills/document-workflow/SKILL.md`
- Reference:
  - `/home/nakamura/.codex/skills/document-workflow/references/document_rotation.md`
- Templates:
  - `/home/nakamura/.codex/skills/document-workflow/assets/repo_document_rotation/`
- Installer:
  - `/home/nakamura/.codex/skills/document-workflow/scripts/install_document_rotation.sh`

## Storage Rules

### `document/`

ここには、今のコードや commit に結びつく文書を置く。

例:
- 作業中メモ
- その時点の修正理由
- commit 単位で履歴化したい検討メモ

### `knowledge/`

ここには、コードが変わっても有用な知識を置く。

例:
- 再利用可能な調査結果
- 安定した参照情報
- 一般化された教訓
- 将来もそのまま使いたいノート

## Rotation Model

`document/` は既定で rotation 管理対象であり、構造は次のとおり。

```text
document/
  previous/
  <shortsha>-<slug>/
```

意味:
- `document/` 直下:
  - 現在作業中の文書
- `document/previous/`:
  - 次の commit で確定対象になる文書
- `document/<shortsha>-<slug>/`:
  - 過去 commit に対応する確定済み文書

pre-commit 時の動作:
1. `document/previous/` があり、`HEAD` が存在すれば、それを `document/<HEAD shortsha>-<HEAD slug>/` に移す
2. `document/` 直下の作業中ファイルを `document/previous/` に移す
3. `document/` の変更を stage して commit を続行する

## Standard Repository Setup

標準構成は次の三つである。

```text
.githooks/pre-commit
tool/rotate_document_before_commit.sh
tool/setup_git_hooks.sh
```

導入手順:
1. `install_document_rotation.sh` でテンプレートを対象 repo にコピーする
2. 対象 repo で `./tool/setup_git_hooks.sh` を実行する

重要:
- テンプレートのコピーと hook の有効化は別段階
- `.githooks/` と `tool/` は clone される
- `core.hooksPath` の設定は clone では引き継がれない

## Operational Defaults

現在の標準運用は次のとおり。

- Git リポジトリでは `document-workflow` skill を使う
- 標準 setup が無ければ導入する
- `document/` は rotation 管理領域として扱う
- 回転させたくない知識は `knowledge/` に置く
- 明示的な代替運用がある repo だけは例外とする

## Markdown Metadata Rule

この workflow で作成・更新する Markdown には、先頭近くに短いメタデータブロックを入れる。

推奨項目:
- `Created:`
- `Updated:`
- `Model:`
- `Reasoning-Effort:`
- `Session:`
- `Repository:`
- `Related-Commit:`
- `Status:`

取得方針:
- `Model` と `Reasoning-Effort` は、可能なら `/home/nakamura/.codex/sessions/` のセッションログから取る
- `Session` は `CODEX_THREAD_ID` を使う
- セッションログが取れない場合だけ `config.toml` を fallback にする
- 取れない値は推測せず、取得不可であることを明記する

## Practical Reading

実務上は次のように理解すればよい。

- コード依存の文書は `document/`
- コード非依存の知識は `knowledge/`
- ドキュメント管理の詳細は `document-workflow`
- `AGENTS.md` はその入口だけを持つ

## Caveats

- `document/` を含む commit は、部分 commit より全量 commit 前提で運用する方が安全
- 既存の pre-commit workflow がある repo では、単純上書きではなく手動統合が必要
- stable docs を `document/` に混ぜると rotation と衝突するので、その場合は `knowledge/` など別フォルダを使う
