---
name: document-workflow
description: 任意の Git リポジトリで使う。`document/` は標準の document-workflow ローテーションモデルで管理されるものとして扱い、必要なファイルや設定が欠けている場合は、リポジトリに明示的な代替方式がある場合またはユーザーが変更しないよう明示した場合を除き、標準設定を導入する。記録をリポジトリ内文書に置くか、グローバルな `/home/nakamura/.codex/document/` に置くかも判断する。
---

# ドキュメントワークフロー

任意の Git リポジトリでこのスキルを使う。

`document/` は、標準の document-workflow ローテーションモデルで管理されるものとして扱う。

標準の document-workflow 用ファイルまたは設定が欠けている場合は、リポジトリに明示的な代替方式がある場合またはユーザーが変更しないよう明示した場合を除き、それらを導入する。

このスキルは文書の内容そのものではなく、文書管理方針とリポジトリワークフローを扱う。

典型的な場面:
- 標準 document-workflow 設定がまだない Git リポジトリに入ったとき
- 記録をリポジトリの `document/` に置くか、`/home/nakamura/.codex/document/` に置くか判断するとき
- リポジトリの記録を `document/` と `knowledge/` のどちらに置くか判断するとき
- リポジトリ文書ローテーションを導入または更新するとき
- 文書処理用の `.githooks/`、`tool/setup_git_hooks.sh`、関連スクリプトを設定するとき
- 新しいリポジトリを作成し、文書保存規則を整えるとき
- 複数リポジトリの document-workflow 設定を標準化するとき
- リポジトリが文書メモや一時作業文書を使っているのに、document-workflow 設定が未導入だと分かったとき

## 保存方針

- 保存クラスを場所より先に決める。まず `document/` と `knowledge/` のどちらかを決め、その後でリポジトリ内かグローバルかを決める。
- 現在のコード状態、現在のブランチ状態、または特定コミットに依存する記録や文書には `document/` を使う。
- コードが変わっても有用であるべき記録には `knowledge/` を使う。例: 再利用できる知見、安定した参照情報、一般的な教訓。
- あるワークスペースまたはリポジトリに固有の記録は、そのワークスペースのローカル `document/` ディレクトリに保存する。
- 特定のワークスペースまたはリポジトリに結び付かない記録は、`/home/nakamura/.codex/document/` に保存する。
- リポジトリ作業中に得た記録でも、内容がそのリポジトリのコードや状態ではなく、エージェントの作業手順、ワークフロー上の失敗、再利用できる運用指針に関するものなら、グローバル扱いとして `/home/nakamura/.codex/document/` に保存する。
- リポジトリパス、ブランチ、コミット、現在のコード詳細を取り除いても記録が有用なら、グローバル扱いにする。
- 1 つのスレッドでリポジトリ固有の知見とグローバルなプロセス知見の両方が出た場合は、1 つの場所へ無理にまとめず、別々の記録に分けて適切な場所へ保存する。
- 混在した知見の分割は、両方が単独で再利用価値を持つ場合だけ行う。それ以外は主な記録を維持し、もう一方の場所への一行の参照を加える。
- `/home/nakamura/.codex/document/` に保存する記録は、明確な理由がない限り日本語で書く。
- 実質的な調査結果、明示的な文書化依頼、再利用できる知見、または自明でない知見は、ユーザーが明示的に記録しないよう求めた場合を除き記録する。
- 非自明な調査、比較、意思決定、ワークフロー設計、再利用できるトラブルシューティングを含むタスクでは、既定で短い Markdown 記録を保存する。
- 簡潔であることを記録省略の理由にしない。保存する価値がある結果は、省略せず短い記録として保存する。
- 現在のタスクが既存の文書化済みスレッドを継続、精緻化、訂正する場合は、関連する既存 Markdown 記録の更新を優先する。
- 後で重要になりにくい軽量または一回限りの質問には、新しい保存記録は不要。ただし、関連する既存記録を更新した方が文書を最新に保てる場合は更新してよい。
- 文書ファイル名には既定で日付を入れない。安定した説明的な名前を優先し、日付は版や時系列を区別する実質的な助けになる場合を除きメタデータに置く。

## Markdown メタデータ

