---
title: 算法之算法分析
tags:
  - Algorithms
mathjax: true
date: 2018-06-11 22:30:16
categories: 算法
---

算法分析
========

在很多情况下，描述一个算法的运行时间是有用的，为此，需要定义一套统一的算法渐进记号来合适的描述算法的运行效率。然后我们通过各种方法对不同的算法运行效率进行分析。

<!-- more -->

算法时间复杂度记号
=================

$\Theta$ 渐进紧确界
---------------------

>定义一：设$f(n)$和$g(n)$是定义域为自然数集合的函数。如果$\lim_{n \rightarrow \infty}\frac{f(n)}{g(n)}$存在，并且等于某个常数$c(c>0)$，那么$f(n)=\Theta(g(n))$。通俗理解为$f(n)$和$g(n)$同阶，$\Theta$用来表示算法的精确阶。

$$\Theta(g(n)) = \{ f(n):\lim_{n \rightarrow \infty}\frac{f(n)}{g(n)} = c | c>0 \}$$

>定义二：若存在正常量$c_1$、$c_2$，使得对于足够大的$n$，函数$f(n)$能“夹入”$c_1g(n)$与$c_2g(n)$之间，则$f(n)$属于集合$\Theta(g(n))$，记作$f(n) \in \Theta(g(n))$。作为代替，我们通常记“$f(n)=\Theta(g(n))$”。

$$\Theta(g(n)) = \{ f(n):\exists c_1,c_2,n_0,\forall n \ge n_0,0 \le c_1g(n) \le f(n) \le c_2g(n) \}$$

$O$ 渐进上界
-------------

>定义：设$f(n)$和$g(n)$是定义域为自然数集$N$上的函数。若存在正数$c$和$n_0$，使得对一切$n \ge n_0$都有$0 \le f(n) \le cg(n)$成立，则称$f(n)$的渐进的上界是$g(n)$，记作$f(n)=O(g(n))$。通俗的说n满足一定条件范围内，函数$f(n)$的阶不高于函数$g(n)$。

$$ O(g(n)) = \{ f(n):\exists c,n_0,\forall n \ge n_0,0 \le f(n) \le cg(n) \} $$

  例如：设$f(n)=n^2+n$,则
  $f(n)=O(n^2)$，取$c=2$,$n_0=1$即可
  $f(n)=O(n^3)$，取$c=1$,$n_0=2$即可。显然，O(n^2)作为上界更为精确。

$o$ 非渐进紧确上界
----------------

>定义1：设$f(n)$和$g(n)$是定义域为自然数集N上的函数。若对于任意正数$c$，都存在$n_0$，使得对一切$n≥n_0$都有$0 \le f(n)<cg(n)$成立，则称$f(n)$的渐进的非紧确上界是$g(n)$，记作$f(n)=o(g(n))$。通俗的说$n$满足一定条件范围内，函数$f(n)$的阶低于函数$g(n)$。

$$ o(g(n)) = \{f(n):\forall c,\exists n_0,\forall n \ge n_0,0 \le f(n) < cg(n) \} $$

>定义2：设$f(n)$和$g(n)$是定义域为自然数集合的函数。如果$lim_{n\rightarrow \infty}\frac{f(n)}{g(n)}=0$，那么$f(n)=o(g(n))$。通俗理解为$f(n)$低于$g(n)$的阶。

$$\Theta(g(n)) = \{ f(n):\lim_{n \rightarrow \infty}\frac{f(n)}{g(n)} = 0 \}$$

  由O记号提供的渐近上界可能是渐近紧确的，也可能是非紧确的。
    如：$2n^2=O(n^2)$是渐近紧确的，而$2n=O(n^2)$是非紧确上界。

  例子：$f(n)=n^2+n$，则$f(n)=o(n^3)$

$\Omega$ 渐进下界
-------------------

>定义：设$f(n)$和$g(n)$是定义域为自然数集$N$上的函数。若存在正数$c$和$n_0$，使得对一切$n≥n_0$都有$0≤cg(n)≤f(n)$成立，则称$f(n)$的渐进的下界是$g(n)$，记作$f(n)=\Omega(g(n))$。通俗的说n满足一定条件范围内，函数$f(n)$的阶不低于函数$g(n)$。

$$\Omega(g(n)) = \{ f(n):\exists c,n_0,\forall n \ge n_0,0 \le cg(n) \le f(n) \}$$

$\omega$ 非渐进紧确下界
----------------------

>定义1：设$f(n)$和$g(n)$是定义域为自然数集N上的函数。若对于任意正数$c$，都存在$n_0$，使得对一切$n \ge n_0$都有$0 \le cg(n) < f(n)$成立，则称$f(n)$的渐进的非紧确下界是$g(n)$，记作$f(n)= \omega (g(n))$。通俗的说$n$满足一定条件范围内，函数$f(n)$的阶高于函数$g(n)$。

$$\Omega(g(n)) = \{ f(n):\forall c, \exists n_0,\forall n \ge n_0,0 \le cg(n) \le f(n) \}$$

>定义2：设$f(n)$和$g(n)$是定义域为自然数集合的函数。如果$\lim_{n\rightarrow \infty}\frac{f(n)}{g(n)}=\infty$，那么$f(n)=o(g(n))$。通俗理解为$f(n)$高于$g(n)$的阶。

$$ \Omega(g(n)) = \{ f(n):\lim_{n \rightarrow \infty} \frac{f(n)}{g(n)} = \infty \} $$

符号总结
-----------

| 记号     | 含义           | 通俗理解 |
| :------: | :------------: | :------: |
| $\Theta$ | 渐进紧确界     | =        |
| $O$      | 渐进上界       | $\le$    |
| $o$      | 非紧的渐进上界 | <        |
| $\Omega$ | 渐进下界       | $\ge$    |
| $\omega$ | 非紧的渐进下界 | >        |

