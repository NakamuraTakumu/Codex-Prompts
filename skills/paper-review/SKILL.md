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
  - **成果物**: 所見。
  - **修正案**: 提案しない。
  - **原稿編集**: しない。
  - **Markdown note**: **記録方針** に従う。
  - **レビュー面**: 原稿全体または `git diff`。
- **`revision-no-change`**:
  - **成果物**: 所見と **安全な修正案**。
  - **修正案**: 提案する。
  - **原稿編集**: しない。
  - **Markdown note**: **記録方針** に従う。
  - **レビュー面**: 原稿全体、section、または `git diff`。
- **`revision`**:
  - **成果物**: 所見と適用済み修正。
  - **修正案**: 必要に応じて記録する。
  - **原稿編集**: **安全な局所修正**だけを適用する。
  - **Markdown note**: **記録方針** に従う。
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
  - **既定動作**: 所見だけを返す。
  - **迷う場合**: ファイル編集には進まない。
- **`revision-no-change`**:
  - **判定条件**: 修正案、改善案、添削案、recommendation を求める。
  - **既定動作**: 安全な修正案を返す。
  - **迷う場合**: ファイル編集には進まない。
- **`revision`**:
  - **判定条件**: 原稿ファイルへの反映を求める。
  - **既定動作**: 安全な局所修正を適用する。
  - **迷う場合**: 反映意図が弱ければ `revision-no-change` に倒す。

## 副作用契約

- **根拠収集**:
  - **許可**: すべてのモード。
  - **対象**: source、差分、ビルドログ、抽出 PDF テキスト、rendered PDF。
  - **条件**: scope に直接対応する根拠に限る。
  - **禁止**: 範囲外ファイルを追加文脈のためだけに読む。
- **Markdown note**:
  - **許可**: すべてのモード。
  - **対象**: レビュー note。
  - **条件**: **記録方針** に従う。
  - **禁止**: 原稿編集と混同しない。
- **原稿編集**:
  - **許可**: `revision` mode のみ。
  - **対象**: scope 内の原稿ファイル。
  - **条件**: 安全な局所修正として成立する。
  - **禁止**: scope を暗黙に広げる。
- **note 作成例外**:
  - **許可**: すべてのモード。
  - **対象**: Markdown note。
  - **条件**: chat-only、一時利用、記録不要、note 作成禁止の明示。
  - **禁止**: 例外条件があるのに note を作る。

## ワークフロー

1. **モードと scope を固定する**。
   - **入力**: user request、対象 file、対象 diff。
   - **処理**: モード、対象種別、scope を決める。
   - **出力**: 原稿全体、section、定理系環境、diff、citation、front matter、narrow issue のいずれか。
   - **制約**: 範囲外 file は読まない。
2. **レビュー単位を列挙する**。
   - **入力**: scope、source、diff。
   - **処理**: レビュー可能な単位に分ける。
   - **出力**: レビュー単位 list。
   - **制約**: `git diff` は raw line ではなく意味のある変更単位に分ける。
3. **review blocker を確認する**。
   - **入力**: ビルドログ、reference 状態、citation 状態、bibliography output。
   - **処理**: 後続判断を壊す blocker を確認する。
   - **出力**: blocker の有無。
   - **制約**: 修正は `revision` mode かつ安全な局所修正の範囲だけ。
4. **基準と根拠を選ぶ**。
   - **入力**: レビュー単位 list、task type、利用可能な artifact。
   - **処理**: 対象言語、task type、artifact に対応する基準と根拠だけを選ぶ。
   - **出力**: 基準 subset、根拠 set。
   - **制約**: レビュー対象に直接対応する根拠を優先する。
5. **すべてのレビュー単位を確認する**。
   - **入力**: レビュー単位 list、基準 subset、根拠 set。
   - **処理**: issue を確認し、必要なら group する。
   - **出力**: 所見候補。
   - **制約**: 基準の分類に収まらない重要 issue も抑制しない。
6. **モードに従って revision を扱う**。
   - **入力**: モード、所見候補、修正候補。
   - **処理**: 修正案の記録または安全な局所修正の適用を行う。
   - **出力**: 所見、安全な修正案、適用済み修正。
   - **制約**: 実質的変更の依頼がない限り意味保持を守る。
7. **再確認して報告する**。
   - **入力**: 所見、安全な修正案、適用済み修正、未解決 issue。
   - **処理**: 元の意図と近傍文脈で再確認する。
   - **出力**: 報告、必要なら Markdown note。
   - **制約**: 未解決 issue には severity label を付ける。

## Revision 契約

- **基本規則**: revision が scope 内なら [references/revision-principles.md](references/revision-principles.md) を適用する。
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

## 報告

- **順序**: 所見を先に出す。summary は補助情報。
- **区別**: レビュー所見、安全な修正案、適用済み安全局所修正。
- **所見順序**: 原稿、section、diff task では原則 source order。
- **例外**: ユーザーが重大度順の報告を明示した場合。
- **差分所見**: hunk や diff line に機械的に map しない。
- **反復 issue**: 近い重複は group する。
- **未解決 summary**: `Revision Status` 内では severity 順。
- **位置**: 可能なら file、artifact、section、page を示す。

## 記録方針

- **既定**: 通常の `paper-review` task では、完了前に Markdown note を save または update する。
- **原稿編集扱い**: Markdown note は原稿編集に含めない。
- **保存先**: `document-workflow` に従う。
- **outer structure**: `document-workflow` に従う。
- **`## Content`**: [references/output-note.md](references/output-note.md) に従う。
- **popup-review 中間利用**:
  - **note**: 作らない。
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

- **レビュー基準**: [references/criteria.md](references/criteria.md) を読む。
- **修正制約**: [references/revision-principles.md](references/revision-principles.md) を読む。
- **差分レビューの安全判断**: `review-only` でも [references/revision-principles.md](references/revision-principles.md) を読む。
