# Paper Review Criteria

current review request に relevant な sections だけを使う。
これらの criteria は exhaustive または closed list ではなく、default review lenses として扱う。listed categories に収まらない重要な問題がある場合も報告し、impact によって classify する。

## 評価原則

- local stylistic polish よりも claims の validity を優先する。
- logical gaps、evidential weakness、reproducibility issues、prior work に対する mispositioning、submission-rule violations は、taste-based edits より重大に扱う。
- issues は reader understanding、correctness、submission quality への impact で判断する。
- rewrite suggestion の有無で severity を決めない。

## 評価項目

### 1. 主張と貢献

- paper の main contribution は十分早い段階で clear か。
- stated conclusions は paper が実際に示している内容から follow するか。
- contribution は overclaiming なしに適切な strength で framed されているか。

### 2. 構成と論理の流れ

- sections と paragraphs は problem setup から conclusion へ自然に進んでいるか。
- definitions、assumptions、notation、terminology は使われる前に導入されているか。
- 各 paragraph の explanation は、その lead claim を実際に support しているか。

### 3. 方法、根拠、妥当性

- reader は provided description から何が行われたかを follow できるか。
- experiments、analyses、examples は stated claims を support するのに十分か。
- limitations と prerequisites は必要な箇所で explicit になっているか。
- wording が evidence で support されない causation または generality を imply していないか。

### 4. 先行研究に対する位置づけ

- 重要な related works が欠けていないか。
- prior work との差分が relabeling ではなく substantively に説明されているか。
- citations は、それが support するはずの claims に接続されているか。

### 5. 表現と読みやすさ

- sentences が長すぎる、または dense すぎるために、subject、predicate、modifier relations が unclear になっていないか。
- `this`、`it`、`they` などの pronouns や short references は unambiguous か。
- terminology、abbreviations、symbols は consistent か。
- reader は stronger claims の support を素早く見つけられるか。

### 6. Academic English

- prose は grammatical であるだけでなく、academic English として natural か。
- translation-like wording が heavy noun phrases や unclear modification を作っていないか。
- claim strength は available support と合っているか。
- articles、number、countability、tense、prepositions は context 内で natural に使われているか。
- discourse markers と citation-integrated sentences は、sentence level だけでなく paragraph level でも natural か。

### 7. 図、式、引用

- figures と equations は text 内で referenced され、explained されているか。
- captions は reader を orient するのに十分な意味を持っているか。
- labels、references、surrounding explanations は一致しているか。
- citations は grammatical にも rhetorical にも自然に integrated されているか。

### 8. style と submission compliance

- manuscript は required style file、class file、bibliography style に従っているか。
- title、author information、affiliations、acknowledgments、anonymity、abstract、keywords、headings は compliant か。
- page limits、appendix rules、supplementary-material references、camera-ready-only elements は正しく handled されているか。
- manual formatting が style file または submission rules と conflict していないか。

### 9. LaTeX と page quality

- headings、lists、figures、page breaks、footnotes は cleanly に rendered されているか。
- equation numbers、figure numbers、references、bibliography entries は intact か。
- PDF が source では obvious でない ambiguity または awkwardness を introduce していないか。
- extracted PDF text が、source や page images では見落としやすい command leakage、annotation text、wording artifacts を reveal していないか。

## 重大度

- `major`: claims の correctness、logical coherence、methodological validity、reproducibility、prior work に対する positioning、submission-rule compliance に影響する problems。
- `moderate`: misreading risk を materially に増やす、explanations を弱める、noticeable English awkwardness を作る、citation integration を壊す、または important formatting issues を introduce する problems。
- `minor`: local clarity improvements、terminology cleanup、limited ambiguity reduction、light prose polishing。
- `nit`: impact が低い、純粋に preference-based な tweaks。
