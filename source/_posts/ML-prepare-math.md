---
title: 机器学习数学预备知识
tags:
  - Math
  - Mathine Learing
mathjax: true
date: 2018-09-08 21:53:22
categories:
  - 机器学习
---

# 机器学习数学预备知识

1. 高等数学
2. 线性代数
3. 概率论
4. 信息论

<!-- more -->

# 最大似然估计
最大似然估计是一种“模型已定，参数未知”的方法，一些复杂的条件下，是很难通过直观的方式获得答案的，这时候理论分析就尤为重要了，这也是学者们为何要提出最大似然估计的原因。

> 假设一个袋子装有白球与红球，比例未知，现在抽取10次（每次抽完都放回，保证事件独立性），假设抽到了7次白球和3次红球，在此数据样本条件下，可以采用最大似然估计法求解袋子中白球的比例。

当然，这种数据情况下很明显，白球的比例是70%，但如何通过理论的方法得到这个答案呢？我们可以定义从袋子中抽取白球和红球的概率如下：

$$f(x_1,x_2|θ)=f(x_1|θ)×f(x_2|θ)$$

其中x1为第一次采样，x2为第二次采样，f为模型,$θ$为模型参数。其中$θ$未知，因此，我们定义似然L为：

$$\begin{array}{ll}
L(θ|x_1,x_2)    &= f(x_1,x_2|θ)     \\
                &=∏^2_{i=1}f(x_i|θ)
\end{array}$$

两边取自然对数，将乘号变为加号，便于求导：

$$\begin{array}{ll}
\ln L(\theta|x_1,x_2) &= \ln ∑^2_{i=1}f(x_i|θ) \\
                      &=∑^2_{i=1}\ln f(x_i|θ)
\end{array}$$

下面是平均对数似然：

$$\hat{\ell} = \frac{1}{2} L(θ|x_1,x_2)$$

最大似然估计的过程，就是赵一个合适的$θ$使得平均对数似然的值为最大。因此，可以得出下列公式。

$$\hat{θ}_{mle} = \arg \max_{θ ∈ Θ}\hat{\ell}(θ|x_1,x_2)$$

上述情况为二次采样，扩展到多次采样则有：

$$\hat{θ}_{mle}=\arg \max_{θ ∈ Θ}\hat{\ell}(θ|x_1,x_2,x_3,…,x_n)$$

我们定义M为模型（也就是之前公式中的f），表示抽到白球的概率为theta，而抽到红球的概率为$(1-θ)$，因此10次抽取抽到白球7次的概率可以表示为：

$$\begin{array}{ll}
P(x_1,x_2,…,x_{10}|M) &= P(x_1|M)×P(x_2|M)…×P(x_{10}|M)\\
                       &= θ^7(1-θ)^3
\end{array}$$

将其描述为平均似然可得：

$$\hat{\ell} = \frac{1}{10} \ln P(x_1,x_2,\dots,x_{10}|M) = \frac{1}{10} \ln (θ^7(1-θ)^3)$$

那么最大似然就是找到一个合适的$θ$，获得最大的平均似然。因此我们可以对平均似然的公式对$θ$求导，并令导数为0。

$$\hat{\ell}'(θ)  = 7θ^6(1-θ)^3 - 3θ^7(1-θ)^2 \\
\begin{array}{ll}
\hat{\ell}'(θ) = 0  &\implies & θ= 0.7 
\end{array}$$

## 求解过程

1. 写出似然函数
2. 如果无法直接求导的话，对似然函数取对数
3. 求导数
4. 求解模型中参数的最优值

# 信息论
## 信息熵
熵是信息的关键度量，通常指一条信息中需要传输或者存储一个信号的平均比特数。熵衡量了预测随机变量的不确定度，不确定性越大熵越大。

1. 热力学中的热熵是表示分子状态混乱程度的物理量。香农用信息熵的概念来描述信源的不确定度。
2. 两个独立符号所产生的不确定性应等于各自不确定性之和。
3. 在信源中，考虑的不是某一单个符号发生的不确定性，而是要考虑这个信源所有可能发生情况的平均不确定性。

对于当个符号，它的概率为p时，用这个公式衡量它的不确定性：
$$f(P)=\log \frac{1}{p} = - \log p$$

而信源的平均不确定性，称为信息熵，针对随机变量X，其信息熵的定义如下：

$$H(X) =  E[\log p_i] = - \sum p_i \log p_i$$

信息熵是信源编码中，压缩率的下限。当我们使用少于信息熵的信息量做编码，那么一定有信息的损失。

--------------

