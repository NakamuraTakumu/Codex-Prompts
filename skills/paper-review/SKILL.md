---
name: paper-review
description: 日本語または英語の学術論文と LaTeX 原稿を、学術的制約の下でレビュー、修正案作成、または安全な局所修正するときに使う。
---

# 論文レビュー

## 目的

- **対象**: 日本語または英語の学術論文、LaTeX 原稿、論文差分。
- **用途**: レビュー、修正案作成、安全な局所修正。
- **最上位制約**: 主張、範囲、論理、用語、著者の声を暗黙に変えない。

## モード

- **`review-only`**:
  - **成果物**: 所見を保存した Markdown note。
  - **修正案**: 提案しない。
  - **原稿編集**: しない。
  - **Markdown note**: 必ず作成または更新する。
  - **レビュー面**: 原稿全体または `git diff`。
- **`revision-no-change`**:
  - **成果物**: 所見と **安全な修正案** を保存した Markdown note。
  - **修正案**: 提案する。
  - **原稿編集**: しない。
  - **Markdown note**: 必ず作成または更新する。
  - **レビュー面**: 原稿全体、section、または `git diff`。
- **`revision`**:
  - **成果物**: 所見と適用済み修正を保存した Markdown note。
  - **修正案**: 必要に応じて記録する。
  - **原稿編集**: **安全な局所修正**だけを適用する。
  - **Markdown note**: 必ず作成または更新する。
  - **レビュー面**: 修正対象と近傍文脈。

## 用語

- **安全な修正案**: 原稿ファイルを編集せずに報告する局所修正候補。
- **安全な局所修正**: 指定範囲内で、意味ずれを避けて原稿ファイルに適用する修正。
- **意味ずれ**: 主張、範囲、論理、用語、著者の声に対する意味上の変化。
- **観測された意味ずれ**: 入力差分、既存変更、popup-review 対象 change による意味ずれ。
- **修正による意味ずれ**: 提案または適用した修正が起こす意味ずれ。
- **source-only review**: ユーザーが明示した場合だけ行う、抽出 PDF テキストを必須にしないレビュー。

## モード推定規則

- **`review-only`**:
  - **判定条件**: 問題抽出、レビュー、確認、コメント、issue 要約だけを求める。
  - **既定動作**: 所見を Markdown note に保存する。
  - **迷う場合**: ファイル編集には進まない。
- **`revision-no-change`**:
  - **判定条件**: 修正案、改善案、添削案、recommendation を求める。
  - **既定動作**: 所見と安全な修正案を Markdown note に保存する。
  - **迷う場合**: ファイル編集には進まない。
- **`revision`**:
  - **判定条件**: 原稿ファイルへの反映を求める。
  - **既定動作**: 安全な局所修正を適用し、所見と適用済み修正を Markdown note に保存する。
  - **迷う場合**: 反映意図が弱ければ `revision-no-change` に倒す。

## Artifact 契約

この section では、レビュー時に使う artifact の必須条件、使用順、副作用条件、範囲制限を定める。

- **必須 artifact**:
  - **抽出 PDF テキスト**: ユーザーが source-only review を明示しない限り必須。レビュー単位の列挙前に作成または取得して読む。
  - **作成順**: 既存 PDF があれば PDF text extraction を行う。PDF がなく LaTeX source から build できる場合は PDF build 後に PDF text extraction を行う。
  - **blocker**: PDF build、PDF text extraction、既存抽出テキスト取得のいずれもできない場合は review blocker として報告し、抽出 PDF テキストに基づく判断へ進まない。
- **artifact 使用順**:
  1. **抽出 PDF テキスト**: 原稿内容、語句、引用、参照、bibliography output の第一根拠として常に使う。
  2. **LaTeX source と `.bib` file**: 抽出 PDF テキストの対応箇所、source-level issue、macro / command の影響、citation / bibliography metadata を確認するときに使う。
  3. **rendered PDF**: layout、図、caption、front matter、page break、visual annotation など、表示結果が判断に必要なときに使う。
  4. **条件付き artifact**: `git diff`、build log、Web source、投稿規定などは、対象評価面、blocker、または照合条件に必要なときに使う。

- **根拠収集**:
  - **許可**: すべてのモード。
  - **対象**: source、PDF build、PDF text extraction、差分、ビルドログ、抽出 PDF テキスト、rendered PDF、Web source。
  - **条件**: scope に直接対応する根拠に限る。
  - **禁止**: 追加文脈のためだけに範囲外ファイルを読む。
