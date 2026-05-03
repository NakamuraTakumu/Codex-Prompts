# Markdown Note Format

## 目的

- **対象**: document-workflow で作成または更新する Markdown 記録。
- **役割**: 標準構造、`Responsibility:` 行、section 役割、内部 cross-link の配置を定める。
- **参照関係**: Markdown 記録は構造化文書として扱い、一般的な構造判断は `skills/common/structured_document_rule.md` に従う。

## 標準構造

Markdown 記録は次の順序で構成する。

1. `# <題名>`
2. メタデータ bullets
3. 一行の `Responsibility:` 行
4. `## Background`
5. `## Result`
6. `## Notes`
7. `## References`

メタデータ bullets は `scripts/generate_document_note.sh` の出力順を正本とする。順序は `Created`、`Updated`、`Model`、`Reasoning-Effort`、`Session`、`Repository`、`Related-Commit`。

## `Responsibility:` 行

`Responsibility:` は、文書全体の責務と出力契約を一文で述べる。

- **書くこと**: ユーザーが求めた結果に対して、この文書が何を整理、列挙、比較、説明、記録、または検証するか。
- **書かないこと**: 依頼のきっかけ、この文書の用途、作業時の状況、調査過程、実行履歴。
- **判定**: `Responsibility:` だけを読んで、この文書に何が書かれるべきか判断できる場合は採用する。文書題名の言い換え、`## Background` の重複、または `## Result` の結論要約になっている場合は書き直す。

例:

```markdown
Responsibility: A の関連論文を、後続調査で参照できる一覧として整理する。
```

```markdown
Responsibility: 修正後の挙動を検証し、残る失敗条件と確認済み条件を記録する。
```

## Section 役割

- `## Background`: `Responsibility:` に対応する文書を作ることになった経緯だけを短く書く。文献参照、調査結果、根拠、手順、実行履歴は置かない。
- `## Result`: `Responsibility:` に直接対応する情報、一覧、まとめ、比較、説明、記録、検証結果を書く。
- `## Notes`: `Responsibility:` に直接対応しないが、文書を読むうえで有用な補助情報を書く。調査過程、除外条件、注意点、根拠、再現情報、関連成果物への内部 cross-link はここに置く。
- `## References`: ウェブページ、論文、標準、その他の外部文書だけを列挙する。

内部リポジトリ文書、ローカル記録、その他ワークスペース内部ファイルへの cross-link は `## References` には置かない。文書作成の経緯を示す場合だけ `## Background` に置き、調査過程、根拠、再現情報、関連成果物として参照する場合は `## Notes` に置く。
