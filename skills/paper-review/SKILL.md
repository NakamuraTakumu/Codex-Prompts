---
name: paper-review
description: explicit scholarly constraints の下で、academic papers と LaTeX manuscripts を local revision ありまたはなしで review する。Codex が (1) revision proposals なしで findings のみを出す、(2) files を編集せず review と safe revision proposals を行う、または (3) claims、scope、logic、terminology、authorial voice を silently change せずに issue を直す safe local edits を行う必要があるときに使う。
---

# Paper Review

paper review が explicit scholarly constraints に従う必要がある場合に、この skill を使う。task が findings で止まる場合にも、local revision work まで進む場合にも使う。

## Modes

- `review-only`
  - findings のみを報告する。
  - revisions を提案しない。
  - manuscript files を編集しない。
  - review surface は full manuscript text ではなく `git diff` でもよい。
- `revision-no-change`
  - findings を報告する。
  - safe revisions を提案する。
  - manuscript files を編集しない。
- `revision`
  - findings を報告する。
  - manuscript files に safe local revisions を適用する。

## Mode 推定

- inspect、check、review、assess、issues の summarize を求める request は、default で `review-only`。
- revisions の suggest、propose、recommend、outline を求める request は、default で `revision-no-change`。
- text の fix、revise、polish、clean up、adjust を求める request は、default で `revision`。

## ワークフロー

1. scope を固定する。
   - target が whole manuscript、section、diff、または citations や front matter などの narrow issue のどれかを決める。
   - ユーザーが broader coverage を明示的に求めた場合、または concrete blocker により extra local context が厳密に必要な場合を除き、review target 外の files を読まない。
2. in-scope review units を列挙する。
   - task が narrow な場合、section 内のすべての citations など、relevant objects を先に list する。
   - input が `git diff` の場合、in-scope items は raw diff lines や whole hunks ではなく reviewable change units として定義する。
   - repeated local issue patterns は、redundancy を減らせる場合に group する。
3. review blockers を取り除く。
   - 後続判断を unreliable にする fatal build failures、unresolved references、unresolved citations、missing bibliography output を確認する。
4. criteria と evidence を選ぶ。
   - [references/criteria.md](references/criteria.md) の relevant parts だけを load する。
   - revision が in scope の場合、および `review-only` で `git diff` 内の manuscript changes が safe、local、meaning-preserving か判断する場合は、[references/revision-principles.md](references/revision-principles.md) を load する。
   - この request に必要な evidence だけを選ぶ: source、PDF、build log、diff、author guidelines、またはその他の直接 relevant artifacts。
   - target-bound evidence set を優先する: reviewed file(s)、corresponding rendered artifact(s)、corresponding build log(s)。
5. すべての in-scope items を review する。
   - important issues が selected criteria にきれいに収まらないという理由だけで suppress しない。
   - review surface が `git diff` の場合、genuinely different issue types は separate findings に分ける。ただし rationale、severity、revision judgment が同じ repeated sites は 1 つの finding で cover してよい。
6. mode に従って revisions を判断し扱う。
   - `review-only`: problem identification で止める。
   - `revision-no-change`: safe revisions を record するが、files は編集しない。
   - `revision`: smallest sufficient safe local revision を適用する。
   - ユーザーが substantive change を求めていない限り、meaning を preserve する。
   - citation fixes とその他の macro-affected wording は、macro substitution だけでなく prose revision として扱う。
   - sound fix が local でなくなった場合、revision を silently widen せず finding として残す。
7. 再確認して報告する。
   - proposed または applied revision を original intent と nearby context に照らして再確認する。
   - task 完了扱いにする前に、Markdown review note を save または update する。
   - `document-workflow` を使って storage location を選び、note を final findings と revision status に align させる。
   - safe に revise するには risky または broad すぎた unresolved issues も含め、explicit severity labels 付きで findings を報告する。

## Revision の guardrails

- 近くにあるという理由だけで、unrelated issues へ edits を広げない。
- 求められていない限り、新しい claims、evidence、examples、comparisons、caveats、interpretations を追加しない。
- manuscript の style を、より洗練されているが less faithful な prose で置き換えない。
- established terminology、notation、definitions、abbreviations、references、citation conventions を壊さない。
- requested fix が meaning preservation または local-only editing と衝突する場合は、その旨を明示する。

## 検証

