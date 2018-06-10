---
title: NASM 教程 -- 从HelloWorld说开去
tags:
  - Asm
  - Nasm
date: 2017-09-04 20:00:01
categories: 学习
---

# 题外话
我想大多数人学习编程的时候都是从一门高级语言开始的，比如C，比如Java，但是当我们需要更进一步，去了解操作系统，了解CPU，这些知识就不够了，所以我们还是需要简单学一下汇编的。

所有的代码可以在[代码仓库](https://github.com/AlongWY/nasm-learn)中找到。

<!-- more -->
# 运行环境
* Archlinux/Manjaro x86_64
* NASM

# 第一个汇编程序
我们将字符串保存到msg中，调用**SYS_WRITE**（操作数为4）将其写入到标准输出（stdout估计大家都很熟悉吧）里面去，而后我们调用**SYS_EXIT**（操作数为1）使得程序正常退出，就和C语言中的exit函数一样，它也只接收一个参数。

## 中断简介
中断是指计算机运行过程中，出现某些意外情况需主机干预时，机器能自动停止正在运行的程序并转入处理新情况的程序，处理完毕后又返回原被暂停的程序继续运行。
中断又分为硬件中断和软件中断两种：
- 硬件中断：使用硬件中断发出信号，表示硬件层发生的事件（比如I/O端口接收到输入信号时）
- 软件中断：由软件发出的把控制交给另一个程序的信号，另一个程序执行完后返回状态寄存器

接下来我们就要用到由Linux内核为我们提供的两个中断:
**SYS_EXIT**：

| 寄存器 |    参数说明    |
|--------|---------------|
|  EBX  |     返回值     |

**SYS_WRITE**：

| 寄存器 |    参数说明    |
|--------|---------------|
|  EDX  |  字符串长度    |
|  ECX  |  数据的内存地址|
|  EBX  |  写入位置      |

## 代码
```asm
;----------------------Hello World Program--------------------------
; by alongwy
; 编译： nasm -f elf helloworld.asm
; 链接： ld -m elf_i386 helloworld.o -o helloworld
;        64位系统需要 elf_i386 选项
; 运行： ./helloworld
;-------------------------------------------------------------------

SECTION .data                            ; 数据段
    msg     db  'Hello World!', 0Ah      ; 创建字符串，0Ah是换行符

SECTION .text                            ; 代码段
global  _start
_start:
    mov     edx, 13     ; 字符串长度
    mov     ecx, msg    ; 字符串地址
    mov     ebx, 1      ; 写入到标准输出
    mov     eax, 4      ; SYS_WRITE 中断操作数 4
    int     80h         ; 调用系统中断

    mov     ebx, 0      ; 返回值
    mov     eax, 1      ; SYS_EXIT 中断操作数 1
    int     80h         ; 调用系统中断
```

## 编译运行
在命令行下输入如下命令编译并运行它：
```bash
nasm -f elf helloworld.asm
ld -m elf_i386 helloworld.o -o helloworld
./helloworld
```

## 一些可能让你感到疑惑的地方

1. .text 部分是处理器开始执行代码的地方,指定了后续编译出来的内容放在代码段【可执行】,是NASM编译器的关键词。
2. .global关键字用来让一个符号对链接器可见，可以供其他链接对象模块使用;告诉编译器后续跟的是一个全局可见的名字【可能是变量，也可以是函数名】
3. .global _start 让 _start 符号成为可见的标识符，这样链接器就知道跳转到程序中的什么地方并开始执行。
4. _start是一个函数的起始地址，也是编译、链接后程序的起始地址。由于程序是通过加载器来加载的，必须要找到 _start名字的函数，因此_start必须定义成全局的，以便存在于编译后的全局符合表中，供其它程序【如加载器】寻找到。linux寻找这个 _start 标签作为程序的默认进入点。

# 动态解析字符串长度
上述代码中字符串的长度是写死的，字符串如果变动的话，这个长度就不对了，下面改造一下我们的程序，使得它自动计算字符串的长度。

## 状态寄存器简介
状态寄存器又被称为标志寄存器。
PSW(Program Status Word)程序状态字寄存器,是一个16位寄存器,由条件码标志(flag)和控制标志构成,跳转指令或者其它的一些指令会修改或者读取其中的值来判定操作后的状态。

下面介绍状态寄存器的内部情况：

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

## 代码
```asm
;----------Hello World Program(Calculating string length)-----------
; by alongwy
; 编译： nasm -f elf helloworld-len.asm
; 链接： ld -m elf_i386 helloworld-len.o -o helloworld-len
;        64位系统需要 elf_i386 选项
; 运行： ./helloworld-len
;-------------------------------------------------------------------

SECTION .data                            ; 数据段
    msg     db  'Hello World!', 0Ah     ; 创建字符串，0Ah是换行符

SECTION .text                            ; 代码段
global  _start
_start:
    mov     ebx,msg          ; 将字符串初始地址存入EBX寄存器
    mov     eax,ebx          ; 同上

nextchar:                    ; 计算字符串长度
    cmp     byte [eax], 0    ; 将eax储存地址指向的数据与0进行比对（字符串以0结尾）
    jz      finished         ; 若标志位被设置为0，则跳转至finished
    inc     eax              ; 递加eax
    jmp     nextchar         ; 跳转至nextchar

finished:
    sub     eax, ebx         ; eax = eax - ebx
    mov     edx, eax         ; eax中存储的即为字符串
    mov     ecx, msg         ; 字符串地址
    mov     ebx, 1           ; 写入到标准输出
    mov     eax, 4           ; SYS_WRITE 中断操作数 4
    int     80h              ; 调用系统中断

    mov     ebx, 0           ; 返回值
    mov     eax, 1           ; SYS_EXIT 中断操作数 1
    int     80h              ; 调用系统中断
```

# 函数
显然，我们上面写的程序可以自动判断字符串的长度，而后返回，就像C语言中我们会做的那样，我们也可以把这段代码封装成一个函数，而后去调用它。

## CALL和RET
你可能会想到使用JMP来达到我们的目标，然而这会带来一个问题，那就是这个函数必须不停的修改，否则无法返回到调用它的地方，幸运的是，机器中给我们提供了CALL和RET解决了这个问题。
使用CALL，就会跳转到函数的部分执行，使用RET就会回到调用CALL的地方。
CALL和RET的功能是由栈来完成的，当你调用CALL的时候，CPU会讲当前的地址入栈，而后跳转到函数的位置开始执行，调用RET的时候，CPU从栈顶取出之前保存的地址，而后返回。所以 **在你使用栈的时候，一定要小心。**

## 代码
```asm
;--------------------Hello World Program(func)----------------------
; by alongwy
; 编译： nasm -f elf helloworld-func.asm
; 链接： ld -m elf_i386 helloworld-func.o -o helloworld-func
;        64位系统需要 elf_i386 选项
; 运行： ./helloworld-func
;-------------------------------------------------------------------

SECTION .data                            ; 数据段
    msg     db  'Hello World!', 0Ah     ; 创建字符串，0Ah是换行符

SECTION .text                            ; 代码段
global  _start
_start:
    mov     eax, msg         ; 将字符串初始地址存入EAX寄存器
    call    strlen           ; 调用我们编写的函数
    
    mov     edx, eax         ; 我们的函数将结果存入EAX，所以这里把它的值传到EDX中去
    mov     ecx, msg         ; 字符串地址
    mov     ebx, 1           ; 写入到标准输出
    mov     eax, 4           ; SYS_WRITE 中断操作数 4
    int     80h              ; 调用系统中断

    mov     ebx, 0           ; 返回值
    mov     eax, 1           ; SYS_EXIT 中断操作数 1
    int     80h              ; 调用系统中断
    
    
strlen:                      ; 这是我们编写的第一个函数的声明
    push    ebx              ; 接下来会用到EBX，所以将EBX中的值入栈，之后我们再把它取出来
    mov     ebx, eax         ; 将EAX中的值存入EBX
    
nextchar:                    ; 计算字符串长度
    cmp     byte [eax], 0    ; 将eax储存地址指向的数据与0进行比对（字符串以0结尾）
    jz      finished         ; 若标志位被设置为0，则跳转至finished
    inc     eax              ; 递加eax
    jmp     nextchar         ; 跳转至nextchar
    
finished:
    sub     eax, ebx         ; eax = eax - ebx
    pop     ebx              ; 将之前存入的值取出来
    ret                      ; 返回到调用CALL的地方

```


# 分离式编译
和C语言一样，汇编程序也是可以进行分离式编译的，你可以把自己的函数写到一个文件里，而另一的文件把它包含进去，然后就可以调用它。

## 头文件代码
```asm
;-------------------Hello World Program(include)--------------------
; 函数头文件
; by alongwy
;-------------------------------------------------------------------


;------------------------------------------
; int slen(String message)
; 计算字符串的长度
slen:
    push    ebx
    mov     ebx, eax

nextchar:
    cmp     byte [eax], 0
    jz      finished
    inc     eax
    jmp     nextchar

finished:
    sub     eax, ebx
    pop     ebx
    ret

;------------------------------------------
; void sprint(String message)
; 打印字符串
sprint:
    push    edx
    push    ecx
    push    ebx
    push    eax
    call    slen            ;调用slen计算字符串长度

    mov     edx, eax
    pop     eax

    mov     ecx, eax
    mov     ebx, 1
    mov     eax, 4
    int     80h

    pop     ebx
    pop     ecx
    pop     edx
    ret

;------------------------------------------
; void exit()
; 退出程序
quit:
    mov     ebx, 0
    mov     eax, 1
    int     80h
    ret
```

## 主文件

```asm
;-------------------Hello World Program(include)--------------------
; by alongwy
; 编译： nasm -f elf helloworld-inc.asm
; 链接： ld -m elf_i386 helloworld-inc.o -o helloworld-inc
;        64位系统需要 elf_i386 选项
; 运行： ./helloworld-inc
;-------------------------------------------------------------------

%include    'functions.asm'              ; 包含头文件
SECTION .data                            ; 数据段
    msg1    db  'Hello World!', 0Ah, 0h  ; 创建字符串，0Ah是换行符
    msg2    db  'Hello NASM!', 0Ah, 0h   ; 后面添加了一个0
    
SECTION .text                            ; 代码段
global  _start

_start:
    mov     eax, msg1           ; 存入mag1的地址
    call    sprint              ; 调用sprint打印

    mov     eax, msg1
    call    sprint

    call    exit                ; 退出
```

## 你可能会感到疑惑的地方
你会发现我们在msg的后面添加了一个0,为什么呢？
汇编器在生成二进制文件的时候，同一个段内的信息是连续存放的，而我们的slen函数是通过0来判断字符串的结束的，如果不添加这个零，就会导致msg2重复打印，有兴趣可以自己尝试一下。