注意：

1. 当式中的对数的底为2时，信息熵的单位为比特。它底数为其它时，它对应的单位也不一样。
2. 信息熵是信息论中用于度量信息量的一个概念。一个系统越是有序，信息熵就越低；反之，一个系统越是混乱，信息熵就越高。所以，信息熵也可以说是系统有序化程度的一个度量。

## 条件熵
设X,Y是两个离散型随机变量，随机变量X给定的条件下随机变量Y的条件熵H（Y|X）表示在已知随机变量X的条件下随机变量Y的不确定性。

公式推导如下：
$$\begin{array}{ll}
H(Y|X)  &= ∑_{x ∈ X} p(x)H(Y|X = x) \\
        &= - ∑_{x ∈ X} p(x) ∑_{y ∈ Y}p(y|x)\log p(y|x) \\
        &= - ∑_{x ∈ X} ∑_{y ∈ Y} p(x,y) \log p(y|x)
\end{array}$$

-----------------------------

注意：

1. 这个条件熵，不是指在给定某个数（某个变量为某个值）的情况下，另一个变量的熵是多少，而是期望！因为条件熵中X也是一个变量，意思是在一个变量X的条件下（变量X的每个值都会取），另一个变量Y熵对X的期望。
2. 在计算信息增益的时候，经常需要用到条件熵。信息增益（information gain）是指期望信息或者信息熵的有效减少量（通常用“字节”衡量）。通常表示为：信息熵 - 条件熵；在决策树中就是根据信息增益选择特征的。

## 联合熵
联合熵是一集变量之间不确定的衡量手段。

$$H(X,Y) = \sum_{x ∈ X} \sum_{y ∈ Y} -p(x,y) \log(p(x,y))$$

联合熵和条件熵的关系是：

$$H(X,Y) = H(X) +H(Y|X) = H(Y) + H(X|Y) = H(Y,X)$$

## 自信息
自信息表示概率空间中与单一事件或离散变量的值相关的信息量的量度。

$$I(x) = -\log(p(x))$$

平均的自信息就是信息熵。

$$H(X) =  E[\log_2 (X)] = \sum -p(x) \log_2 (p(x))$$

## 互信息
两个随机变量的互信息，是变量间相互依赖性的量度，不同于相关系数，互信息不限于实值随机变量，其更加一般。

$$I(X;Y) = \sum\sum -p(x,y) \log(\frac{p(x)p(y)}{p(x,y)})$$

$$
\begin{array}{ll}
I(X;Y) & = H(X)-H(X|Y) \\
       & = H(Y)-H(Y|X) \\
       & = H(X)+H(Y)-H(X,Y) \\
       & = H(X,Y)-H(X|Y)-H(Y|X)
\end{array}
$$

其意义为，若我们想知道Y包含多少X的信息，在尚未得到 Y之前，我们的不确定性是 H(X)，得到Y后，不确定性是H(X|Y)。所以一旦得到Y后，我们消除了 H(X)-H(X|Y)的不确定量，这就是Y对X的信息量。

## KL散度(信息增益)
KL散度，又称为相对熵（relative entropy）、信息散度（information divergence）、信息增益（information gain）。

KL散度是两个概率分布P和Q差别非对称性的度量。KL散度用来度量基于Q的编码来编码来自P的样本平均所需的额外的位元数。典型情况下，P表示数据的真实分布，Q表述数据的模型分布。

$$D_{KL}(P||Q)= \sum_i P(i) \log \frac{P(i)}{Q(i)}$$

---------------------------------------

注意：

1. KL散度不是对称的，即：$D_{KL}(p||q) \neq D_{KL}(q||p)$
2. 相对熵的值为非负值。可以从一个很重要的不等式中推论出来，即吉布斯不等式：若$∑^n_{i=1}p_i = \sum^n_{i=1}q_i = 1$且$p_i,q_i ∈ (0,1]$，则有：$-∑^n_{i=1}p_i\log p_i ≤ -\sum^n_{i=1}p_i \log q_i$，等号成立当且仅当$p_i=q_i(∀i)$，在信息论和概率论中，它能应用在Fano不等式和讯号源编码定理的证明。

## 交叉熵
交叉熵衡量了在真实分布是P的情况的情况下，使用分布Q去编码数据，需要的平均比特。

$$H(p,q) = E_p [-\log q] = H(p) + D_{kl} (p|q)$$
$$H(p,q) = \sum -p(x)\log(q(x))$$

交叉熵与逻辑回归的关系如下：

逻辑回归中：

