# 圏論の極限と Set での構成

- Created: 2026-05-01 07:09 UTC
- Updated: 2026-05-01 07:09 UTC
- Model: gpt-5.5
- Reasoning-Effort: medium
- Session: 019de25e-3dbb-7bd0-8b0e-5c33bef7b04c
- Repository: none
- Related-Commit: none

Responsibility: 圏論の極限が表す普遍性と、Set での具体的な構成を後続参照用に整理する。

## Background

ユーザーから、圏論における極限で定義される普遍性と Set における集合構成の説明を求められた。

## Result

圏論で、図式 \(M : \mathcal I \to \mathcal C\) の極限は、図式への cone のうち普遍的なものとして定義される。具体的には、対象 \(L\) と射影 \(p_i : L \to M_i\) があり、任意の射 \(\phi : i \to i'\) について
\[
p_{i'} = M(\phi)\circ p_i
\]
を満たす。さらに、任意の対象 \(W\) と互換な族 \(q_i : W \to M_i\) に対し、一意な射 \(q : W \to L\) が存在して \(q_i = p_i\circ q\) となる。この一意な媒介射が「普遍性」の中身である。

同じ内容は Hom 集合で
\[
\mathrm{Mor}_{\mathcal C}(W,L)
\cong
\lim_i \mathrm{Mor}_{\mathcal C}(W,M_i)
\]
と表せる。つまり \(L\) への射は、図式 \(M\) の各対象への互換な射の族をちょうど分類する。Yoneda 的には、この性質が \(L\) を一意同型まで決める。

Set では、図式 \(M : \mathcal I \to \mathbf{Set}\) の極限は次の集合である。
\[
\lim_{\mathcal I} M
=
\{(m_i)_{i\in \mathrm{Ob}(\mathcal I)} \in \prod_{i\in \mathrm{Ob}(\mathcal I)} M_i
\mid
\forall \phi:i\to i',\ M(\phi)(m_i)=m_{i'}\}.
\]
したがって、Set の極限の元は「各集合 \(M_i\) から 1 個ずつ元を選び、図式のすべての矢印に沿って矛盾しないようにした互換な元の族」である。

代表例:

- 空図式の極限: 終対象。Set では任意の 1 点集合。
- 離散図式の極限: 積。Set では直積集合。
- 平行射 \(f,g:X\to Y\) の極限: equalizer。Set では \(\{x\in X\mid f(x)=g(x)\}\)。
- cospan \(X\to Z \leftarrow Y\) の極限: pullback。Set では \(\{(x,y)\in X\times Y\mid f(x)=g(y)\}\)。

一般の Set 極限は「直積の部分集合」として構成できる。制約は図式の各矢印 \(\phi\) ごとに \(M(\phi)(m_i)=m_{i'}\) を要求する等式であり、圏論的には積から作った 2 つの写像の equalizer と見なせる。

## Notes

Stacks Project は共変図式 \(M : \mathcal I \to \mathbf{Set}\) の記法で説明している。nLab には反変・presheaf 記法 \(F : D^{op}\to \mathbf{Set}\) の表示もあるため、矢印方向に応じて互換条件の添字が逆向きになる。

## References

- Stacks Project, Categories, Section 4.14, "Limits and colimits": https://stacks.math.columbia.edu/tag/002D
- Stacks Project, Categories, Definition 4.14.1: https://stacks.math.columbia.edu/tag/002E
- Stacks Project, Categories, Section 4.15, "Limits and colimits in the category of sets": https://stacks.math.columbia.edu/tag/002U
- nLab, "limit": https://ncatlab.org/nlab/show/limit
