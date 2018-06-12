---
title: 算法记号
tags:
  - Algorithms
mathjax: true
date: 2018-06-11 22:30:16
categories: 算法
---

# 算法常用记号梳理

在很多情况下，描述一个算法的运行时间是有用的，为此，需要定义一套统一的算法渐进记号来合适的描述算法的运行效率。

<!-- more -->

## $\Theta$ 渐进紧确界

定义一：设$f(n)$和$g(n)$是定义域为自然数集合的函数。如果$\lim_{n \rightarrow \infty}\frac{f(n)}{g(n)}$存在，并且等于某个常数$c(c>0)$，那么$f(n)=\Theta(g(n))$。通俗理解为$f(n)$和$g(n)$同阶，$\Theta$用来表示算法的精确阶。

$$\Theta(g(n)) = \{ f(n):\lim_{n \rightarrow \infty}\frac{f(n)}{g(n)} = c | c>0 \}$$

定义二：若存在正常量$c_1$、$c_2$，使得对于足够大的$n$，函数$f(n)$能“夹入”$c_1g(n)$与$c_2g(n)$之间，则$f(n)$属于集合$\Theta(g(n))$，记作$f(n) \in \Theta(g(n))$。作为代替，我们通常记“$f(n)=\Theta(g(n))$”。

$$\Theta(g(n)) = \{ f(n):\exists c_1,c_2,n_0,\forall n \ge n_0,0 \le c_1g(n) \le f(n) \le c_2g(n) \}$$

## $O$ 渐进上界

定义：设$f(n)$和$g(n)$是定义域为自然数集$N$上的函数。若存在正数$c$和$n_0$，使得对一切$n \ge n_0$都有$0 \le f(n) \le cg(n)$成立，则称$f(n)$的渐进的上界是$g(n)$，记作$f(n)=O(g(n))$。通俗的说n满足一定条件范围内，函数$f(n)$的阶不高于函数$g(n)$。

$$ O(g(n)) = \{ f(n):\exists c,n_0,\forall n \ge n_0,0 \le f(n) \le cg(n) \} $$

  例如：设$f(n)=n^2+n$,则
  $f(n)=O(n^2)$，取$c=2$,$n_0=1$即可
  $f(n)=O(n^3)$，取$c=1$,$n_0=2$即可。显然，O(n^2)作为上界更为精确。

## $o$ 非渐进紧确上界

定义1：设$f(n)$和$g(n)$是定义域为自然数集N上的函数。若对于任意正数$c$，都存在$n_0$，使得对一切$n≥n_0$都有$0 \ge f(n)<cg(n)$成立，则称$f(n)$的渐进的非紧确上界是$g(n)$，记作$f(n)=o(g(n))$。通俗的说$n$满足一定条件范围内，函数$f(n)$的阶低于函数$g(n)$。

$$ o(g(n)) = \{f(n):\forall c,\exists n_0,\forall n \ge n_0,0 \ge f(n) < cg(n) \} $$

定义2：设$f(n)$和$g(n)$是定义域为自然数集合的函数。如果$lim_{n\rightarrow \infty}\frac{f(n)}{g(n)}=0$，那么$f(n)=o(g(n))$。通俗理解为$f(n)$低于$g(n)$的阶。

$$\Theta(g(n)) = \{ f(n):\lim_{n \rightarrow \infty}\frac{f(n)}{g(n)} = 0 \}$$

  由O记号提供的渐近上界可能是渐近紧确的，也可能是非紧确的。
    如：$2n^2=O(n^2)$是渐近紧确的，而$2n=O(n^2)$是非紧确上界。

  例子：$f(n)=n^2+n$，则$f(n)=o(n^3)$

## $\Omega$ 渐进下界

定义：设$f(n)$和$g(n)$是定义域为自然数集$N$上的函数。若存在正数$c$和$n_0$，使得对一切$n≥n_0$都有$0≤cg(n)≤f(n)$成立，则称$f(n)$的渐进的下界是$g(n)$，记作$f(n)=\Omega(g(n))$。通俗的说n满足一定条件范围内，函数$f(n)$的阶不低于函数$g(n)$。

$$\Omega(g(n)) = \{ f(n):\exists c,n_0,\forall n \ge n_0,0 \le cg(n) \le f(n) \}$$

## $\omega$ 非渐进紧确下界

定义1：设$f(n)$和$g(n)$是定义域为自然数集N上的函数。若对于任意正数$c$，都存在$n_0$，使得对一切$n \ge n_0$都有$0 \le cg(n) < f(n)$成立，则称$f(n)$的渐进的非紧确下界是$g(n)$，记作$f(n)= \omega (g(n))$。通俗的说$n$满足一定条件范围内，函数$f(n)$的阶高于函数$g(n)$。

$$\Omega(g(n)) = \{ f(n):\forall c, \exists n_0,\forall n \ge n_0,0 \le cg(n) \le f(n) \}$$

定义2：设$f(n)$和$g(n)$是定义域为自然数集合的函数。如果$\lim_{n\rightarrow \infty}\frac{f(n)}{g(n)}=\infty$，那么$f(n)=o(g(n))$。通俗理解为$f(n)$高于$g(n)$的阶。

$$ \Omega(g(n)) = \{ f(n):\lim_{n \rightarrow \infty} \frac{f(n)}{g(n)} = \infty \} $$

## 总结

| 记号     | 含义       | 通俗理解 |
| :------: | :---------: | :------: |
| $\Theta$ | 渐进紧确界     | =        |
| $O$      | 渐进上界       | $\le$    |
| $o$      | 非紧的渐进上界 | <        |
| $\Omega$ | 渐进下界       | $\ge$    |
| $\omega$ | 非紧的渐进下界 | >        |