* $q_{y=1} = \hat{y} = g(wx)$
* $q_{y=0} = 1-\hat{y} = 1-g(wx)$

数据的真实分布中：

* $p_{y=1} = y$
* $p_{y=0} =  1-y$

因此，可以用交叉熵去衡量估计分布q与真实分布p的相似性，交叉熵越小那么越相似。

$$H(p,q) = \sum -p(x) \log q(x) = -y\log(\hat{y})-(1-y)\log(1-\hat{y})$$

因此，损失函数为，得到了和最大似然推导相同的结果：

$$\begin{array}{ll}
L(w) &= \frac{1}{N} \sum_{n=1}^N H(p_n,q_n) \\
     &= \frac{1}{N} \sum_{n=1}^N [- y\log(\hat{y})-(1-y)\log(1-\hat{y})] \\
     &= \frac{1}{N} \sum_{n=1}^N \log(1+\exp(-y_nw x_n))
\end{array}$$

# 链式求导法则

使$x=x(t),y=y(t)$在t处可微，并且有$z=f(x,y)$在点$(x(t),y(t))$处也可微，那么$z=f(x(t),y(t))$在t处就是可微的，且t处的微分为

$$\frac{dz}{dt}=\frac{\partial z}{\partial x}\frac{dx}{dt}+\frac{\partial z}{\partial y}\frac{dy}{dt}$$

使$x=x(u,v),y=y(u,v)$在点(u,v)处可微，并且有$z=f(x,y)$在点$(x(u,v),y(u,v))$处也可微，那么$z=f(x(u,v),y(u,v))$在(u,v)处就是可微的，且t处的微分为

$$\frac{\partial z}{\partial u}=\frac{\partial z}{\partial x}\frac{\partial x}{\partial u}+\frac{\partial z}{\partial y}\frac{\partial y}{\partial u}$$

$$\frac{\partial z}{\partial v}=\frac{\partial z}{\partial x}\frac{\partial x}{\partial v}+\frac{\partial z}{\partial y}\frac{\partial y}{\partial v}$$

# 矩阵、向量求导法则

## 矢量对元素求导
矢量对元素求导，相当于把矢量里的每一个元素对元素求导，结果的形式还是矢量的形式。


### 行向量对元素求导

设 $\mathbf{y}^T = \begin{bmatrix} y_1 & \ldots & y_n \end{bmatrix}$ 是$n$维行向量，$x$ 是元素。
则 $\frac{\partial\mathbf{y}^T}{\partial x} = \begin{bmatrix} \frac{\partial y_1}{\partial x} & \ldots & \frac{\partial y_n}{\partial x} \end{bmatrix}$

### 列向量对元素求导

设 $\mathbf{y} = \begin{bmatrix} y_1 \\ \vdots \\ y_n \end{bmatrix}$ 是$n$维列向量，$x$ 是元素。
则 $\frac{\partial\mathbf{y}}{\partial x} = \begin{bmatrix} \frac{\partial y_1}{\partial x} \\ \vdots \\ \frac{\partial y_n}{\partial x} \end{bmatrix}$

### 矩阵对元素求导

设 $\mathbf{Y} = \begin{bmatrix} y_{11} & \ldots & y_{1q} \\ \vdots & & \vdots \\ y_{p1} & \ldots & y_{pq} \end{bmatrix}$ 是$p × q$矩阵，$x$ 是元素。
则 $\frac{\partial\mathbf{Y}}{\partial x} = \begin{bmatrix} \frac{\partial y_{11} }{\partial x} & \ldots & \frac{\partial y_{1q} }{\partial x} \\ \vdots & & \vdots \\ \frac{\partial y_{p1} }{\partial x} & \ldots & \frac{\partial y_{pq} }{\partial x} \end{bmatrix}$

## 元素对矢量求导

元素对矢量求导，相当于元素和矢量里的每一个元素求一次导，结果的形式和矩阵的形式相同。

### 元素对行向量求导

设$y$ 是元素,$\mathbf{x}^T = \begin{bmatrix} x_1 & \ldots & x_n \end{bmatrix}$ 是$x$维行向量。
则 $\frac{\partial y}{\partial \mathbf{x}^T} = \begin{bmatrix} \frac{\partial y}{\partial x_1} & \ldots & \frac{\partial y}{\partial x_n} \end{bmatrix}$

### 元素对列向量求导

设$y$ 是元素,$\mathbf{x}^T = \begin{bmatrix} x_1 \\ \vdots \\ x_n \end{bmatrix}$ 是$x$维行向量。
则 $\frac{\partial y}{\partial \mathbf{x}^T} = \begin{bmatrix} \frac{\partial y}{\partial x_1} \\ \vdots \\ \frac{\partial y}{\partial x_n} \end{bmatrix}$

