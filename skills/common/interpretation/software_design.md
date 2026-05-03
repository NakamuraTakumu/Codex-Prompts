# Software Design Interpretation

参照元: `../structured_artifact_rule.md`

この file は、`structured_artifact_rule.md` の `[*]` 付き抽象語を、ソフトウェア設計 / code の文脈へ割り当てるための interpretation file である。rule 本体ではない。

## 用途

* **目的**: software design task で、抽象語の解釈観点を固定し、task 中の推論の揺れを減らす。

* **対象**: code、設計記述、設定、test、生成物のうち、task の **根スコープ** に含めるもの。

## 解釈スコープ

### 成果物

* **割当**: software artifact の境界、変更対象の source、依存 test、設定、schema、生成物、設計記述、前提 public API、主要 module 境界、test の期待。
* **補足**: 読み取り対象、変更対象、参照対象は分けて扱う。
* **追加**: caller、interface、test が **責務** を固定する場合は、変更対象でなくても参照対象に含める。
* **例外**: なし。

### スコープ

* **割当**: code 上または設計上の境界、package、module 群、public function、handler。
* **補足**: repo、package、module、file、type、function、test、configuration unit などの粒度は、task の **責務** と影響範囲に応じて固定する。同じ code element でも、task によって **根スコープ**、**親スコープ**、**葉スコープ** の扱いは変わる。
* **追加**: なし。
* **例外**: なし。

### 名前

* **割当**: code / design artifact 内の対象を参照する表現、変数名、関数名、型名、module 名、file 名、設定 key、test 名。
* **補足**: repo、package、module、public API などから task に必要な観測境界を固定する。観測境界によって、同じ形の **名前** でも **内部定義名** 側か **外部定義名** 側かが変わる。
* **追加**: なし。
* **例外**: **外部定義名** 側の **名前** は変更せず、必要なら周辺説明で役割を補う。

### 責務

* **割当**: 役割、制約、期待される振る舞い、値や構造の形、入力と出力、実行時の振る舞い、失敗時の扱い、副作用、lifecycle、検証で固定される期待。
* **補足**: **責務** は、外側から何に依存されているかを見るための観点で分ける。独立した **責務** が混在する場合は分離候補にし、分けると **参照関係** が追いにくい場合は統合候補にする。
* **追加**: なし。
* **例外**: 型だけでは **責務** を確認済みとはみなさない。

### 参照関係

* **割当**: **スコープ**、**名前**、**責務** の間の依存、利用、所有、検証の関係、静的な参照、実行時の呼び出し、データの受け渡し、所有または構成、設定の参照、test から production への参照。
* **補足**: 静的に見えにくい参照も、task の **責務** に影響する場合は **参照関係** として扱う。
* **追加**: 文字列 key、reflection、configuration、routing、event name。
* **例外**: import や type reference の存在だけでは、実行時の **参照関係** とみなさない。test の期待は production 側の **責務** を確認する材料であり、**責務** 自体とは混同しない。