+ 传递性: 所有五个标记
  + $f(n)= \Theta(g(n))$且$g(n)= \Theta(h(n))\rightarrow f(n)= \Theta(h(n))$
+ 自反性: O、$\Theta$、$\Omega$
  + $f(n)= \Theta(f(n))$
+ 对称性: $\Omega$
  + $f(n)= \Theta(g(n))$ 当且仅当$g(n)= \Theta(f(n))$
+ 反对称性:
  + $f(n) = O(g(n))$当且仅当 $g(n)= \Omega(f(n))$
  + $f(n) = o(g(n))$当且仅当 $g(n)= \omega(f(n))$

一些典型的增长阶：
$$ O(1) < O(\lg n) < O(\sqrt n) < O(n) < O(n \lg n) < O(n^2) < O(n^3) < O(2^n) < O(n!)$$

和式的估计与界限
================

和式的估计
--------------

$$ \sum_{k=1}^n(ca_k+b_k) = c\sum_{k=1}^na_k+\sum_{k=1}^nb_k $$

$$ \sum_{t=1}^ni=\frac{n(n+1)}{2} = \theta(n^2) $$

$$ \sum_{k=1}^nx^k = 1+x+x^2+ \dots + x^n = \frac{x^{n+1}-1}{x-1} \qquad x \not= 1$$

$$ \sum_{k=0}^{\infty} x^k = \frac{1}{1-x} \qquad |x|<1$$

$$ H_n = \sum_{k=1}^n\frac{1}{k} = \ln n+ O(1)$$

递归方程
-------------

>递归方程：递归方程是使用小的输入值来描述一个函数的方程或者不等是。

$$T(n)=\left\{
  \begin{array}{ll}
  \Theta (1) & if \quad n = 1 \\
  2T(\frac{n}{2}) + \Theta(n) & if \quad n \ge 1
  \end{array} \right.$$

$$ T(n) = \Theta(n \log n)$$

求解递归方程的三个主要方法：

+ 替换方法
  1. 首先猜想
  2. 然后用数学归纳法证明
+ 迭代方法
  1. 把方程转化为一个和式
  2. 然后用估计和的方法来求解
+ Master定理
  + 求解型为$T(n)=aT(\frac{n}{b})+f(n)$的递归方程

Master定理
-----------

>Master定理：设$a \ge 1$和$b>1$是常数，$f(n)$是一个函数，$T(n)$是定义在非负整数级上的函数$T(n)=aT(\frac{n}{b})+f(n)$，$T(n)$可以如下求解：

1. 若$f(n) = O(n^{\log_b a-\epsilon})$，$\epsilon > 0$是常数，则$T(n) = \theta(n^{\log_b a})$
2. 若$f(n) = O(n^{\log_b a})$，则$T(n) = \theta(n^{\log_b a}\lg n)$
3. 若$f(n) = \Omega(n^{\log_b a + \epsilon})$，$\epsilon > 0$是常数，且对于所有充分大的$n$有$af(\frac{n}{b}) \le cf(n)$,$c < 1$是常数，则$T(n) = \theta(f(n))$

换言之，我们比较$f(n)$和$n^{\log_b a}$：

1. 则$n^{\log_b a}$大，$T(n) = \theta(n^{\log_b a})$
2. 若$f(n)$大，则$T(n) = \theta(f(n))$
3. 若$f(n)$与$n^{\log_b a}$同阶，$T(n) = \theta(n^{\log_b a}\lg n) = \theta(n^{\log_b a}\lg n)$

习题
=========

>求解递归方程$T(n) = T(\frac{5n}{6} + n)$

1. $a = 1$,$b = \frac{6}{5}$,$f(n) = n$
2. $n^{\log_ba} = 1 < f(n)$
3. $T(n) = \Theta(n)$

>证明或否证明$f(n) + o(f(n)) = \theta(f(n))$

$$
\begin{array}{ll}
\lim_{n \rightarrow \infty}\frac{\theta(f(n))}{f(n) + o(f(n))} &= \lim_{n \rightarrow \infty}\frac{1}{\frac{f(n)}{\theta(f(n))} + \frac{o(f(n))}{\theta(f(n))}} \\
  &= \lim_{n \rightarrow \infty}\frac{1}{\frac{1}{c} + 0} \\
  &= c
\end{array}
$$

>证明：设k是任意常数正整数，则$\log^kn = o(n)$

$$
\begin{array}{ll}
\lim_{n \rightarrow \infty}\frac{\log^kn}{n} &= \lim_{n \rightarrow \infty}\frac{k\log^{k-1}n}{n} \\
&= \lim_{n \rightarrow \infty}\frac{k(k-1)\log^{k-2}n}{n} \\
&= \lim_{n \rightarrow \infty}\frac{k!}{n} \\
&= 0
\end{array}
$$

>证明$O(f(x))+O(g(x))=O(max(f(x),g(x)))$

$$\begin{gathered}
   f(x) \le \max(f(x),g(x)) \\
   g(x) \le \max(f(x),g(x)) \\
   f(x) + g(x) \le 2\max(f(x),g(x))
\end{gathered}$$

满足定义，所以$O(f(x)+g(x)) = O(\max(f(x),g(x)))$得证。

>求解递归方程$T(n)=T(\lceil \frac{n}{2} \rceil) + 1$,$\lceil x \rceil$用以表示不小于x的整数中最小的一个。

$$\begin{aligned}
T(n) & = T(\lceil \frac{n}{2} \rceil) + 1\\
     & = T(\lceil \frac{\lceil \frac{n}{2} \rceil}{2} \rceil) + 2 \\
     & = \lceil \log_2n \rceil = O(\log n)
\end{aligned}$$