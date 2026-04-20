# Git で調査メモを扱う方法の整理

## 背景

調査メモや不具合調査の記録について、次の条件をできるだけ両立したいという相談を行った。

- 修正の背景や理由は後から追えるようにしたい
- ただし、不要になった Markdown 文書は普段の作業面には残したくない
- 可能なら Git commit に紐づけたい
- ただし main の commit 履歴はあまり荒らしたくない
- この問題は特定ワークスペース固有ではなく、一般的な Git 運用の問題として考えたい

## 要求の整理

今回の要求は、おおむね次の 4 点に整理できる。

1. 調査結果を「なぜその修正をしたか」の説明として後から参照できるようにしたい
2. 調査メモを普段の作業ツリーには置き続けたくない
3. できれば普通のファイルとして commit に残したい
4. 削除や掃除のためだけの commit で履歴が荒れるのは避けたい

## 検討した案

### 1. `document/*.md` に常に残す

概要:
調査結果を Markdown として `document/` に残し続ける。

利点:
- 見つけやすい
- GitHub 上でもそのまま見える
- 通常のファイル管理に乗る

欠点:
- 不要になった文書も蓄積しやすい
- 一時メモと恒久文書の区別が曖昧になる

評価:
恒久的に残す知識には向くが、一時的な調査メモの扱いとしては重い。

### 2. `git notes`

概要:
commit 本体を変更せず、commit に対して注釈をぶら下げる。

利点:
- commit に直接紐づく
- 作業ツリーにファイルを残さなくてよい
- commit hash を変えない

欠点:
- 見えにくい
- GitHub では扱いにくい
- push/fetch や rewrite 時の設定が必要
- 日常運用としては少し面倒

評価:
理屈はきれいだが、普段使いにはやや重い。

### 3. commit message 本文や trailer に理由を書く

概要:
修正理由を commit message に直接書く。

利点:
- 最も簡単
- `git log` や GitHub でそのまま見える
- 追加の仕組みが不要

欠点:
- 長い調査メモには向かない
- 構造化しにくい

評価:
短い理由や判断根拠には最も実用的。

### 4. 調査 Markdown を一度 commit に含め、後で削除する

概要:
調査 `md` を修正 commit に含め、その後に削除 commit を入れる。

利点:
- 普通のファイルとして commit に残る
- 後から `git show <commit>:path/to/file.md` で読める

欠点:
- 追加と削除の 2 イベントになる
- main の履歴が荒れやすい
- 削除 commit がノイズになりやすい

評価:
「普通のファイルとして commit に残す」を最優先するなら最も素直だが、履歴の見栄えとは衝突する。

### 5. `post-commit` hook で自動削除する

概要:
commit 後に hook で調査メモを消す。

利点:
- 手動削除の手間は減る

欠点:
- tracked file を消すと作業ツリーが dirty になる
- commit 直後に未コミット変更が発生する
- 運用が不安定になりやすい

評価:
未追跡ファイルの掃除には向くが、tracked な調査メモの削除用途には不向き。

### 6. `sparse-checkout`

概要:
ファイルを削除せず、ローカル作業ツリーにだけ展開しない。

利点:
- 履歴は荒れない
- GitHub 上には残る
- ローカルでは見えなくできる

欠点:
- 削除ではなく非表示
- GitHub や履歴には普通に残る
- 空ディレクトリをそのまま見せ続ける用途には向かない

評価:
「履歴には残してよいが、手元では邪魔」という要求には有効。ただし「不要になったので消したい」とは別問題。

### 7. 別 branch にだけ残す

概要:
調査 Markdown は専用 branch に置き、main には入れない。

利点:
- main の履歴を汚しにくい
- 普通のファイルとして保存できる

欠点:
- 参照経路が一段増える
- branch 運用のルールが必要

評価:
main の見栄えを重視するなら有力だが、少し管理が増える。

### 8. `document/` の世代管理として扱い、commit 直前に `previous/` を確定する

概要:
調査メモを「ノート」ではなく「ドキュメント」とみなし、`document/` 直下に作業中ファイルを置く。commit 直前に、ひとつ前の世代を `HEAD` の commit 情報で確定ディレクトリへ移し、今回の作業中ファイルを `previous/` に移してから commit する。

基本構成:
- `document/` 直下: 今回作業中のドキュメント
- `document/previous/`: 次の commit で確定されるひとつ前の世代
- `document/<shortsha>-<slug>/`: 確定済みの世代

