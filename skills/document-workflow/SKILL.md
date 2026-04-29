---
name: document-workflow
description: Git リポジトリや Codex global 領域で、`document/` と `knowledge/` の保存先判断、Markdown 記録の作成・更新・参照、`document/` ローテーション導入または更新を扱うときに使う。
---

# ドキュメントワークフロー

## 対象

- **扱うこと**: 文書保存先の判断、Markdown 記録 skeleton、`document/` ローテーション、文書ワークフロー導入または更新。
- **扱わないこと**: 文書内容そのものの品質判断。内容レビューは別 skill またはタスク固有手順に従う。
- **既定モデル**: `document/` は標準 document-workflow ローテーションモデルで管理される領域として扱う。
- **既定導入**: 標準ファイルまたは設定が欠けている場合は、明示的な代替方式またはユーザーの禁止がない限り、導入方針を作る。

## 入力

- **対象リポジトリ**: ユーザーが指定した Git リポジトリ。未指定なら現在の作業リポジトリ。
- **対象記録**: 作成、更新、参照する Markdown 記録。未指定なら作業内容から候補を探す。
- **禁止事項**: ユーザーが記録保存、ローテーション導入、既存 file 変更を禁止した場合は従う。
- **入力不足**: 保存先、対象リポジトリ、または上書き可否を判断できない場合は、仮定で file を書かずに確認する。

## 使用場面

- 標準 document-workflow 設定がまだない Git リポジトリに入ったとき。
- 記録をリポジトリ内に置くか、グローバルな `/home/nakamura/.codex/document/` または `/home/nakamura/.codex/knowledge/` に置くか判断するとき。
- 記録を `document/` と `knowledge/` のどちらに置くか判断するとき。
- リポジトリ文書ローテーションを導入、更新、標準化するとき。
- 文書処理用の `.githooks/`、`tool/setup_git_hooks.sh`、関連スクリプトを設定するとき。
- リポジトリが文書メモや一時作業文書を使っているのに、document-workflow 設定が未導入だと分かったとき。

## 保存先選択

保存先は、**保存クラス**、**保存範囲**、**保存パス** の順に決める。

- **保存クラス**:
  - `document/`: 現在のコード状態、ブランチ状態、または特定コミットに依存する記録や文書。
  - `knowledge/`: コードが変わっても有用であるべき記録。例: 再利用できる知見、安定した参照情報、一般的な教訓。
- **保存範囲**:
  - **ローカル**: 特定のワークスペースまたはリポジトリに固有の記録。
  - **グローバル**: リポジトリパス、ブランチ、コミット、現在のコード詳細を取り除いても有用な記録。
- **保存パス**:
  - ローカル `document/`: 対象リポジトリの `document/`。
  - ローカル `knowledge/`: 対象リポジトリの `knowledge/`。
  - グローバル `document/`: `/home/nakamura/.codex/document/`。
  - グローバル `knowledge/`: `/home/nakamura/.codex/knowledge/`。

対象リポジトリが Git リポジトリとして確認できない場合は、ローカル保存先に書く前に保存先を確認する。

## 記録判断

- **記録する**: セッション内に、明示的な文書化依頼、再利用できる知見、非自明な調査、比較、意思決定、ワークフロー設計、再利用できるトラブルシューティングが含まれる場合。
- **省略する**: ユーザーが記録しないよう明示した場合、または後で重要になりにくい軽量または一回限りの質問の場合。
- **次の手順**: 記録すると判断した場合は、**保存先選択** と **Markdown 記録を書く** に進む。

## 分割規則

- 1 つのスレッドでリポジトリ固有の知見とグローバルなプロセス知見の両方が出た場合は、1 つの場所へ無理にまとめず、別々の記録に分ける。
- 混在した知見を分割するのは、両方が単独で再利用価値を持つ場合に限る。
- 分割しない場合は主な記録を維持し、もう一方の場所への一行の参照を加える。
- 内部文書、ローカル記録、ワークスペース内部ファイルへの cross-link は、**書式契約** の section 役割に従って置く。

## 文書形式

- `/home/nakamura/.codex/document/` または `/home/nakamura/.codex/knowledge/` に保存する記録は、明確な理由がない限り日本語で書く。
- 文書ファイル名には既定で日付を入れない。安定した説明的な名前を優先し、日付は版や時系列を区別する実質的な助けになる場合を除きメタデータに置く。
- 文書全体は簡潔に保つ。検証、再現、将来の判断に必要でない副次的詳細は省く。
- タスクログ全体、主要な提案や判断から明らかな結論の言い直し、近接する別成果物の内容は、文書の目的が明確に必要とする場合を除き含めない。

