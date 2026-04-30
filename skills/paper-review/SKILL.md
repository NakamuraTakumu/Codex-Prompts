---
name: paper-review
description: 日本語または英語の学術論文と LaTeX 原稿を、学術的制約の下でレビュー、修正案作成、または安全な局所修正するときに使う。
---

# 論文レビュー

## 目的

- **対象**: 日本語または英語の学術論文、LaTeX 原稿、論文差分。
- **用途**: レビュー、修正案作成、安全な局所修正。
- **制約**: 主張、範囲、論理、用語、著者の声を暗黙に変えない。

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

## モード推定

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

## 副作用契約

- **根拠収集**:
  - **許可**: すべてのモード。
  - **対象**: source、差分、ビルドログ、抽出 PDF テキスト、rendered PDF。
  - **条件**: scope に直接対応する根拠に限る。
  - **禁止**: 範囲外ファイルを追加文脈のためだけに読む。
- **Markdown note**:
  - **要求**: すべてのモード。
  - **対象**: レビュー note。
  - **条件**: **記録方針** に従う。
  - **禁止**: 原稿編集と混同しない。
- **原稿編集**:
  - **許可**: `revision` mode のみ。
  - **対象**: scope 内の原稿ファイル。
  - **条件**: 安全な局所修正として成立する。
  - **禁止**: scope を暗黙に広げる。

## ワークフロー

この section では、**モードと scope の固定**、**レビュー単位の列挙**、**review blocker 確認**、**基準と根拠の選択**、**レビュー単位確認**、**revision 処理**、**再確認と報告** を扱う。文書構造、冗長性、用語・表記、情報保持を扱う step では、[references/criteria.md](references/criteria.md) と [references/revision-principles.md](references/revision-principles.md) を **基準入力** として渡し、`../common/structured_document_rule.md` の **レビュー検査** または **リバイズ** を使う。

- **構造化文書規則との対応**:
  - **`review-only`**: **レビュー検査** として扱い、対象文書を書き換えない。
  - **`revision-no-change`**: **レビュー検査** として扱い、修正候補は **安全な修正案** として報告する。
  - **`revision`**: **リバイズ** として扱い、意味や内容の変化を伴わない安全な局所修正だけを適用する。
  - **内容追加禁止**: paper-review では **内容変更** を実行しない。新しい主張、根拠、例、比較、解釈、結論の追加は所見または安全な修正案に留める。

1. **モードと scope を固定する**。
   - **入力**: user request、対象 file、対象 diff。
   - **処理**: モード、対象種別、scope、`../common/structured_document_rule.md` に渡す **レビュー検査** または **リバイズ** を決める。
   - **出力**: 原稿全体、section、定理系環境、diff、citation、front matter、narrow issue のいずれか。
   - **制約**: 範囲外 file は読まない。
2. **レビュー単位を列挙する**。
   - **入力**: scope、source、diff。
   - **処理**: レビュー可能な単位に分ける。構造化文書として扱う場合は、`../common/structured_document_rule.md` の **スコープ構造検査** の **準備手順** に委譲する。
   - **出力**: レビュー単位 list。
   - **制約**: `git diff` は raw line ではなく意味のある変更単位に分ける。
3. **review blocker を確認する**。
   - **入力**: ビルドログ、reference 状態、citation 状態、bibliography output。
   - **処理**: 後続判断を壊す blocker を確認する。
   - **出力**: blocker の有無。
   - **制約**: 修正は `revision` mode かつ安全な局所修正の範囲だけ。
4. **基準と根拠を選ぶ**。
   - **入力**: レビュー単位 list、task type、利用可能な artifact。
   - **処理**: 対象言語、task type、artifact に対応する [references/criteria.md](references/criteria.md) と [references/revision-principles.md](references/revision-principles.md) の subset を **基準入力** として選び、対応する根拠だけを選ぶ。
   - **出力**: 基準入力、選択した **評価面**、根拠 set。
   - **制約**: レビュー対象に直接対応する根拠を優先する。
5. **すべてのレビュー単位を確認する**。
   - **入力**: レビュー単位 list、基準入力、根拠 set。
   - **処理**: issue を確認し、必要なら group する。構造化文書レビューを行う場合は、`../common/structured_document_rule.md` の **スコープ構造検査** を **レビュー検査** として使う。
   - **出力**: 所見候補。
   - **制約**: 基準の分類に収まらない重要 issue も抑制しない。
