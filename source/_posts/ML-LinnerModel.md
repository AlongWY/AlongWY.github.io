---
title: 机器学习-线性模型
tags:
  - Machine Learning
mathjax: false
date: 2018-09-21 18:18:46
categories:
  - 机器学习
---

# 线性模型

由泰勒公式展开我们可以知道可以用高阶多项式函数来逼近任意函数。

<!-- more -->

于是我们可以有

$$
\begin{bmatrix}
1 & x^1 & x^2 & x^3 & ⋮ & x^n
\end{bmatrix}
\cdot
\begin{bmatrix}
f \\ f^{(1)} \\ f^{(2)} \\ f^{(3)} \\ … \\ f^{(n)}
\end{bmatrix}
 = \hat{Y}
$$

# 线性模型的推导

我们当然希望我们得到的线性模型$\hat{Y} = X \hat{W}$，通过计算得到的$\hat{Y}$与实际的$Y$比较相近，那么我们可以设置一个量来表示$\hat{Y}$和$Y$的相近程度。

## 无正则项

$$E_{\hat{W}} = \frac{1}{length(X)} ∑(y - x \hat{w})^2$$
$$E_{\hat{W}} = \frac{1}{length(X)} (Y - X \hat{W})^T(Y - X \hat{W})$$
$$\frac{∂E_{\hat{W}}}{∂\hat{W}} = \frac{1}{length(X)} 2X^T(X\hat{W} - Y)$$

$$\frac{∂E_{\hat{W}}}{∂\hat{W}} = 0 → \hat{W} = (X^TX)^{-1}X^TY$$



## 加入正则项

$$E_{\hat{W}} = \frac{1}{length(X)} (∑(y - x \hat{w})^2 + λ∑\hat{w}^2)$$
$$E_{\hat{W}} = \frac{1}{length(X)} ((Y - X \hat{W})^T(Y - X \hat{W}) + \hat{W}^T\hat{W})$$
$$\frac{∂E_{\hat{W}}}{∂\hat{W}} = \frac{1}{length(X)} (2X^T(X\hat{W} - Y) + 2λ\hat{W})$$

$$\frac{∂E_{\hat{W}}}{∂\hat{W}} = 0 → \hat{W} = (X^TX + λ)^{-1}X^TY$$


# 梯度下降
## 梯度下降

$$\hat{W} = \hat{W} - α\frac{∂E_{\hat{W}}}{∂\hat{W}}$$

随机梯度下降是梯度下降的一种特例，即使用数据集中的某一部分数据进行训练，可以大大减少内存的使用。

## 共轭梯度下降

TODO

# 一些优化方案

## Momentum

$$V = Momentum * V - α\frac{∂E_{\hat{W}}}{∂\hat{W}}$$
$$\hat{W} = \hat{W} + V$$

[完整代码](LinnerModel.jl)