- **Markdown note**:
  - **要求**: すべてのモード。
  - **対象**: レビュー note。
  - **条件**: **出力契約** に従う。
  - **禁止**: 原稿編集と混同しない。
- **原稿編集**:
  - **許可**: `revision` mode のみ。
  - **対象**: scope 内の原稿ファイル。
  - **条件**: 安全な局所修正として成立する。
  - **禁止**: scope を暗黙に広げる。

## ワークフロー

この section では、**モードと scope の固定**、**PDF artifact 準備**、**review blocker 確認**、**基準と根拠の選択**、**レビュー単位の列挙**、**レビュー単位確認**、**revision 処理**、**再確認と報告** を扱う。

- **構造化文書規則との対応**:
  - **`review-only`**: **レビュー検査** として扱い、対象文書を書き換えない。
  - **`revision-no-change`**: **レビュー検査** として扱い、修正候補は **安全な修正案** として報告する。
  - **`revision`**: **リバイズ** として扱い、意味や内容の変化を伴わない安全な局所修正だけを適用する。
  - **内容追加禁止**: paper-review では **内容変更** を実行しない。新しい主張、根拠、例、比較、解釈、結論の追加は所見または安全な修正案に留める。

1. **モードと scope を固定する**。
   - **入力**: user request、対象 file、対象 diff。
   - **処理**: モード、対象種別、scope、source-only review の有無、`../common/structured_document_rule.md` に渡す **レビュー検査** または **リバイズ** を決める。
   - **出力**: 原稿全体、section、定理系環境、diff、citation、front matter、narrow issue のいずれか。
   - **制約**: 範囲外 file は読まない。
2. **PDF artifact を準備する**。
   - **入力**: scope、既存 PDF、LaTeX source、build 設定。
   - **処理**: **Artifact 契約** に従い、抽出 PDF テキストを作成または取得する。
   - **出力**: 抽出 PDF テキスト、必要に応じて rendered PDF と build log。
   - **制約**: source-only review でない限り、抽出 PDF テキストなしでレビュー単位の確認へ進まない。
3. **review blocker を確認する**。
   - **入力**: 抽出 PDF テキスト、ビルドログ、reference 状態、citation 状態、bibliography output。
   - **処理**: 後続判断を壊す blocker を確認する。
   - **出力**: blocker の有無。
   - **制約**: 修正は `revision` mode かつ安全な局所修正の範囲だけ。
4. **基準と根拠を選ぶ**。
   - **入力**: scope、task type、利用可能な artifact。
   - **処理**: [references/criteria.md](references/criteria.md) と [references/revision-principles.md](references/revision-principles.md) の必要 subset を **基準入力** として選び、**Artifact 契約** の使用順に従って根拠 set を決める。
   - **出力**: 基準入力、選択した **評価面**、根拠 set。
   - **制約**: 分類外の重要 issue も影響に基づいて扱う。
5. **レビュー単位を列挙する**。
   - **入力**: scope、抽出 PDF テキスト、source、diff。
   - **処理**: 抽出 PDF テキストを第一根拠としてレビュー可能な単位に分ける。構造化文書として扱う場合は、`../common/structured_document_rule.md` の **スコープ構造検査** の **準備手順** に委譲する。
   - **出力**: レビュー単位 list。
   - **制約**: `git diff` は raw line ではなく意味のある変更単位に分ける。
6. **すべてのレビュー単位を確認する**。
   - **入力**: レビュー単位 list、基準入力、根拠 set。
   - **処理**: issue を確認し、必要なら group する。構造化文書レビューを行う場合は、`../common/structured_document_rule.md` の **スコープ構造検査** を **レビュー検査** として使う。
   - **出力**: 所見候補。
   - **制約**: 所見には severity label を付ける。
7. **モードに従って revision を扱う**。
   - **入力**: モード、所見候補、修正候補。
   - **処理**: 修正案の記録、安全な局所修正の適用、または未解決 issue の TODO marker 追加を行う。構造化文書 revision では、**基準入力** を渡して `../common/structured_document_rule.md` の **リバイズ** を使う。**範囲保持** に反する構造修正、または意味や内容の変化を伴う候補は適用せず、`revision` mode では [references/revision-principles.md](references/revision-principles.md) に従って TODO marker として残す。
   - **出力**: 所見、安全な修正案、適用済み修正。
   - **制約**: 実質的変更の依頼がない限り意味保持を守る。
8. **再確認して報告する**。
   - **入力**: 選択した **評価面**、所見、安全な修正案、適用済み修正、未解決 issue、検証結果。
   - **処理**: 元の意図と近傍文脈で再確認し、Markdown note を作成または更新する。
   - **出力**: Markdown note と chat 報告。
   - **制約**: 検証できなかった artifact は理由を Markdown note に記録する。