6. **モードに従って revision を扱う**。
   - **入力**: モード、所見候補、修正候補。
   - **処理**: 修正案の記録または安全な局所修正の適用を行う。構造化文書 revision では、**基準入力** を渡して `../common/structured_document_rule.md` の **リバイズ** を使う。**範囲保持** に反する構造修正、または意味や内容の変化を伴う候補は適用せず、所見または安全な修正案として残す。
   - **出力**: 所見、安全な修正案、適用済み修正。
   - **制約**: 実質的変更の依頼がない限り意味保持を守る。
7. **再確認して報告する**。
   - **入力**: 選択した **評価面**、所見、安全な修正案、適用済み修正、未解決 issue。
   - **処理**: 元の意図と近傍文脈で再確認し、Markdown note を作成または更新する。
   - **出力**: Markdown note と chat 報告。
   - **制約**: 未解決 issue には severity label を付ける。

## Revision 契約

- **基本規則**: revision が scope 内なら [references/revision-principles.md](references/revision-principles.md) を適用する。
- **基準参照**: `revision-no-change` と `revision` でも [references/criteria.md](references/criteria.md) を読み、修正候補の必要性、重大度、報告要否を判断する。
- **構造化文書 revision**: 構造、冗長性、用語・表記、情報保持に関する revision が scope 内なら、[references/criteria.md](references/criteria.md) と [references/revision-principles.md](references/revision-principles.md) を **基準入力** として、`../common/structured_document_rule.md` の **リバイズ** を使う。
- **内容追加禁止**: 新しい主張、根拠、例、比較、解釈、結論は原稿へ追加しない。必要性は所見または安全な修正案として報告する。
- **衝突時**: 意味保持または局所修正と衝突する requested fix は所見として残す。
- **禁止**: scope を暗黙に広げない。
- **citation / macro**: sentence-level と rhetoric-level の revision として扱う。

## 検証

- **基本根拠**: source と、scope に直接対応する根拠。
- **差分レビュー**: `git diff` を使う。raw line ではなく意味のある変更単位を確認する。
- **ビルドログ**:
  - **条件**: build failure、unresolved reference、unresolved citation、bibliography issue が対象または blocker。
- **revision 再読**:
  - **条件**: revision が scope 内。
  - **対象**: 元テキスト、修正後 passage、近傍文脈。
- **抽出 PDF テキスト**:
  - **条件**: wording が LaTeX command、macro、annotation、PDF 抽出 artifact の影響を受けうる。
- **rendered PDF**:
  - **条件**: layout、figure、caption、front matter、page break、visual annotation が issue 対象。
- **範囲制限**:
  - **原則**: 広いレビューの明示がなければ、レビュー対象に対応する artifact だけを見る。
  - **禁止**: 追加文脈のためだけに範囲外ファイルを読む。

## 出力契約

この section では、主成果物である **Markdown note** と、補助出力である **chat 報告** の責務を分ける。

- **主成果物**: Markdown note。
- **補助出力**: chat 報告。
- **責務分離**: 詳細な所見、修正案、適用済み修正、検証結果は Markdown note に保存する。chat には同じ詳細を重複させない。

### Markdown note

- **役割**: レビュー結果の完全な記録。
- **schema**: [references/output-note.md](references/output-note.md) に従う。
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

## 記録方針

- **必須**: `paper-review` task では、完了前に Markdown note を save または update する。
- **原稿編集扱い**: Markdown note は原稿編集に含めない。
- **保存先**: `document-workflow` に従う。
- **outer structure**: `document-workflow` に従う。
- **`## Content`**: [references/output-note.md](references/output-note.md) に従う。
- **popup-review 中間利用**:
  - **note**: `paper-review` の最終成果物として返す場合は作る。
  - **所見**: 一時データとして扱う。
  - **変換先**: popup ID に対応付け、`comments JSON` に反映する。
- **同一 changes の popup review**:
  - **基準**: 別基準にしない。
  - **扱い**: 同じ実質レビュー基準を使う。

## Popup Review 連携

- **`paper-review` の責務**: 学術的な所見を作る。
- **`latexdiff-popup-review` の責務**: popup ID 対応、`comments JSON` schema、annotation 生成。
- **中間所見**:
  - **必須情報**: 対象変更、issue reason、severity、観測された意味ずれ。
- **変換時の保持**: 観測された意味ずれの判断を失わない。

## 参照

- **レビュー基準**: すべてのモードで [references/criteria.md](references/criteria.md) を読む。
- **修正制約**: [references/revision-principles.md](references/revision-principles.md) を読む。
- **差分レビューの安全判断**: `review-only` でも [references/revision-principles.md](references/revision-principles.md) を読む。
- **構造化文書規則**: 文書構造、冗長性、用語・表記、情報保持を扱う場合は `../common/structured_document_rule.md` を読む。