### 元素对矩阵求导

设$y$ 是元素， $\mathbf{X} = \begin{bmatrix} x_{11} & \ldots & x_{1q} \\ \vdots & & \vdots \\ x_{p1} & \ldots & x_{pq} \end{bmatrix}$ 是$p × q$矩阵。
则 $\frac{\partial y}{\partial \mathbf{X}} = \begin{bmatrix} \frac{\partial y }{\partial x_{11}} & \ldots & \frac{\partial y }{\partial x_{1q}} \\ \vdots & & \vdots \\ \frac{\partial y }{\partial x_{p1}} & \ldots & \frac{\partial y }{\partial x_{pq}} \end{bmatrix}$

## 矢量对矢量求导

矢量对矢量的求导要采用**逐层展开**的方式。**先将一个矢量看成一个元素，然后采用前面元素和矢量的运算法则**。

### 行向量对列向量求导

设 $\mathbf{y}^T = \begin{bmatrix} y_1 & \ldots & y_p \end{bmatrix}$ 是p维行向量，$\mathbf{x} = \begin{bmatrix} x_1 \\ \vdots \\ x_q \end{bmatrix}$ 是 q 维列向量。则
$\frac{\partial \mathbf{y}^T}{\partial \mathbf{x}} = \begin{bmatrix} \frac{\partial y_{1} }{\partial x_{1}} & \ldots & \frac{\partial y_{p} }{\partial x_{1}} \\ \vdots & & \vdots \\ \frac{\partial y_{1} }{\partial x_{q}} & \ldots & \frac{\partial y_{p} }{\partial x_{q}} \end{bmatrix}$

### 列向量对行向量求导

设 $\mathbf{y} = \begin{bmatrix} y_1 \\ \vdots \\ y_p \end{bmatrix}$ 是p维列向量，$\mathbf{x}^T = \begin{bmatrix} x_1 & \ldots & x_q \end{bmatrix}$ 是 q 维列向量。则
$\frac{\partial \mathbf{y}}{\partial \mathbf{x}^T} = \begin{bmatrix} \frac{\partial y_{1} }{\partial x_{1}} & \ldots & \frac{\partial y_{1} }{\partial x_{q}} \\ \vdots & & \vdots \\ \frac{\partial y_{p} }{\partial x_{1}} & \ldots & \frac{\partial y_{p} }{\partial x_{q}} \end{bmatrix}$

### 行向量对行向量求导

设 $\mathbf{y}^T = \begin{bmatrix} y_1 & \ldots & y_p \end{bmatrix}$ 是p维行向量，$\mathbf{x}^T = \begin{bmatrix} x_1 & \ldots & x_q \end{bmatrix}$ 是 q 维行向量。则
$\frac{\partial \mathbf{y}^T}{\partial \mathbf{x}^T} = \begin{bmatrix} \frac{\partial \mathbf{y}^T}{\partial x_{1}} & \ldots & \frac{\partial \mathbf{y}^T}{\partial x_{q}} \end{bmatrix}$

### 列向量对列向量求导

设 $\mathbf{y} = \begin{bmatrix} y_1 \\ \vdots \\ y_p \end{bmatrix}$ 是p维行向量，$\mathbf{x} = \begin{bmatrix} x_1 \\ \vdots \\ x_q \end{bmatrix}$ 是 q 维列向量。则
$\frac{\partial \mathbf{y}}{\partial \mathbf{x}} = \begin{bmatrix} \frac{\partial y_1}{\partial\mathbf{x}} \\ \vdots \\ \frac{\partial y_p}{\partial \mathbf{x}} \end{bmatrix}$

### 矩阵对行向量求导

设$\mathbf{Y}=\begin{bmatrix} y_{11} & … & y_{1n} \\ ⋮ & & ⋮ \\ y_{m1} & … & y_{mn} \end{bmatrix}$ 是$m × n$矩阵，$\mathbf{x}^T = \begin{bmatrix} x_1 & \dots & x_q \end{bmatrix}$是q维行向量，则$\frac{\partial \mathbf{Y}}{\partial \mathbf{x}^T} = \begin{bmatrix}\frac{\partial \mathbf{Y}}{\partial x_1} & \dots &\frac{\partial \mathbf{Y}}{\partial x_q} \end{bmatrix}$

### 矩阵对列向量求导