## Review 基準

- **レビュー基準**: すべてのモードで [references/criteria.md](references/criteria.md) を読む。
- **構造化文書規則**: 文書構造、冗長性、用語・表記、情報保持を扱う場合は、[references/criteria.md](references/criteria.md) を **基準入力** として `../common/structured_document_rule.md` の **レビュー検査** を使う。
- **BibTeX / bibliography**: [references/criteria.md](references/criteria.md) の **BibTeX と bibliography** に従い、`.bib` file 内のすべての論文 entry を Web source と照合する。
- **重大度**: [references/criteria.md](references/criteria.md) の **重大度** に従う。

## Revision 契約

- **修正制約**: `revision-no-change` と `revision` では [references/revision-principles.md](references/revision-principles.md) を読む。
- **構造化文書 revision**: 構造、冗長性、用語・表記、情報保持に関する revision が scope 内なら、[references/criteria.md](references/criteria.md) と [references/revision-principles.md](references/revision-principles.md) を **基準入力** として、`../common/structured_document_rule.md` の **リバイズ** を使う。
- **内容追加禁止**: 新しい主張、根拠、例、比較、解釈、結論は原稿へ追加しない。必要性は所見または安全な修正案として報告する。
- **TODO marker**: `revision` mode では、最小修正に収まらない問題、意味保持と衝突する問題、著者判断が必要な問題を原稿内 TODO として残す。TODO marker は未解決 issue の表示であり、新しい主張、根拠、例、比較、解釈、結論の追加として扱わない。
- **衝突時**: 意味保持または局所修正と衝突する requested fix は、`revision` mode では TODO marker として残し、それ以外では所見として残す。
- **範囲保持**: scope を暗黙に広げない。
- **citation / macro**: command の差し替えだけで判断せず、文全体と修辞上の接続を確認する。

## 検証

- **完了条件**:
  - **抽出 PDF テキスト**: checked、source-only review、または blocker reason のいずれかを記録する。
  - **選択評価面**: 各評価面について、使った artifact と使わなかった artifact の理由を記録する。
  - **revision**: revision が scope の場合、元テキスト、修正後 passage、近傍文脈を再読する。
- **条件付き根拠**:
  - **`git diff`**: 差分レビューが scope の場合に使う。
  - **build log**: build failure、unresolved reference、unresolved citation、bibliography issue が対象または blocker の場合に使う。
  - **rendered PDF**: layout、figure、caption、front matter、page break、visual annotation が issue 対象の場合に使う。
  - **Web source**: BibTeX / bibliography の外部照合、先行研究内容の確認、引用事実の確認が scope の場合に使う。
- **範囲制限**:
  - **原則**: 広いレビューの明示がなければ、レビュー対象に対応する artifact だけを見る。
  - **禁止**: 追加文脈のためだけに範囲外ファイルを読む。

## 出力契約

- **主成果物**: Markdown note。
- **補助出力**: chat 報告。
- **責務分離**: 詳細な所見、修正案、適用済み修正、検証結果は Markdown note に保存する。chat には同じ詳細を重複させない。

### Markdown note

- **要求**: すべてのモードで必ず作成または更新する。
- **schema**: [references/output-note.md](references/output-note.md) に従う。
- **保存先**: `document-workflow` に従う。
- **原稿編集扱い**: Markdown note は原稿編集に含めない。
- **所見構造**: [references/criteria.md](references/criteria.md) の **評価面** ごとに出す。考慮した評価面に所見がない場合は `none` と書く。
- **省略規則**: ユーザー指示で考慮する **評価面** が制限される場合、対象外の評価面は出力しない。
- **所見順序**: 各評価面内では `major`、`moderate`、`minor`、`nit` の順に並べる。同じ severity では source order に従う。
- **所見粒度**: レビュー所見、安全な修正案、適用済み安全局所修正を区別する。
- **差分所見**: hunk や diff line に機械的に map しない。
- **反復 issue**: 近い重複は group する。
- **位置**: 可能なら file、artifact、section、page を示す。

### Chat 報告

- **役割**: 作業完了の通知と参照先案内。
- **必須情報**: Markdown note path、mode、未解決 issue の有無、短い要約。
- **禁止**: 所見 schema を使わない。詳細な所見一覧、修正案一覧、検証結果一覧を展開しない。
- **例外**: Markdown note を保存できなかった場合だけ、未保存理由と復旧に必要な最小情報を chat に出す。
