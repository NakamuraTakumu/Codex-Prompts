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

- **既定判断**: 後続作業、判断、レビュー、引き継ぎ、再現の助けになる可能性が少しでもある場合は記録する。
- **記録する**: セッション内に、明示的な文書化依頼、再利用できる知見、調査、比較、意思決定、方針変更、ワークフロー設計、トラブルシューティング、失敗原因、検証結果、今後参照しそうな注意点が含まれる場合。
- **省略する**: ユーザーが記録しないよう明示した場合、または保存しても将来の判断や再現にほぼ寄与しない短い応答だけで終わる場合。
- **迷う場合**: 省略理由を具体的に言えない場合は記録する。
- **次の手順**: 記録すると判断した場合は、**保存先選択** と **Markdown 記録を書く** に進む。

## 配置スコープ設計

文書の分割と path 設計では、file と directory を `skills/common/structured_document_rule.md` の **配置スコープ** として扱う。Markdown 本文内の section に同 rule を適用するのと同じく、file、directory、cross-link でも責務、判断、契約、参照関係が混ざらないようにする。

- **分割判断**: 1 つのスレッドでリポジトリ固有の知見とグローバルなプロセス知見の両方が出た場合は、1 つの場所へ無理にまとめず、別々の配置スコープに分ける。
- **分割条件**: 混在した知見を分割するのは、両方が単独で再利用価値を持つ場合に限る。
- **分割しない場合**: 主な配置スコープを維持し、もう一方の場所への一行の参照を加える。
- **参照配置**: 内部文書、ローカル記録、ワークスペース内部ファイルへの cross-link は、`references/markdown_note_format.md` の section 役割に従って置く。
- **Directory**: topic、workflow、artifact 種別など、再利用される親配置スコープに使う。一回限りの細部だけで階層を増やさない。
- **File**: leaf 配置スコープとして、責務を短く表す名前にする。親 directory から回復できる語を繰り返さず、`overview.md`、`decision.md`、`result.md`、`notes.md` などを使ってよい。日付は、版や時系列を区別する実質的な助けになる場合を除き file 名に入れず、メタデータに置く。
- **Flat path**: 候補名が `<scope>_<name>.md` のように複数 scope を含む場合は、ユーザーが flat file 名を明示した場合を除き、`<scope>/<name>.md` として扱う。
- **可読性**: Path または file 名が読み取りにくい長さになる場合は、slug を短くし、安定した分類だけを親 directory へ移す。

## 文書形式

- `/home/nakamura/.codex/document/` または `/home/nakamura/.codex/knowledge/` に保存する記録は、明確な理由がない限り日本語で書く。
- 文書全体は簡潔に保つ。検証、再現、将来の判断に必要でない副次的詳細は省く。
- タスクログ全体、主要な提案や判断から明らかな結論の言い直し、近接する別成果物の内容は、文書の目的が明確に必要とする場合を除き含めない。

## Markdown 記録を書く

Markdown 記録は構造化文書として扱う。標準書式は `references/markdown_note_format.md`、構造化文書の一般規則は `skills/common/structured_document_rule.md` を参照する。

### 標準書式

Markdown 記録を作成または更新する前に `references/markdown_note_format.md` を読む。`Responsibility:`、`## Background`、`## Result`、`## Notes`、`## References` の初期値は、同 file の役割分担に従って決める。

### 作成・更新の選択

Markdown 記録を書くときは、保存先を決めた後、関連する既存記録の有無と `Responsibility:` で新規作成か更新かを決める。

- **新規作成**: 関連する既存記録がない場合。
- **既存更新**: 変更内容が既存記録の `Responsibility:` を保ったまま、精緻化、根拠追加、誤記訂正、失効した記述の局所修正になる場合。
- **責務による分離**: 既存記録と対象、論点、またはスレッドが同じでも、`Responsibility:` が示す文書全体の責務、出力契約、または主要成果物が変わる場合は新規作成する。例: 初回調査は原因候補の整理、修正後の再調査は修正結果の検証を成果物にするため、原則として別記録にする。
- **参照追加**: 分離した継続調査、再調査、検証記録を既存記録からたどる必要がある場合は、既存記録の `## Notes` に一行の cross-link だけを加える。文書作成の経緯を示す参照だけは `## Background` に置く。

### 新規作成

Markdown 記録を新規作成するときは、先に `references/markdown_note_format.md` を読み、続けて `skills/common/structured_document_rule.md` の **新規作成前確認** を行う。確認結果に基づき、`Responsibility:`、対象読者、入力、出力契約、初期スコープ構造、未確定事項を決める。作成後に同 file の **スコープ構造検査** と **情報保持確認** に従ってリバイズする。

ユーザーが明示的に別形式を求めた場合を除き、`scripts/generate_document_note.sh` で標準 skeleton を生成する。手作業で skeleton を書き起こさない。

推奨実行形:

```bash
/home/nakamura/.codex/skills/document-workflow/scripts/generate_document_note.sh --title "<題名>" --output <保存パス>/<slug>.md
```

`--output` には、**保存先選択** で決めた保存パスを使う。
`--output` を指定すると親 directory が作成される。既存 file は `--force` なしでは上書きされない。

よく使う option:
- `--responsibility <text>`: `Responsibility:` 行の初期値。
- `--background <text>`: `## Background` の初期値。
- `--result <text>`: `## Result` の初期値。
- `--notes <text>`: `## Notes` の初期値。
- `--references <text>`: `## References` の初期値。
- `--repository <value|auto|none>`: `Repository:` の値。既定値は `auto`。
- `--related-commit <value|auto|none>`: `Related-Commit:` の値。既定値は `none`。
- `--thread-id <id>`: session metadata を読む thread ID。既定値は `CODEX_THREAD_ID`。
- `--sessions-root <dir>`: session log 探索 root。既定値は `/home/nakamura/.codex/sessions`。
- `--output <file>`: skeleton の出力先。未指定時は stdout に書く。
- `--force`: 既存の `--output` file を上書きする。

完全な CLI は `scripts/generate_document_note.sh --help` で確認する。

### 更新

既存 Markdown 記録を更新するときは、既存構造を保ち、`Updated:` と本文を必要最小限で更新する。

- `Created:` は保存する。
- `Updated:` は更新時刻へ変更する。
- 既存の `## References` は、不要になった外部参照を除き保存する。
- 新しい内容は、既存の主張を置き換える必要がある場合を除き、追記または局所編集で反映する。
- 標準構造が欠けている既存記録では、変更の意図を壊さない範囲で標準構造へ寄せる。

## 既存記録の扱い

既存 Markdown 記録を参照または更新するときは、`references/markdown_note_format.md` の標準構造を前提に、次を確認する。

- `Repository:` または `Related-Commit:` が現在状態とずれる記録は、そのまま現在の事実として扱わず、更新または再検証の候補にする。
- `## References` に内部文書がないことを、内部参照が存在しない根拠にしない。内部 cross-link は `## Background` または `## Notes` を確認する。
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
- **Markdown 記録**: 標準構造、保存先、言語、ファイル名、`Responsibility:` が確認できる。
- **ローテーション導入**: 必要ファイル、`.document-rotation.env`、既存 workflow との関係、clone 後の hook 有効化案内が確認できる。
- **未実行検証**: script 実行、copy、validation を行わなかった場合は理由を報告する。
