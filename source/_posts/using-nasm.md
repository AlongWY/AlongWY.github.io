---
title: NASM的安装与使用
tags:
  - Asm
  - Nasm
date: 2017-09-03 20:22:52
categories: 教程
---

# NASM 简介
NASM 是一个为可移植性与模块化而设计的一个 80x86 的汇编器。

<!-- more -->

它支持相当多的目标文件格式：

* ELF
* COFF
* Linux
* NetBSD/FreeBSD
* 纯二进制文件
* 微软16位的"OBJ"和"Win32"

# NASM的安装

## Windows/DOS 下的安装

1. 获取安装包[nasmXXX.zip](http://www.nasm.us/pub/nasm/releasebuilds/)

  该包中会包含有四个可执行文件：
  - NASM可执行文件"nasm.exe"和"nasmw.exe"
  - NDISASM可执行文件"ndisasm.exe"和"ndisasmw.exe"

2. NASM运行时需要的唯一文件就是它自己的可执行文件，所以可以拷贝"nasm.exe"和"nasmw.exe"的其中一个到你自己的路径下，或者把nasm的路径加到你的"PATH"环境变量中去。

**文件名以"w"结尾的是"Win32"可执行格式，是运行在"Windows 95/Windows NT"的Intel处理器上的，另外的是16位的"DOS"可执行文件。**

## Linux 下安装

1. 下载[源代码(nasm-XXX.tar.gz)](http://www.nasm.us/pub/nasm/stable/)
2. 解压源代码：
    ```bash
    tar zxvf nasm-XXX.tar.gz     #解压
    cd nasm-XXX                  #进入源码目录
    ```
3. 安装
    ```bash
    ./configure                  #生成makefile
    make                         #编译
    sudo make install            #安装
    ```

# NASM的使用

要汇编一个文件,你可以以下面的格式执行一个命令:`nasm -f <format> <filename> [-o <output>]`

|命令参数 |             作用          |
|---------|---------------------------|
|    -o   |  指定输出文件的文件名     |
|    -f   |  指定输出文件的格式       |
|    -l   |  产生列表文件             |
|    -M   |  产生 Makefile 依赖关系  |
|    -F   |  选择一个调试格式         |
|    -g   |  使调试信息有效           |
|    -E   |  把错误信息输入到文件     |
|    -s   |  把错误信息输出到"stdout"|
|    -i   |  包含文件搜索路径         |
|    -p   |  预包含一个文件           |
|    -d   |  预定义一个宏             |
|    -u   |  取消一个宏定义           |
|    -e   |  仅预处理                 |
|    -a   |  不需要预处理             |
|    -On  |  指定多遍优化             |
|    -t   |  使用 TASM 兼容模式      |
|    -w   |  使汇编警告信息有效或无效 |


# NASM指令表

## 操作指令
|     指令          |                                          作用                                             |
|------------------|-------------------------------------------------------------------------------------------|
|MOV  dst, src     |                 把src 的内容 复制到 dst中，操作字长由参数字长决定                                |
|push              |把参数入栈                                                                                   |
|pop               |从栈顶弹出数据，存入给定参数中                                                                  |
|PUSHA             |把AX,CX,DX,BX,SP,BP,SI,DI依次压入堆栈.（在不同模式下面，对应不同的寄存器，如32bit模式，对应32位寄存器）|
|POPA              |把DI,SI,BP,SP,BX,DX,CX,AX依次弹出堆栈. （同上）                                                |
|cmp   arg1, arg2  |   比较两个参数的大小(arg1 - arg2), 根据结果修改标志位                                            |
|xchg   arg1, arg2 |  交换两个参数的内容                                                                            |

## 算术指令
|     指令          |          作用           |
|------------------|-------------------------|
|add   dst,  src    |  加法，dst = dst + src|
|sub   arg1, arg2  |  减法，arg1 = arg1 - arg2|

## 字符串指令
|     指令          |                                          作用                                             |
|------------------|-------------------------------------------------------------------------------------------|
|DS:SI             |源串段寄存器 :源串变址.                                                                       |
|ES:DI             |目标串段寄存器:目标串变址                                                                      |
|CX                |重复次数计数器.                                                                              |
|AL/AX             |扫描值                                                                                      |
|SCASB             |串扫描.  把AL的内容与目标串作比较(AL -  [ES:DI]),比较结果反映在标志位.                             |
|LODS              |装入串. 把源串中的元素(字或字节)逐一装入AL或AX,EAX中. ( LODSB 传送字符. LODSW 传送字. LODSD 传送双字. ) |
|STOS              |保存串.  LODS的逆过程。把AL或AX或EAX中的数据装入目标串中。(STOSB, STOSW, STOSD)                    |
|REP               |当CX/ECX<>0时重复                                                                            |
|REPE/REPZ         | 当ZF=1或比较结果相等,且CX/ECX<>0时重复                                                         |
|REPNE/REPNZ       | 当ZF=0或比较结果不相等,且CX/ECX<>0时重复.                                                      |
|REPC              |当CF=1且CX/ECX<>0时重复.                                                                      |
|REPNC             |当CF=0且CX/ECX<>0时重复                                                                       |

## 程序转移指令

### 无条件转移指令

|     指令          |          作用           |
|------------------|-------------------------|
|JMP               |无条件转移指令              |
|CALL              |过程调用                   |
|RET/RETF          |过程返回                   | 

### 条件转移指令

|     指令          |          作用           |
|------------------|-------------------------|
|JA/JNBE           |大于时转移                |
|JAE/JNB           |大于或等于转移             |
|JB/JNAE           |小于转移                   |
|JBE/JNA           |小于或等于转移              |

以上四条,测试无符号整数运算的结果(标志C和Z)

|     指令          |          作用           |
|------------------|-------------------------|
|JG/JNLE           |大于转移                  |
|JGE/JNL           |大于或等于转移             |
|JL/JNGE           |小于转移                   |
|JLE/JNG           |小于或等于转移               |

以上四条,测试带符号整数运算的结果(标志S,O和Z)

|   指令   |          作用           |
|---------|-------------------------|
|JE/JZ    |等于转移                  |
|JNE/JNZ  |不等于时转移               |
|JC       |有进位时转移               |
|JNC      |无进位时转移               |
|JNO      |不溢出时转移               |
|JNP/JPO  |奇偶性为奇数时转移          |
|JNS      |符号位为 "0" 时转移        |
|JO       |溢出转移                  |
|JP/JPE   |奇偶性为偶数时转移          |
|JS       |符号位为 "1" 时转移         |

### 循环控制指令(短转移)

|     指令          |          作用           |
|------------------|-------------------------|
|LOOP              |CX不为零时循环            |
|LOOPE/LOOPZ       |CX不为零且标志Z=1时循环    |
|LOOPNE/LOOPNZ     | CX不为零且标志Z=0时循环   |
|JCXZ              |CX为零时转移              |
|JECXZ             |ECX为零时转移             |

## 中断指令

|     指令          |          作用           |
|------------------|-------------------------|
|INT              |中断指令                   |
|INTO             |溢出中断                   |
|IRET             |中断返回                   |

## 处理机控制指令

|  指令   |          作用           |
|--------|-------------------------|
|NOP     |无操                    |
|HLT     |停机                    |
|WAIT    |等待                    |
|ESC     |换码                    |
|LOCK    |封锁                    |

## 标志处理指令

|  指令   |          作用           |
|--------|-------------------------|
|CLC     |进位位置0指令             |
|CMC     |进位位求反指令            |
|STC     |进位位置为1指令           |
|CLD     |方向标志置1指令           |
|STD     |方向标志位置1指令         |
|CLI     |中断标志置0指令           |
|STI     |中断标志置1指令           |

## 状态寄存器

|标志位（外语缩写）|标志位名称及外语全称    |          =1         |       =0            |
|-----------------|----------------------------|---------------------|---------------------|
|       CF        |进位标志/Carry Flag      | CY/Carry/进位      | NC/No Carry/无进位 |
|       PF        |奇偶标志/Parity Flag     | PE/Parity Even/偶 | PO/Parity Odd/奇  |
|       AF        |辅助进位标志/Auxiliary Carry Flag|AC/Auxiliary Carry/进位|NA/No Auxiliary Carry/无进位|
|       ZF        |零标志/Zero Flag          |ZR/Zero/等于零       |NZ/Not Zero/不等于零|
|       SF        |符号标志/Sign Flag        |NG/Negative/负      |PL/Positive/非负   |
|       TF        |跟踪标志/Trace Flag    |                       |                      |
|       IF        |中断标志/Interrupt Flag| EI/Enable Interrupt/允许|DI/Disable Interrupt/禁止|
|       DF        |方向标志/Direction Flag | DN/Down/减少       |   UP/增加          |
|       OF        |溢出标志/Overflow Flag | OV/Overflow/溢出  |  NV/Not Overflow/未溢出|

