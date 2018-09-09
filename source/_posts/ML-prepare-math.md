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

机器学习预备知识。

<!-- more -->

<!-- # 线性代数 -->

<!-- ## 矩阵的乘积 -->

<!-- ## 矩阵的秩 -->

<!-- ## 矩阵的逆 -->

<!-- ## 矩阵的 -->

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