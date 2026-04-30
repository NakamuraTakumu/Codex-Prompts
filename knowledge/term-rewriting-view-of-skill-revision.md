# Skill Revision as Term Rewriting

- Created: 2026-04-29 09:56 UTC
- Updated: 2026-04-29 09:56 UTC
- Model: gpt-5.5
- Reasoning-Effort: high
- Session: 019dd8a8-e5e5-7572-90b7-f333df9391ae
- Repository: /home/nakamura/.codex
- Related-Commit: none

Purpose: skill リバイズ workflow を項書き換え系として見直す今後の設計判断を支える。

## Background

`skills/skill-writer/SKILL.md` のリバイズ workflow が、項書き換えシステムに似ているのではないかという問いを受けて、関連する共通 rule を確認した。

確認した内部文書:

- `skills/skill-writer/SKILL.md`
- `skills/common/structured_document_rule.md`
- `skills/common/instruction_rule.md`

## Content

### 結論

skill リバイズ workflow は、単なる比喩より強く、**構造化文書を項木として扱う、ガード付き・意味保存付き・戦略指定ありの非形式的 rewrite system** と見なせる。

ただし、厳密な項書き換えシステムそのものではない。停止性と合流性は形式的に保証されておらず、衝突する修正候補は人間または LLM の設計判断と停止条件で扱う。

### 対応関係

- **term**: Markdown、skill、instruction を **スコープ木** として見たもの。
- **signature**: `section`、`list`、`record`、`description`、`child list` などの構造型。
- **rewrite rule**: 削除、統合、抽象化、移動、名称変更、description 化、field 正規化。
- **redex**: 冗長、責務混在、用語揺れ、契約不明瞭、情報保持違反の箇所。
- **strategy**: **葉スコープ** から **根スコープ** へ進み、読みにくい箇所を同階層で優先する。
- **normal form**: 文書としての修正箇所も、指示文書固有の修正箇所もない状態。
- **invariant**: 入力、判断条件、禁止事項、出力契約、副作用条件、失敗時の挙動などの情報保持。

### 根拠

- `structured_document_rule.md` は、文書構造を `Block[Title, Body]`、`Set[Item]`、`Seq[Step]`、`Tree[Parent, Child]`、`Record[Field : Value]` のように定義している。これは文書を項木として見るための signature に近い。
- 同 file の文の冗長性排除には、`A は B である -> A: B` のような明示的な変換型がある。
- **共通: スコープ単位確認** は、**葉スコープ** から **根スコープ** へ進む処理順序を持つため、rewrite strategy に相当する。
- **リバイズ** は、修正が行われれば確認手順を繰り返すため、正規形到達を目指す反復に近い。
- **情報保持確認** は、書き換えで失ってはいけない判断と契約を定める不変条件として働く。
- `instruction_rule.md` は、文書としての確認と指示文書固有の確認を、修正箇所がなくなるまで相互に繰り返すよう定めている。

### 限界

- **停止性未保証**: 抽象化、分割、統合、移動が互いに新しい修正候補を作る場合がある。
- **合流性未保証**: 同じ文書に対して、先に統合するか、先に責務分離するかで異なる正規形へ進む可能性がある。
- **規則適用の条件が意味依存**: redex の検出には、責務、契約、判断条件、情報保持への理解が必要で、純粋な構文一致では決まらない。
- **critical pair の明示不足**: 冗長性の排除と情報保持、抽象化と読解コスト、親スコープへの引き上げと局所契約維持が衝突しうる。

### 今後の rule 改善候補

- **rewrite view の明示**: リバイズを「文書項を正規形へ近づける反復」として短く定義する。
- **不変条件の前置**: 情報保持を、個別確認だけでなく全 rewrite rule にかかる共通 guard として書く。
- **衝突時優先順位**: 冗長性、構造化、厳密化、情報保持が衝突したときの tie-breaker を明示する。
- **停止条件の強化**: 「修正箇所がない」に加えて、「この rule だけでは同等な複数正規形から選べない場合は停止する」と書く。
- **規則一覧の分離**: 削除、統合、抽象化、移動、名称変更、正規化を rewrite rule として一覧化し、各 rule に適用条件、禁止条件、情報保持確認を付ける。

## References
