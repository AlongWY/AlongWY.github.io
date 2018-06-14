---
title: 为什么是"-INT_MAX-1"
tags:
  - c/c++
  - asm
date: 2017-09-14 08:03:22
categories: 研习
---
# 序
C语言中的INT_MIN的定义与我们的直觉是不同的，在Linux中的 `limits.h` 头文件中有如下定义：
```c
/* Minimum and maximum values a `signed int' can hold.  */
#  define INT_MIN	(-INT_MAX - 1)
#  define INT_MAX	2147483647
```
<!-- more --> 
*Linux头文件目录: /usr/include/limits.h*

# 疑惑
为什么INT_MAX被定义成 `-INT_MAX - 1` 呢？
为什么不直接定义成 `-2147483648` 呢？

# 测试
## 第一次失败的尝试
考虑如下代码：
```c
/*------------WHY IS "-INT_MAX-1"-----------------
 * DATA: 2017-9-14
 * BY:   Alongwy
 * File: test.c
 * TAG:  v0.1
 * ----------------------------------------------- */
#include<stdio.h>
#define INT_MIN (-2147483648)
// 我们反其道而行之

int main(){
    int a = INT_MIN;
    printf("%d\n",a);
    return 0;
}
```

## 编译运行
在终端中输入如下命令进行编译并运行：
```bash
gcc -o test test.c && ./test
```
发现输出如下：
```
-2147483648
```
编译时没有错误，运行时也没有发现错误？？？

经过查阅GCC的编译命令：

|      选项      |                                  作用                                                 |
|----------------|---------------------------------------------------------------------------------------|
|-ansi           |支持符合ANSI标准的C程序                                                                |
|-pedantic       |允许发出ANSI C标准所列的全部警告信息                                                   |
|-pedantic-error |允许发出ANSI C标准所列的全部错误信息                                                   |
|-Wall           |允许发出gcc提供的所有有用的报警信息                                                    |
|-Werror         |把所有的告警信息转化为错误信息，并在告警发生时终止编译过程                             |
|-O              |主要进行线程跳转（Thread Jump）和延迟退栈（Deferred Stack Pops）两种优化               |
|-O2             |除了完成所有“-O1”级别的优化之外，同时还要进行一些额外的调整工作，如处理器指令调度等  |
|-O3             |还包括循环展开和其他一些与处理器特性相关的优化工作                                     |
|-static         |指示链接器构建一个完全链接的可执行程序，即链接静态库而不链接动态库                     |
|-fPIC           |指示链接器创建一个共享的目标文件，即so文件                                             |
|-shared         |生成动态库，一般和上面的-fPIC一起使用                                                  |

我们使用 `-Wall` 选项再次编译，然而.......编译的结果仍然是没有错误！！！

## 修改代码再次编译
稍微修改一下代码：

```
/*------------WHY IS "-INT_MAX-1"-----------------
 * DATA: 2017-9-14
 * BY:   Alongwy
 * File: test.c
 * TAG:  v0.2
 * ----------------------------------------------- */
#include<stdio.h>
#define INT_MIN (-2147483648)

int main(){
    int a = INT_MIN - 1;
    // 直接赋值似乎没有发生错误，那么我们进行一次运算试试
    printf("%d\n",a);
    return 0;
}
```
再次编译 **GCC** 给出了错误提示：
```bash
test.c: 在函数‘main’中:
test.c:7:17: 警告：隐式常量转换溢出 [-Woverflow]
 #define INT_MIN (-2147483648)
                 ^
test.c:10:13: 附注：in expansion of macro ‘INT_MIN’
     int a = INT_MIN - 1;
             ^~~~~~~
```
答案似乎还不够显然。

## 进一步探索
我们看一下INT_MIN的字节数：
```c
/*------------WHY IS "-INT_MAX-1"-----------------
 * DATA: 2017-9-14
 * BY:   Alongwy
 * File: test.c
 * TAG:  v0.3
 * ----------------------------------------------- */
#include<stdio.h>
#define INT_MIN (-2147483648)

int main(){
    printf("sizeof(int):    %ld\n",sizeof(int));
    printf("sizeof(INT_MIN):%ld\n",sizeof(INT_MIN));
    return 0;
}
```
得到的结果如下：
```bash
2147483647
sizeof(int):    4
sizeof(INT_MIN):8
```

答案已经很明了了，我们的定义使得INT_MIN成为了一个long型，而不是一个int型，单单打印不会出现什么问题，进行运算的时候就会出现问题了。

# 原因解释
我们先来查看C语言标准文档是怎么解释常量的，ISO/ANSI C99 和C11对于这里的描述是相同的。我们摘录下来：

**"An integer constant begins with a digit, but has no period or exponent part. It may have a prefix that specifies its base and a suffix that specifies its type."**

这句话的大概意思是“一个常量起始于一个数字，但是不包含小数点或指数的部分。并且可能有一个用于指定数字基底的前缀和一个指定类型的后缀。”
*前缀指的是 `0x` 这种，后缀指的是 `10u` 这种。*

我们假设INT_MIN定义为-2147483648，这里的-2147483648其实是由一个一元运算符-和一个常量 `2147483648` 组成，编译器怎么解释 `2147483648` 呢？编译器对于这么一个数字，按照定义好的变量顺序一一匹配其类型，这个定义好的顺序在文档里可以查到，C99和C11是一样的，另外C++11也是相同的。

显然 `2147483648` 已经超过了 `INT_MAX` 了，所以编译器会把它当作是 `long int` 型了。按照C语言的表达式求值规则，原本可能使用的x < INT_MIN这样的表达式，x被转换为long int类型再进行表达式求值了，便有可能会出现一些预料之外的结果，而按照 `-2147483647-1` 这样的定义，不会被认为是 `long int` 类型的，这个小技巧使得我们获得了正确的类型和正确的值。

## 补充
0x80000000也不行，因为c编译器对八进制或者16进制常数会默认按照 `int`、 `unsigned int` 、`long` 、`unsigned long` （c99多一个 `long long`）适配，`int` 无法完全表示该值，会“提升”为 `unsigned int` ，从而引发问题。

## 反汇编
// TODO