状態遷移:

初期状態:
```text
document/
  survey.md
  citep-fix.md
  citep-fix2.md
```

1回目の commit 直前:
```text
document/
  previous/
    survey.md
    citep-fix.md
    citep-fix2.md
```

この状態で 1回目の commit を作る。commit が `3fa4c2e-first-commit-message` になったとする。

その後の作業中:
```text
document/
  survey.md
  section7-note.md
  previous/
    survey.md
    citep-fix.md
    citep-fix2.md
```

2回目の commit 直前:
```text
document/
  3fa4c2e-first-commit-message/
    survey.md
    citep-fix.md
    citep-fix2.md
  previous/
    survey.md
    section7-note.md
```

この状態で 2回目の commit を作る。commit が `a81d902-second-commit-message` になったとする。

3回目の commit 直前:
```text
document/
  3fa4c2e-first-commit-message/
    survey.md
    citep-fix.md
    citep-fix2.md
  a81d902-second-commit-message/
    survey.md
    section7-note.md
  previous/
    survey.md
    third-note.md
```

利点:
- tracked file を `post-commit` で消さないため dirty にならない
- 同じレポジトリ、同じ branch のままドキュメントを履歴に残せる
- commit hash と commit message の slug を使って、後から対応づけしやすい
- `document/` を作業中領域と履歴領域に分けられる

欠点:
- 1 世代ぶんの `previous/` を常に意識する必要がある
- commit 前に移動整理を必ず行う必要がある
- `document/` 直下のファイルと `previous/` を機械的に移す仕組みがないと運用漏れが起こりやすい

評価:
これまで出た案の中では、普通のファイルとしてレポジトリに残したい、履歴ノイズを最小限にしたい、dirty な状態は避けたい、という条件のバランスが最もよい。`post-commit` hook より、`pre-commit` hook か `git commit` のラッパースクリプトで実装する方が自然である。

## 議論の中で確認した重要点

### `dirty` とは何か

`HEAD` と作業ツリーまたは index が一致していない状態を指す。
tracked file を `post-commit` で消すと、commit 直後に未コミットの削除変更が発生するため、作業状態が dirty になる。

### `sparse-checkout` とは何か

Git 履歴には残したまま、ローカル作業ツリーに一部の tracked file だけを展開しない機能。
削除ではなく、見え方を変える機能である。

### 「commit に普通のファイルとして残す」の意味

これは、その Markdown がどこかの commit の tree に含まれることを意味する。
そのため、同じ branch で最終的に消したいなら、通常は「追加 commit」と「削除 commit」の両方が必要になる。

## 現時点での整理

要求同士にトレードオフがある。

- 「普通のファイルとして commit に残したい」を優先するなら:
  - 同じ branch で追加して後で削除する
  - あるいは別 branch に残す

- 「履歴をきれいに保ちたい」を優先するなら:
  - `git notes`
  - commit message 本文
  - commit trailer

- 「ローカル作業面からだけ消したい」を優先するなら:
  - `sparse-checkout`

## 実務上の暫定結論

最も自然な整理は次のとおり。

- 恒久的に残す価値のある文書は `document/` に残す
- 一時的な調査メモは恒久文書と分けて扱う
- 「普通のファイルとして commit に残す」を本当に重視する場合は、`document/` の世代管理として扱い、commit 直前に `previous/` を確定ディレクトリへ移す方式が最も有望である
- この方式を採るなら、`post-commit` での自動削除ではなく、`pre-commit` hook かラッパースクリプトで `document/` を整理してから commit するのがよい
- `post-commit` で tracked file を自動削除する案は成立はするが、dirty 状態を常態化させるため、標準運用には向かない

完全に都合のよい単一解はなく、何を最優先するかで方式が決まる。

## 実装メモ

この方式を実装する場合は、次の分担が扱いやすい。

- `tool/rotate_document_before_commit.sh`
  - `document/previous/` を `document/<HEAD shortsha>-<HEAD slug>/` に確定する
  - `document/` 直下の作業中ファイルを `document/previous/` に移す
- `.githooks/pre-commit`
  - 上記スクリプトを呼ぶ
  - `git add -A document/` を行う
- `tool/setup_git_hooks.sh`
  - `git config core.hooksPath .githooks` を設定する
  - 実行権限を与える

この分担にしておくと、hook 自体は薄く保てるため壊れにくく、処理本体は repo 管理下のスクリプトとして再利用しやすい。