## Markdown 記録を書く

記録の書き方は `skills/common/structured_document_rule.md` を参照。

### 作成・更新の選択

Markdown 記録を書くときは、保存先を決めた後、関連する既存記録の有無と `Purpose:` で新規作成か更新かを決める。

- **新規作成**: 関連する既存記録がない場合。
- **既存更新**: 追加内容が既存記録の `Purpose:` を保ったまま、精緻化、根拠追加、誤記訂正、失効した記述の局所修正になる場合。
- **目的による分離**: 既存記録と対象、論点、またはスレッドが同じでも、`Purpose:` が示す保存価値、前提状態、または将来支える判断が変わる場合は新規作成する。例: 初回調査は原因特定、修正後の再調査は修正結果の検証を支えるため、原則として別記録にする。
- **参照追加**: 分離した継続調査、再調査、検証記録を既存記録からたどる必要がある場合は、既存記録の `## Background` または `## Content` に一行の cross-link だけを加える。

### 新規作成

Markdown 記録を新規作成するときは、ユーザーが明示的に別形式を求めた場合を除き、`scripts/generate_document_note.sh` で標準 skeleton を生成する。手作業で skeleton を書き起こさない。

推奨実行形:

```bash
/home/nakamura/.codex/skills/document-workflow/scripts/generate_document_note.sh --title "<題名>" --output <保存パス>/<slug>.md
```

`--output` には、**保存先選択** で決めた保存パスを使う。
`--output` を指定すると親 directory が作成される。既存 file は `--force` なしでは上書きされない。

よく使う option:
- `--purpose <text>`: `Purpose:` 行の初期値。
- `--background <text>`: `## Background` の初期値。
- `--content <text>`: `## Content` の初期値。
- `--references <text>`: `## References` の初期値。
- `--repository <value|auto|none>`: `Repository:` の値。既定値は `auto`。
- `--related-commit <value|auto|none>`: `Related-Commit:` の値。既定値は `none`。
- `--thread-id <id>`: session metadata を読む thread ID。既定値は `CODEX_THREAD_ID`。
- `--sessions-root <dir>`: session log 探索 root。既定値は `/home/nakamura/.codex/sessions`。
- `--output <file>`: skeleton の出力先。未指定時は stdout に書く。
- `--force`: 既存の `--output` file を上書きする。

完全な CLI は `scripts/generate_document_note.sh --help` で確認する。

script は `Created:`、`Updated:`、`Model:`、`Reasoning-Effort:`、`Session:`、`Repository:`、`Related-Commit:` を可能な範囲で埋める。値を取得できない場合は、placeholder ではなく取得不能理由を値として書く。

`scripts/extract_session_metadata.sh` は `scripts/generate_document_note.sh` の内部補助として扱う。Markdown 記録の新規作成では、session metadata だけを手で差し込む目的で直接使わない。

### 更新

既存 Markdown 記録を更新するときは、既存構造を保ち、`Updated:` と本文を必要最小限で更新する。

- `Created:` は保存する。
- `Updated:` は更新時刻へ変更する。
- 既存の `## References` は、不要になった外部参照を除き保存する。
- 新しい内容は、既存の主張を置き換える必要がある場合を除き、追記または局所編集で反映する。
- 標準構造が欠けている既存記録では、変更の意図を壊さない範囲で標準構造へ寄せる。

### 書式契約

メタデータ bullets は `scripts/generate_document_note.sh` の出力順を正本とする:
`Created`、`Updated`、`Model`、`Reasoning-Effort`、`Session`、`Repository`、`Related-Commit`。

メタデータブロックの後に含めるもの:
- 必須の一行 `Purpose:` 行
- 必須の `## Background` セクション
- 必須の `## Content` セクション
- 最後に置く必須の `## References` セクション

`Purpose:` は、その文書を保存または作成する価値を一文で述べる。
`Purpose:` はトピックの言い換えでも `Background` の重複でもない。将来のどの判断、レビュー、引き継ぎ、再現を支えるための記録かなど、保持理由を書く。

各 section の役割:
- `## Background`: 記録の状況、きっかけ、事実関係、制約、根拠、再現情報を短く書く。
- `## Content`: 調査結果、手順、判断、比較、その他タスク固有の主内容を書く。
- `## References`: ウェブページ、論文、標準、その他の外部文書だけを列挙する。