Markdown 記録を作成または更新するときは、ユーザーが明示的に別形式を求めた場合を除き、ファイル冒頭付近に次の標準構造を使う。

メタデータブロックはこの順序にする:
- `Created:` 作成タイムスタンプ
- `Updated:` 最終更新タイムスタンプ
- `Model:` 記録の作成または改訂に使ったモデル
- `Reasoning-Effort:` `low`、`medium`、`high`、`xhigh` などの Codex 推論レベル
- `Session:` 利用できる場合のセッション ID
- `Repository:` 関連する場合のリポジトリ名またはパス
- `Related-Commit:` 記録が特定コード状態に依存する場合のコミット hash

メタデータブロックの後に含めるもの:
- 必須の一行 `Purpose:` 行
- 必須の `## Background` セクション
- 必須の `## Content` セクション
- 最後に置く必須の `## References` セクション

`Purpose:` は、その文書を保存または作成する価値を一文で述べる。
`Purpose:` はトピックの言い換えでも `Background` の重複でもない。将来のどの判断、レビュー、引き継ぎ、再現を支えるための記録かなど、保持理由を書く。

`## Background` はこの正確な見出し名で置き、記録の状況、きっかけ、事実関係を短く説明する。後の読者が保存結果を正しく解釈できるようにするためである。

`## Background` は簡潔に保つ。中核となる事実、判断、制約、根拠、再現情報を残す。

`## Content` は `## Background` の後にこの正確な見出し名で置く。調査結果、手順、判断、比較、その他タスク固有の内容など、文書の主内容を書く。

`## References` は文書末尾にこの正確な見出し名で置く。
現時点では、ウェブページ、論文、標準、その他の外部文書など、外部参照だけを列挙する。
ユーザーが後で変更を求めない限り、内部リポジトリ文書、ローカル記録、その他ワークスペース内部ファイルは `## References` に列挙しない。

文書全体は簡潔に保つ。検証、再現、将来の判断に必要でない限り、中核点から推測できる副次的詳細は省く。タスクログ全体を繰り返さず、主要な提案や判断から明らかな結論を言い直さず、文書の目的が明確に必要とする場合を除き、実装差分、推奨文言、レビュー記録など近接する別成果物を含めない。

利用できる場合はプレースホルダーより実際の実行時値を優先する:
- `Model:` と `Reasoning-Effort:` は、`/home/nakamura/.codex/sessions/` 配下の session log にある現在スレッドの最新 `turn_context` entry から読む
- `Session:` には `CODEX_THREAD_ID` を使う
- 値を取得できない場合は、プレースホルダーを作らず、その旨を明示する

推奨補助:
- `scripts/extract_session_metadata.sh` を使うと、`config.toml` に依存せず、`Created:` / `Updated:` の後に挿入する現在スレッドの `Model:`、`Reasoning-Effort:`、`Session:` を出力できる

例:

```bash
/home/nakamura/.codex/skills/document-workflow/scripts/extract_session_metadata.sh
```

標準テンプレート:

```md
# 題名

- Created: 2026-04-19 08:00 UTC
- Updated: 2026-04-19 08:00 UTC
- Model: gpt-5.4
- Reasoning-Effort: medium
- Session: <利用できる場合の session-id>
- Repository: <repo 名または path>
- Related-Commit: <関連する場合のコミット>

Purpose: <この文書を保存すべき理由、または支援する将来作業を一文で書く>

## Background

この記録は <中核となる状況または判断> を残す。後の読者が保存結果を正しく解釈できるよう、直近の設定、きっかけ、制約を説明する。

## Content

<文書の主内容を書く>

## References

- <外部参照 1>
- <外部参照 2>
```

## リポジトリ文書ローテーション

`references/document_rotation.md` を、`document/` ローテーションの詳細仕様の正本とする。

- `document/` は既定でローテーション管理領域として扱う。
- ローテーション管理しない文書は、`knowledge/` またはリポジトリの明示的な代替ワークフローへ分ける。
- `document/previous/` と `document/<shortsha>-<slug>/` はローテーション済み snapshot として扱う。
- ユーザーが明示的にアーカイブファイルの修正を求めた場合を除き、ローテーション済み snapshot ディレクトリ内のファイルは編集しない。
- 明示的な対象パスなしで新しい artifact や作業文書を作る場合は、active な `document/` 直下の新しいパスに置く。
- コミット時の移動、stage、clone 後の hook 有効化などの詳細は `references/document_rotation.md` に従う。

