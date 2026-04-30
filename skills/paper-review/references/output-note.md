# 論文レビュー出力ノート

`paper-review` が必ず作成または更新する Markdown review note に使う。
このファイルは `## Content` 内部の schema と field 規則だけを定め、保存先と外側の構造は扱わない。

## 適用範囲

- **対象**: `## Content` 内部。
- **非対象**: 保存先、外側の構造。
- **`## References`**: 外部参照専用。

## `## Content` Schema

```md
## Content

### 概要

<短いレビュー要約>

### 所見

#### <criteria.md の評価面名>

1. <短い所見タイトル>
   - 対象位置: <section / paragraph / sentence / file / page>
   - 重大度: <major | moderate | minor | nit>
   - 問題理由: <なぜ修正すべきか>
   - 観測された意味ずれ: <input diff/change による意味ずれ。該当しない場合は `none`>
   - 修正:
     - 内容: <修正内容の概略。提案しない場合は `none`>
     - 意味ずれ: <提案または適用した修正による意味ずれ。意味保持なら `none`>

### 修正状況

- モード: <review-only | revision-no-change | revision>
- 安全な修正案: <list または none>
- 適用済み修正: <list または none>
- 未解決 issue: <短い note または none>

### 検証

- 抽出 PDF テキスト: <checked: 内容 | source-only review | blocker: reason>
- LaTeX source と BibTeX: <checked: 内容 | not checked: reason>
- 描画 PDF: <checked: 内容 | not checked: reason>
- ビルドログ: <checked: 内容 | not checked: reason>
- Web source: <checked: 内容 | not checked: reason>
- その他の根拠: <checked: diff / guideline / style file / other | not checked: reason>
```

## 所見規則

- **schema**: `review-only`、`revision-no-change`、`revision` に同じ schema を使う。
- **言語**: field 本文はユーザー指定がない限り日本語で書く。schema literal、severity label、mode label、原文引用、修正文、固有名、LaTeX source、BibTeX metadata、Web source の表記は必要に応じて元表記を保つ。
- **出力単位**: [criteria.md](criteria.md) の **評価面** ごとに出力する。
- **省略規則**: ユーザー指示で考慮する **評価面** が制限される場合、対象外の評価面は出力しない。
- **空項目**: 考慮した評価面に所見がない場合は `none` と書く。
- **所見順序**: 各評価面内では `major`、`moderate`、`minor`、`nit` の順に並べ、同じ severity では source order に従う。
- **`重大度`**: [criteria.md](criteria.md) の **重大度** 定義に従う。
- **`観測された意味ずれ`**: input diff、既存 revision、popup-review 対象 change による意味ずれを記録する。
- **`修正`**: `内容` と `意味ずれ` を持つ入れ子 block として保つ。
- **`修正 -> 意味ずれ`**: 提案または適用した修正による意味ずれだけを記録する。
- **`review-only`**: `修正 -> 内容` と `修正 -> 意味ずれ` を `none` にする。
- **`git diff` input**: 1 つの hunk から複数の所見が出てもよい。
- **grouping**: 同じ issue pattern は 1 つの所見で複数箇所を扱ってよい。
- **分割条件**: reasoning、severity、revision judgment が異なる場合。
- **原文と修正文**: 曖昧性解消に必要な場合だけ `所見` に含める。

## 修正状況規則

- **`review-only`**: `安全な修正案` と `適用済み修正` は `none`。
- **`revision-no-change`**: `適用済み修正` は `none`。
- **`revision`**: 原則として `安全な修正案` と `適用済み修正` を一致させる。
- **例外**: 意図的に未適用の revision がある場合。

## 検証規則

- **`抽出 PDF テキスト`**: `paper-review` の source-only review 以外では `checked` または `blocker` にする。
- **`LaTeX source と BibTeX`**: LaTeX source、macro、command、citation key、BibTeX metadata を確認した内容を書く。
- **`Web source`**: BibTeX / bibliography の外部照合、先行研究内容、引用事実を確認した場合に使う。
