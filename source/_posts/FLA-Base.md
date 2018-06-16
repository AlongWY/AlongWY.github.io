---
title: 形式语言与自动机基础
tags:
  - Formal Languages and Automata
mathjax: true
date: 2018-06-14 11:28:00
categories: 形式语言与自动机
---

# 形式语言与自动机理论

计算机科学是关于计算知识的有系统的整体, 其始源可回溯到欧几里德关于一些算法的设计和巴比伦人关于渐进复杂性和归约性的使用. 然而, 现今的计算机学科的发展, 起源于两个重要的事件: 现代数字计算机的出现和算法概念的形式化.

计算机科学有两个主要的部分: 第一, 构成计算系统基础的一些基本概念和模型; 第二, 设计计算系统 (软件和硬件) 的工程技术. 形式语言与自动机理论, 就是作为第一部分, 即构成计算基础的基本概念的引论.

<!-- more -->

# 基本概念

1. 字母表(Alphabet):有穷非空符号集。例如$\Sigma = \{0,1\}$，$\Sigma = \{a,b, \dots ,z\}$
2. 字符串(String):某个字母表中符号的有穷序列, 也称字(words). 例如, 若$\Sigma = \{0,1\}$, 则000,111,0101,10101为$\Sigma$上的字符串.
3. 空串(Empty String):长度为0的串. 一般表示为$\epsilon$.
4. 串的长度:串中符号的个数.更准确的说,是串中符号所占的位置数. 若串为 w, 那么长度记为|w|. 例如,|011|=3,|$\epsilon$|=0.
5. 串的连接(Concatenation):如果x和y是串, 那么xy标识将x和y进行连接后得到的串. 例如x=01101和y=110,那么xy=01101110.
6. 串的逆序(Reverse): 若$w=a_1a_2 \dots a_n$ , 则记$w$的逆序为$w^R = a_n a_{n-1} \dots a_1$.
7. 集合的连接(或乘积):$AB=\{ab|a \in A,b \in B\}$.
8. 集合的幂:(1)$\Sigma^0=\{ \epsilon \}$;(2)$\Sigma^n=\Sigma_{n-1}\Sigma(n \ge 1)$.
9. 正闭包(Positive closure):$\Sigma^+=\Sigma \cup \Sigma^2 \cup \Sigma^3 \cup \Sigma^4 \dots $
10. 克林闭包(Kleene closure):$\Sigma^*=\Sigma^0 \cup \Sigma \cup \Sigma^2 \cup \Sigma^3 \cup \Sigma^4 \dots $
11. 串的前缀(prefix)、后缀(suffix)、真前缀(proper prefix)、真后缀(proper suffix)

# 语言

语言 (Languages): 若$\Sigma$是字母表, 那么 $\forall L \subseteq \Sigma^*$ ,$L$称为字母表$\Sigma$上的一个语言.
例如:

1. 自然语言, C语言等
2. $\Sigma^*$是任意字母表$\Sigma$上的语言
3. $\oslash$是任意字母表$\Sigma$上的语言, 空语言
4. $\{ \epsilon \}$是任意字母表$\Sigma$上的语言, 仅有一个空串的语言, 但 $\oslash \not= \{ \epsilon \}$.

语言以集合的方式来描述: $\{w|$something about $w\}$, 例如

1. $\{w|w$包含相等的0和1$\}$
2. $\{w|w$是素数的二进制表示$\}$
3. $\{0^n 1^n | n \ge 1\}$
4. $\{0^i 1^j | 0 \le i \le j\}$
