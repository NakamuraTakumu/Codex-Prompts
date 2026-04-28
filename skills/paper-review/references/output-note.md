# 論文レビュー出力ノート

`paper-review` が Markdown のレビュー note を作る場合に使う。
このファイルは `## Content` 内部の schema と field 規則だけを定める。

## 適用範囲

- **対象**: `## Content` 内部。
- **保存先**: `document-workflow` に従う。
- **外側の構造**: `document-workflow` に従う。
- **`## References`**: 外部参照専用。

## `## Content` Schema

```md
## Content

### Summary

<短いレビュー要約>

### Findings

1. <短い所見タイトル>
   - Issue Location: <section / paragraph / sentence / file / page>
   - Severity: <major | moderate | minor | nit>
   - Issue Reason: <なぜ修正すべきか>
   - Observed Meaning Shift: <input diff/change による意味ずれ。該当しない場合は `none`>
   - Revision:
     - Content: <修正内容の概略。提案しない場合は `none`>
     - Meaning Shift: <提案または適用した修正による意味ずれ。意味保持なら `none`>

### Revision Status

- Mode: <review-only | revision-no-change | revision>
- Safe Revision Proposals: <list または none>
- Revisions Applied: <list または none>
- Unresolved Issues: <短い note または none>

### Verification

- Source: <checked: 内容 | not checked: reason>
- Extracted PDF Text: <checked: 内容 | not checked: reason>
- Rendered PDF: <checked: 内容 | not checked: reason>
- Build Log: <checked: 内容 | not checked: reason>
- Other Evidence: <checked: diff / guideline / style file / other | not checked: reason>
```

## Findings 規則

- **schema**: `review-only`、`revision-no-change`、`revision` に同じ schema を使う。
- **`Severity`**: [criteria.md](criteria.md) の **重大度** 定義に従う。
- **`Observed Meaning Shift`**: input diff、既存 revision、popup-review 対象 change による意味ずれを記録する。
- **`Revision`**: `Content` と `Meaning Shift` を持つ入れ子 block として保つ。
- **`Revision -> Meaning Shift`**: 提案または適用した修正による意味ずれだけを記録する。
- **`review-only`**: `Revision -> Content` と `Revision -> Meaning Shift` を `none` にする。
- **`git diff` input**: 1 つの hunk から複数の所見が出てもよい。
- **grouping**: 同じ issue pattern は 1 つの所見で複数箇所を扱ってよい。
- **分割条件**: reasoning、severity、revision judgment が異なる場合。
- **原文と修正文**: 曖昧性解消に必要な場合だけ `Findings` に含める。

## Revision Status 規則

- **`review-only`**: `Safe Revision Proposals` と `Revisions Applied` は `none`。
- **`revision-no-change`**: `Revisions Applied` は `none`。
- **`revision`**: 原則として `Safe Revision Proposals` と `Revisions Applied` を一致させる。
- **例外**: 意図的に未適用の revision がある場合。
