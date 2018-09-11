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

<!-- more -->

# 最大似然估计
最大似然估计是一种“模型已定，参数未知”的方法，一些复杂的条件下，是很难通过直观的方式获得答案的，这时候理论分析就尤为重要了，这也是学者们为何要提出最大似然估计的原因。

> 假设一个袋子装有白球与红球，比例未知，现在抽取10次（每次抽完都放回，保证事件独立性），假设抽到了7次白球和3次红球，在此数据样本条件下，可以采用最大似然估计法求解袋子中白球的比例。

当然，这种数据情况下很明显，白球的比例是70%，但如何通过理论的方法得到这个答案呢？我们可以定义从袋子中抽取白球和红球的概率如下：

$$f(x_1,x_2|θ)=f(x_1|θ)×f(x_2|θ)$$

其中x1为第一次采样，x2为第二次采样，f为模型,$θ$为模型参数。其中$θ$未知，因此，我们定义似然L为：

$$L(θ|x_1,x_2)=f(x_1,x_2|θ)=∏^2_{i=1}f(x_i|θ)$$

两边取自然对数，将乘号变为加号，便于求导：

$$\ln L(\theta|x_1,x_2)=\ln ∑^2_{i=1}f(x_i|θ)=∑^2_{i=1}\ln f(x_i|θ)$$

下面是平均对数似然：

$$\hat{\ell} = \frac{1}{2} L(θ|x_1,x_2)$$

最大似然估计的过程，就是赵一个合适的$θ$使得平均对数似然的值为最大。因此，可以得出下列公式。

$$\hat{θ}_{mle} = \arg \max_{θ ∈ Θ}\hat{\ell}(θ|x_1,x_2)$$

上述情况为二次采样，扩展到多次采样则有：

$$\hat{θ}_{mle}=\arg \max_{θ ∈ Θ}\hat{\ell}(θ|x_1,x_2,x_3,…,x_n)$$

我们定义M为模型（也就是之前公式中的f），表示抽到白球的概率为theta，而抽到红球的概率为$(1-θ)$，因此10次抽取抽到白球7次的概率可以表示为：

$$P(x_1,x_2,…,x_{10}|M)=P(x_1|M)×P(x_2|M)…×P(x_{10}|M)=θ^7(1-θ)^3$$

将其描述为平均似然可得：

$$\hat{\ell} = \frac{1}{10} \ln P(x_1,x_2,\dots,x_{10}|M) = \frac{1}{10} \ln (θ^7(1-θ)^3)$$

那么最大似然就是找到一个合适的$θ$，获得最大的平均似然。因此我们可以对平均似然的公式对$θ$求导，并令导数为0。

$$\hat{\ell}'(θ) = 7θ^6(1-θ)^3 - 3θ^7(1-θ)^2 = 0 \implies θ = 0.7$$

## 求解过程

1. 写出似然函数
2. 如果无法直接求导的话，对似然函数取对数
3. 求导数
4. 求解模型中参数的最优值

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