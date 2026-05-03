# Markdown Interpretation

参照元: `../structured_artifact_rule.md`

この file は、`structured_artifact_rule.md` の `[*]` 付き抽象語を、Markdown 文脈へ割り当てるための interpretation file である。rule 本体ではない。

本文の自然言語としての解釈は `natural_language.md` を併用する。この file は Markdown 記法が作る **スコープ**、**名前**、**責務**、**参照関係** を扱う。

## 用途

* **目的**: Markdown task で、Markdown 記法が作る構造上の境界と参照導線を固定し、task 中の推論の揺れを減らす。

* **対象**: Markdown file、Markdown fragment、frontmatter、本文、link 先、画像参照、埋め込み literal content のうち、task の **根スコープ** に含めるもの。

## 解釈スコープ

### 成果物

* **割当**: Markdown file、Markdown fragment、frontmatter、本文、link target、reference definition、footnote definition、image target、埋め込み literal content、生成または変更される rendered output。
* **補足**: 読み取り対象、変更対象、参照対象、rendered output は分けて扱う。link target、image target、reference definition、footnote definition が task の判断、導線、出力に影響する場合は、本文外でも **成果物** の一部として扱う。
* **追加**: frontmatter は、本文の **スコープ** 外にある metadata として扱う。Markdown source と rendered output で見出し階層、anchor、table、footnote、image の解決結果が変わる場合は、task が必要とする側を確認対象として明示する。
* **例外**: なし。

### スコープ

* **割当**: heading section、paragraph、list、ordered list、unordered list、list item、child list、description、description item、record、table、table header、table row、table cell、blockquote、code fence、inline code、frontmatter block、link definition、footnote definition、image reference。
* **補足**: heading level は包含関係を作る。親 heading section は、子 section の共通情報、読む順序、比較軸、参照導線を受け持つ。paragraph、list item、description item、table row、table cell は葉 **スコープ** になりやすい。
* **追加**: 同型 item の列挙は list、field を持つ item は description、同じ field set と field order で複数対象を扱う構造は record または table として扱う。field order は比較軸、読む順序、判断順序を示す **スコープ** 内の構造として扱う。code fence と inline code は、Markdown 本文ではなく literal content を保持する **スコープ** として扱う。
* **例外**: 見た目、空行、indent、強調記法だけで **スコープ** や **責務** を確定しない。code fence 内と inline code 内は Markdown 本文として解釈しない。表組みの見た目だけを目的にした table は、比較軸や field set を持つ **スコープ** とみなさない。

### 名前

* **割当**: heading text、explicit anchor、generated anchor、link text、link label、reference label、footnote label、image alt、frontmatter key、frontmatter value name、table header、description label、record field、code fence info string、file path、relative path、URL fragment。
* **補足**: Markdown 記法上の **名前** と本文中の自然言語上の **名前** は分けて扱う。heading text、anchor、reference label、frontmatter key、table header、description label、record field、code fence info string は、対象を指す **名前** として表記揺れを確認する。
* **追加**: 自動生成 anchor は、rendering 処理や platform の規則に依存する **名前** として扱う。heading text を変更する場合は、generated anchor、目次、anchor link、外部からの deep link への影響を確認する。frontmatter key と table header は、schema や downstream tool が参照する外部定義 **名前** になり得る。
* **例外**: 外部 platform、schema、link target が定義する **名前** は変更せず、必要なら周辺説明で役割を補う。

### 責務

* **割当**: heading section の導入責務、親 heading section の共通情報保持責務、paragraph の局所説明責務、list の同型 item 列挙責務、ordered list の順序提示責務、child list の従属説明責務、description の属性付け責務、record の同一 field set 保持責務、table の比較軸提示責務、blockquote の引用または外部文脈提示責務、code fence の literal content 保持責務、inline code の literal token 保持責務、frontmatter の metadata 保持責務、link の参照導線保持責務、image の視覚対象参照責務。
* **補足**: Markdown 構造の **責務** は、本文の意味内容ではなく、読者がどの単位を同列、包含、従属、引用、比較、literal、metadata、参照導線として読むかを固定する。親 **スコープ** は、子 **スコープ** に共通する前提、対象、制約、参照先を保持する。
* **追加**: 同じ親 **スコープ** に属する list item、description item、record row、table row、section は、形式、field set、field order、粒度、順序を揃える。差分が **責務** の違いなら、異なる構造、field、見出し、または説明で明示する。link と image は、本文の対象から外部または別 **スコープ** への到達手段を持つ。
* **例外**: link text、image alt、強調表示だけで参照先の **責務** を確定しない。Markdown 記法を増やしても **責務** や **参照関係** が明確にならない場合は、自然言語で関係を示す。

### 参照関係

* **割当**: heading と子 section の包含関係、親 section と並列 section の独立関係、list item 間の同列関係、ordered list item 間の順序関係、parent item と child list の従属関係、description label と value、record field と value、table header と cell、table row 間の比較関係、inline link、reference link、link label と URL、image alt と target、footnote label と footnote body、anchor link、relative path、URL fragment、frontmatter key と本文内参照、code fence info string と literal content。
* **補足**: inline link、reference link、footnote、anchor link、relative path、image reference は、表記が違っても到達先を固定する **参照関係** として扱う。table header、description label、record field は、value の比較軸や属性を固定する **参照関係** として扱う。
* **追加**: rendered output でだけ現れる anchor、footnote backlink、目次、link 解決は、task の確認対象に含まれる場合だけ **参照関係** として扱う。移動、統合、削除、heading text 変更、link 変更、record/table/list 変換では、見出し階層、anchor/link、field set、field order、literal content、frontmatter key、relative path の対応を保持できるか確認する。
* **例外**: link が存在するだけでは、参照元が参照先の内容や **責務** に依存しているとはみなさない。外部 URL や画像 target が到達不能でも、task が到達性確認を含まない場合は、Markdown 内の **参照関係** の有無だけを扱う。