设$\mathbf{Y}=\begin{bmatrix} y_{11} & … & y_{1n} \\ ⋮ & & ⋮ \\ y_{m1} & … & y_{mn} \end{bmatrix}$ 是$m × n$矩阵。$\mathbf{x} = \begin{bmatrix} x_1 \\ \vdots \\ x_p \end{bmatrix}$p维维列向量，则$\frac{\partial \mathbf{Y}}{\partial \mathbf{x}} = \begin{bmatrix}\frac{\partial y_{11}}{\partial \mathbf{x}} & \dots &\frac{\partial y_{1n}}{\partial \mathbf{x}} \\ ⋮ &  & ⋮ \\\frac{\partial y_{m1}}{\partial \mathbf{x}} & \dots &\frac{\partial y{mn}}{\partial \mathbf{x}} \\ \end{bmatrix}$

### 行向量对矩阵求导

设$\mathbf{y}^T=\begin{bmatrix} y_{1} & … & y_{n} \end{bmatrix}$ 是$n$维行向量。$\mathbf{X} = \begin{bmatrix} x_{11} & … & x_{1q}\\ \vdots & & \vdots \\ x_{p1} & … & x_{pq} \end{bmatrix}$ 是$p × q$矩阵，则
$\frac{\partial \mathbf{y}^T}{\partial \mathbf{X}} = 
\begin{bmatrix}
\frac{\partial \mathbf{y}^T}{\partial x{11}} & \dots &\frac{\partial \mathbf{y}^T}{\partial x{1q}} \\
 ⋮ &  & ⋮ \\
\frac{\partial \mathbf{y}^T}{\partial x{p1}} & \dots &\frac{\partial \mathbf{y}^T}{\partial x{pq}}
\end{bmatrix}$

### 列向量对矩阵求导

设$\mathbf{y}=\begin{bmatrix} y_{1} \\ ⋮ \\ y_{m} \end{bmatrix}$ 是$m$维列向量。$\mathbf{X} = \begin{bmatrix} x_{11} & … & x_{1q}\\ \vdots & & \vdots \\ x_{p1} & … & x_{pq} \end{bmatrix}$ 是$p × q$矩阵，则
$\frac{\partial \mathbf{y}}{\partial \mathbf{X}} = 
\begin{bmatrix}
\frac{\partial \mathbf{y_1}}{\partial \mathbf{X}} \\ ⋮ \\ \frac{\partial \mathbf{y_m}}{\partial \mathbf{X}}
\end{bmatrix}$

### 矩阵对矩阵求导

设
$\mathbf{Y} = \begin{bmatrix} y_{11} & … & y_{1n}\\ \vdots & & \vdots \\ y_{m1} & … & y_{mn} \end{bmatrix} 
= \begin{bmatrix} \mathbf{y_1}^T \\ ⋮ \\ \mathbf{y_m}^T \end{bmatrix}$ 是$m × n$矩阵。
$\mathbf{X} = \begin{bmatrix} x_{11} & … & x_{1q}\\ \vdots & & \vdots \\ x_{p1} & … & x_{pq} \end{bmatrix}
= \begin{bmatrix} \mathbf{x_1} & … & \mathbf{x_q} \end{bmatrix}$ 是$p × q$矩阵，则
$\frac{\partial \mathbf{Y}}{\partial \mathbf{X}} = 
\begin{bmatrix} \frac{\partial \mathbf{y_1}^T}{\partial \mathbf{X}} \\ ⋮ \\ \frac{\partial \mathbf{y_m}^T}{\partial \mathbf{X}} \end{bmatrix} = 
\begin{bmatrix}
\frac{\partial \mathbf{y_1}^T}{\partial \mathbf{x_1}} & \dots &\frac{\partial \mathbf{y_1}^T}{\partial \mathbf{x_q}} \\
 ⋮ &  & ⋮ \\
\frac{\partial \mathbf{y_m}^T}{\partial \mathbf{x_1}} & \dots &\frac{\partial \mathbf{y_m}^T}{\partial \mathbf{x_q}} \\
\end{bmatrix}$

### 常用矩阵求导公式

$$\frac{∂β^TX}{∂X} = β$$
$$\frac{∂X^TX}{∂X} = X$$
$$\frac{∂X^TAX}{∂X} = (A+A^T)X$$

$$tr(a) = a$$
$$tr(AB) = tr(BA)$$
$$tr(ABC) = tr(CAB) = tr(BCA)$$

$$\frac{∂tr(AB)}{∂A} = B^T$$
$$tr(A) = tr(A^T)$$
$$\frac{tr(ABA^TC)}{∂A} = CAB+C^TAB^T$$