## 実装パターン

リポジトリ設定では、この分割を優先する:

- `.document-rotation.env`
  - ローテーション対象ディレクトリを定義する、リポジトリローカル設定ファイル
- `.githooks/pre-commit`
  - 設定を読み、ローテーションスクリプトを呼び、設定ディレクトリをステージする薄いラッパー
- `tool/rotate_document_before_commit.sh`
  - 主な文書ローテーションロジック
- `tool/setup_git_hooks.sh`
  - `core.hooksPath` を `.githooks` に設定し、実行ビットを直す一回限りのセットアップ
- `assets/repo_document_rotation/`
  - セットアップ時に対象リポジトリへコピーするテンプレートファイル
- `scripts/install_document_rotation.sh`
  - テンプレートファイルをリポジトリにコピーする補助スクリプト

導入方法:
- 既定では、準備済みテンプレートファイルを `assets/repo_document_rotation/` からコピーする。
- リポジトリにそのまま合う場合は、`scripts/install_document_rotation.sh` を優先する。
- 推奨実行形は `/home/nakamura/.codex/skills/document-workflow/scripts/install_document_rotation.sh <target_repo>` とする。
- `scripts/install_document_rotation.sh` は非 `--force` 実行では既存コピー先を事前検出し、衝突があれば何もコピーせず終了する。
- `--force` はテンプレート導入対象ファイルを上書きするため、既存の `pre-commit` ワークフローを置き換える意図がある場合だけ使う。
- コピー先が directory の場合は、`--force` でも置換せず停止する。
- 手動導入パスが必要な場合でも、`cp -R /home/nakamura/.codex/skills/document-workflow/assets/repo_document_rotation/. <target_repo>/` で hidden file を含めてコピーする。スクリプトファイルを最初から打ち直さない。
- 手動導入後は `chmod +x <target_repo>/.githooks/pre-commit <target_repo>/tool/rotate_document_before_commit.sh <target_repo>/tool/setup_git_hooks.sh` を実行する。
- リポジトリ固有パスをスクリプトにハードコードせず、コピー後の `.document-rotation.env` を編集してローテーション対象を設定する。
- コピー済みファイルへの修正はコピーステップの後だけ行い、リポジトリが明示的な変更を必要とする場合に限る。

## Clone 時の挙動

clone 時の hook 有効化の仕様は `references/document_rotation.md` に従う。clone 時の挙動について聞かれたら、リポジトリファイルは clone されるが Git hook の有効化は clone されない、と明示する。

## 実装時

文書ローテーションを追加するためにリポジトリを編集する前に:
1. リポジトリに `.githooks/`、`tool/`、既存コミットワークフローがあるか確認する。
2. `references/document_rotation.md` で詳細仕様を確認する。
3. 標準 document-workflow 設定が欠けている場合は、ユーザーが不足ファイルを明示的に挙げるのを待たず、既定で導入方針を作る。
4. 導入方針と対象ファイルを提示し、ユーザーの承認または明示的な続行指示後にコピーまたは編集する。
5. `scripts/install_document_rotation.sh` を使い、`assets/repo_document_rotation/` からテンプレートをコピーすることを優先する。
6. リポジトリに既存の `pre-commit` ワークフローがある場合は、盲目的に上書きせず手動で統合する。
7. installer script を使わない場合は、`assets/repo_document_rotation/` から必要ファイルを `cp` でコピーする。`.document-rotation.env`、`.githooks/pre-commit`、`tool/rotate_document_before_commit.sh`、`tool/setup_git_hooks.sh` を手作業で再作成しない。
8. コピー後の `.document-rotation.env` を編集して対象パスを設定する。リポジトリが明示的に別ディレクトリを必要としない限り、`ROTATE_DOCUMENT_DIR=document` を既定として保つ。
9. リポジトリ固有の変更のために patch する場合も、テンプレートコピー後に限る。
10. clone 後に `./tool/setup_git_hooks.sh` を実行する必要があることを、リポジトリ documentation に短く書く。