- layout、cross-references、figures、captions、front matter、citation integration が rendering 後に変わりうる場合は PDF を使う。
- compile failures、unresolved references、unresolved citations、bibliography generation issues には build logs を使う。
- revision が in scope の場合、proposed または revised passage を original text と nearby context に照らして読み直す。
- LaTeX manuscripts では、citation wording または presentation が関わる場合、source と PDF の両方で verification することを優先する。
- wording が LaTeX commands、macros、annotations、PDF extraction artifacts の影響を受けうる場合、phrasing を判断する前に extracted PDF text を直接 inspect する。
- ユーザーが broader review を明示的に求めない限り、verification は review target とその directly corresponding artifacts に結びつける。extra context を集めるためだけに unrelated files を読まない。

## 報告

- findings を先に出し、summary は secondary にする。
- review findings、identified safe revisions、actually applied revisions を区別する。
- task が manuscript、section、diff に関する場合、ユーザーが severity-first reporting を明示的に求めない限り、findings は source order で並べる。
- review surface が `git diff` の場合、findings を diff lines や whole hunks に機械的に map しない。separable semantic changes の level で report する。
- near-duplicate findings を繰り返すより、repeated issue patterns を group することを優先する。
- unresolved issues は severity 順に並べる。
- 可能な場合、concrete file または artifact locations を cite する。

## Output Markdown 形式

- higher-priority instruction が明示的に禁止しない限り、すべての `paper-review` task について task 完了扱いの前に Markdown note を save または update する。
- storage location と standard outer document structure の選択には `document-workflow` を使う。
- title、metadata block、`Purpose:`、`## Background`、`## Content`、末尾の `## References` は `document-workflow` に align させる。
- `paper-review` は `## Content` 内部だけを standardize する。

```md
## Content

### Summary

<短い review summary>

### Findings

1. <短い finding title>
   - Issue Location: <section / paragraph / sentence / file / page>
   - Severity: <major | moderate | minor | nit>
   - Issue Reason: <なぜ revised すべきか>
   - Revision:
     - Content: <intended change の rough description。change を提案しない場合は `none`>
     - Nuance Shift: <wording または meaning がどう shift するか。meaning preservation が目的なら `none`>

### Revision Status

- Mode: <review-only | revision-no-change | revision>
- Safe Revisions Identified: <list または none>
- Revisions Applied: <list または none>
- Unresolved Issues: <短い note または none>

### Verification

- Source: <checked した内容>
- PDF: <checked した内容、または checked していない内容>
- Build Log: <checked した内容、または checked していない内容>
- Other Evidence: <diff / guideline / style file / none>
```

- 必要に応じて `Findings` item schema を繰り返す。
- pure review、proposal-only revision work、applied revision work に同じ schema が使えるよう、`Issue Location` と `Issue Reason` を使う。
- `Revision` は `Content` と `Nuance Shift` を持つ nested block として保つ。
- input が `git diff` の場合、1 つの hunk から複数の findings が出ることがあり、同じ issue pattern に属する場合は 1 つの finding が複数の changed sites を cover することがある。
- 1 つの finding が同じ issue の repeated instances を意図的に group する場合、`Issue Location` は複数の local sites を name してよい。
- grouped sites が different reasoning、severity、revision judgment を必要とする場合だけ、grouped finding を split する。
- detailed diffs は popup review で別途 inspect できるため、issue の disambiguation に materially help する場合を除き、`Findings` に full original/revised sentence pairs を必須にしない。
- 同じ changes について `latexdiff-popup-review` を生成する場合、popup review を別の review standard として扱わず、同じ substantive review criteria を使って per-diff popup comments に map する。
- `## References` は `document-workflow` に従い、external references 専用に保つ。

## Mode 別の出力規則

- `review-only`
  - すべての finding で `Revision -> Content` と `Revision -> Nuance Shift` を `none` にする。
  - `Safe Revisions Identified` と `Revisions Applied` は `none` に保つ。
- `revision-no-change`
  - safe revisions が identified された場合でも、`Revisions Applied` は `none` に保つ。
- `revision`
  - 一部を意図的に unapplied のまま残した場合を除き、`Safe Revisions Identified` と `Revisions Applied` は通常一致させる。

## 参照

- review criteria には [references/criteria.md](references/criteria.md) を load する。
- revision constraints には [references/revision-principles.md](references/revision-principles.md) を load する。また、`review-only` diff review で manuscript change が safe、local、meaning-preserving か判断するときにも load する。
