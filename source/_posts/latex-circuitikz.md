---
title: Latex-Circuitikz绘制电路图
tags:
  - Latex
date: 2017-10-13 18:18:03
categories: 教程
---
# Latex 和 Circuitikz 简介
Circuitikz 是Latex的一个宏包,可以非常方便的绘制电路图， Circuitikz 基于 Tikz 宏包，为我们提供了更多的电学图形，供我们插入到图形中去。

<!-- more --> 
# 使用 Circuitikz
## 引入 Circuitikz 包
```latex
\documentclass{ctexart}

\usepackage{tikz}
\usepackage{circuitikz}

\begin{document}
% 一些代码
\end{document}
```
## 使用Circuitikz
```latex
\begin{circuitikz}
      \draw (0,0)
      to[V,v=$U_q$] (0,2) % 电压源
      to[short] (2,2)
      to[R=$R_1$] (2,0) % 电阻
      to[short] (0,0);
\end{circuitikz}
```

## 分析代码
```latex
\begin{circuitikz}
    % 绘制命令
\end{circuitikz}
```
这两行代码是创建了 Circuitikz 环境，之后我们才能在这个环境中绘制图形。

```latex
\draw (0,0)
      to[V,v=$U_q$] (0,2) % 电压源
```
这段代码是说在(0,0)到(0,2)之间绘制一条直线，并且在中间加上一个电压源的图形。

其余的部分也是一样，值得注意的是，绘制时总是以 `\draw` 开始，以`;`结束，在中间别的位置开始绘制不需要重新使用`\draw`命令，只需要这样使用
```latex
\draw (0,0)
      to[V,v=$U_q$] (0,2) % 电压源
      (0,0) to [short] (2,0);
```

## 绘制标准
在使用过程中可能会需要调整绘制方案，使用不同的绘制标准所得到的图形是有差异的。

```latex
\begin{circuitikz}[american] % 修改绘制国家标准
    % 绘制命令
\end{circuitikz}
```

## 调整元件符号位置
在绘制过程中，可能需要调整所显示文字的方位，选择在电路元件的内侧还是外侧，电路的参考方向如何：

```latex
\begin{circuitikz}
      \draw (0,0)
      to[V,v<=$U_1$] (0,2) % 电压源
      to[V,v>=$U_2$] (2,2)
      to[R^=$R_1$] (2,0) % 电阻
      to[R_=$R_2$] (0,0);
\end{circuitikz}
```

## 显示元件端电压
电路元件外面还可以使用`v`(注意是小`v`)来显示元件的端电压:
```latex
\begin{circuitikz}
      \draw (0,0)
      to[R=$R_1$,v<=$U_1$] (0,2); % 电阻
\end{circuitikz}
```
## 标识中不能出现等号
```latex
\begin{circuitikz}
      \draw (0,0)
      to[R=$R_1=2\Omega$,v<=$U_1$] (0,2); % 电阻
\end{circuitikz}
```
这段代码是无法通过编译的，你可以看到在`\Omega`之前有一个`=`这会出现问题，Latex会把`=`前面的部分当作一个元件，导致出现错误，暂时没有找到解决方案，可以考虑用`:`或者`-`代替。

# 总结
* Circuitikz为我们提供了绘制电路图的环境
* 所用的命令方式与Tikz极为相似
* 几乎所有种类的电路元件图