内部リポジトリ文書、ローカル記録、その他ワークスペース内部ファイルへの cross-link は `## Background` または `## Content` に置き、`## References` には置かない。
## Markdown 記録を読む

既存 Markdown 記録を参照するときは、次の順序で読む:

1. **保存価値**: `Purpose:` を見て、その記録が支える将来作業、判断、レビュー、引き継ぎ、再現を確認する。
2. **依存性**: `Repository:` と `Related-Commit:` を見て、現在のリポジトリ、ブランチ、コード状態へそのまま適用できるか判断する。
3. **作成文脈**: `Created:`、`Updated:`、`Model:`、`Reasoning-Effort:`、`Session:` を見て、記録時点、改訂時点、作成条件を確認する。
4. **背景**: `## Background` で、記録のきっかけ、前提、制約、根拠を確認する。
5. **主内容**: `## Content` で、調査結果、手順、判断、比較、タスク固有の内容を読む。
6. **外部根拠**: `## References` で、外部参照だけを確認する。

読むときの扱い:
- `Repository:` または `Related-Commit:` が現在状態とずれる記録は、そのまま現在の事実として扱わず、更新または再検証の候補にする。
- `## References` に内部文書がないことを、内部参照が存在しない根拠にしない。内部 cross-link は `## Background` または `## Content` を確認する。
- 標準構造が欠けている既存記録は、内容を破棄せず、更新時に標準構造へ寄せる候補として扱う。
- 現在のタスクが既存記録の継続、精緻化、訂正である場合は、新規作成より既存記録の更新を優先する。

## リポジトリ文書ローテーション

`references/document_rotation.md` を、`document/` ローテーションの詳細仕様の正本とする。

- `document/` は既定でローテーション管理領域として扱う。
- ローテーション管理しない文書は、`knowledge/` またはリポジトリの明示的な代替ワークフローへ分ける。
- `document/previous/` と `document/<shortsha>-<slug>/` はローテーション済み snapshot として扱う。
- ユーザーが明示的にアーカイブファイルの修正を求めた場合を除き、ローテーション済み snapshot ディレクトリ内のファイルは編集しない。
- 明示的な対象パスなしで新しい artifact や作業文書を作る場合は、active な `document/` 直下の新しいパスに置く。
- コミット時の移動、stage、clone 後の hook 有効化などの詳細は `references/document_rotation.md` に従う。

## ローテーション導入

文書ローテーションを導入または更新するときは、先に `references/document_rotation.md` を読む。

- 対象リポジトリの `.githooks/`、`tool/`、既存 commit workflow、明示的な代替文書 workflow を確認する。
- ファイル作成、上書き、既存 workflow 統合が必要な場合は、導入方針と対象ファイルを示してから進める。
- 標準 template と installer の詳細は `references/document_rotation.md` に従う。
- clone 後に hook 有効化が必要なことを、最終報告または repository documentation で案内する。

## 副作用と失敗時

- **Markdown 作成・更新**: file を書く前に保存先 path と目的を示す。既存 file の上書きは、`--force` またはユーザーの明示指示がある場合に限る。
- **Markdown 新規作成**: `scripts/generate_document_note.sh` が使えない場合は、失敗理由を報告し、ユーザーの明示的な続行指示を得てから同じ構造を手で作る。
- **Markdown 作成先 directory**: `scripts/generate_document_note.sh --output` は親 directory を作成する。directory 作成を避ける必要がある場合は、実行前に保存先を確認する。
- **ローテーション導入**: コピー、上書き、chmod、hook 設定案内、リポジトリ documentation 更新を副作用として扱う。
- **既存 workflow 衝突**: 既存の `pre-commit` ワークフローがある場合は盲目的に上書きせず、統合方針を提示してから進める。
- **コピー先 directory**: installer のコピー先が directory の場合は、`--force` でも置換せず停止する。
- **clone 時の hook**: リポジトリファイルは clone されるが Git hook の有効化は clone されない、と明示する。

## 完了条件

- **保存先判断**: 保存クラス、保存範囲、保存パスを説明できる。
- **Markdown 記録**: 標準構造、保存先、言語、ファイル名、`Purpose:` が確認できる。
- **ローテーション導入**: 必要ファイル、`.document-rotation.env`、既存 workflow との関係、clone 後の hook 有効化案内が確認できる。
- **未実行検証**: script 実行、copy、validation を行わなかった場合は理由を報告する。
