---
title: Linux Socket编程
tags:
  - Linux
  - Socket
date: 2017-09-10 10:42:44
categories: 学习
---

# 序
现在是网络的时代，不懂一点网络编程出去到不好意思跟人打招呼，Socket应该是当前网络编程的基础，今天来看一下Linux下的Socket编程。

<!-- more -->

# TCP/IP
Socket是建立在TCP/IP上的，所以想要理解Socket最好先熟悉一下TCP/IP协议族。

TCP/IP协议共有四层，每一层抽象建立在低一层提供的服务上，并且为高一层提供服务。

- **应用层**：TFTP，HTTP，SNMP，FTP，SMTP，DNS，Telnet 等等
- **传输层**：TCP，UDP
- **网络层**：IP，ICMP，OSPF，EIGRP，IGMP
- **数据链路层**：SLIP，CSLIP，PPP，MTU

更详细的内容可以参考[维基百科](https://zh.wikipedia.org/wiki/TCP/IP)或者[百度百科](https://baike.baidu.com/item/TCP%2FIP%E5%8D%8F%E8%AE%AE?fromId=7729)。

# Socket
我们知道两个进程如果需要进行通讯最基本的一个前提能能够唯一的标示一个进程，在本地进程通讯中我们可以使用PID来唯一标示一个进程，但PID只在本地唯一，网络中的两个进程PID冲突几率很大，这时候我们需要另辟它径了，我们知道IP层的ip地址可以唯一标示主机，而TCP层协议和端口号可以唯一标示主机的一个进程，这样我们可以利用ip地址＋协议＋端口号唯一标示网络中的一个进程。

能够唯一标示网络中的进程后，它们就可以利用socket进行通信了，什么是socket呢？我们经常把socket翻译为套接字，socket是在应用层和传输层之间的一个抽象层，它把TCP/IP层复杂的操作抽象为几个简单的接口供应用层调用已实现进程在网络中通信。

socket起源于UNIX，在Unix一切皆文件哲学的思想下，socket是一种"打开—读/写—关闭"模式的实现，服务器和客户端各自维护一个"文件"，在建立连接打开后，可以向自己文件写入内容供对方读取或者读取对方内容，通讯结束时关闭文件。

## Socket通信流程
1. 服务器根据地址类型（ipv4,ipv6）、socket类型、协议创建socket
2. 服务器为socket绑定ip地址和端口号
3. 服务器socket监听端口号请求，随时准备接收客户端发来的连接，这时候服务器的socket并没有被打开
4. 客户端创建socket
5. 客户端打开socket，根据服务器ip地址和端口号试图连接服务器socket
6. 服务器socket接收到客户端socket请求，被动打开，开始接收客户端请求，直到客户端返回连接信息。这时候socket进入阻塞状态，所谓阻塞即accept()方法一直到客户端返回连接信息后才返回，开始接收下一个客户端连接请求
7. 客户端连接成功，向服务器发送连接状态信息
8. 服务器accept方法返回，连接成功
9. 客户端向socket写入信息
10. 服务器读取信息
11. 客户端关闭
12. 服务器端关闭

## 三次握手
在TCP/IP协议中，TCP协议通过三次握手建立一个可靠的连接

- **第一次握手**：客户端尝试连接服务器，向服务器发送syn包（同步序列编号Synchronize Sequence Numbers），syn=j，客户端进入SYN_SEND状态等待服务器确认

- **第二次握手**：服务器接收客户端syn包并确认（ack=j+1），同时向客户端发送一个SYN包（syn=k），即SYN+ACK包，此时服务器进入SYN_RECV状态

- **第三次握手**：第三次握手：客户端收到服务器的SYN+ACK包，向服务器发送确认包ACK(ack=k+1），此包发送完毕，客户端和服务器进入ESTABLISHED状态，完成三次握手

# Socket编程API
## 创建socket--socket函数
**函数原型**:
```c
int socket(int domain, int type, int protocol);
```
**参数说明**:
- **domain**： 协议域，又称协议族（family）。常用的协议族有 AF_INET 、 AF_INET6 、 AF_LOCAL（或称AF_UNIX，Unix域Socket）、AF_ROUTE 等。协议族决定了 socket 的地址类型，在通信中必须采用对应的地址，如 AF_INET 决定了要用 ipv4 地址（32位的）与端口号（16位的）的组合、AF_UNIX 决定了要用一个绝对路径名作为地址。
- **type**： 指定 Socket 类型。常用的 socket 类型有 SOCK_STREAM 、 SOCK_DGRAM 、 SOCK_RAW 、 SOCK_PACKET 、 SOCK_SEQPACKET 等。流式 Socket（SOCK_STREAM）是一种面向连接的 Socket，针对于面向连接的 TCP 服务应用。数据报式 Socket（SOCK_DGRAM）是一种无连接的 Socket，对应于无连接的 UDP 服务应用。
- **protocol**： 指定协议。常用协议有 IPPROTO_TCP 、 IPPROTO_UDP 、 IPPROTO_STCP 、 IPPROTO_TIPC 等，分别对应 TCP 传输协议、UDP 传输协议、STCP 传输协议、TIPC 传输协议。

**注意：type 和 protocol 不可以随意组合，如 SOCK_STREAM 不可以跟 IPPROTO_UDP 组合。当第三个参数为0时，会自动选择第二个参数类型对应的默认协议。**

**返回值**:
如果调用成功就返回新创建的套接字的描述符，如果失败就返回INVALID_SOCKET（Linux下失败返回-1）。

套接字描述符是一个整数类型的值。每个进程的进程空间里都有一个套接字描述符表，该表中存放着套接字描述符和套接字数据结构的对应关系。该表中有一个字段存放新创建的套接字的描述符，另一个字段存放套接字数据结构的地址，因此根据套接字描述符就可以找到其对应的套接字数据结构。每个进程在自己的进程空间里都有一个套接字描述符表但是套接字数据结构都是在操作系统的内核缓冲里。

## 命名socket--bind函数
bind()函数把一个地址族中的特定地址赋给socket。例如对应 AF_INET、AF_INET6 就是把一个 ipv4 或 ipv6 地址和端口号组合赋给socket。

**函数原型**:
```c
int bind(int socketfd, const struct sockaddr *addr, socklen_t addrlen);
```
**参数说明**:
- **socketfd**： 一个标识已连接套接口的描述字。
- **address**： 是一个sockaddr结构指针，该结构中包含了要结合的地址和端口号。
- **address_len**： 确定 address 缓冲区的长度。

**其中 sockaddr 这个地址结构根据地址创建 socket 时的地址协议族的不同而不同。**

如ipv4对应的是：
```c
struct sockaddr_in {
    sa_family_t    sin_family; /* address family: AF_INET */
    in_port_t      sin_port;   /* port in network byte order */
    struct in_addr sin_addr;   /* internet address */
};
/* Internet address. */
struct in_addr {
    uint32_t       s_addr;     /* address in network byte order */
};
```

ipv6对应的是：
```c
struct sockaddr_in6 {
    sa_family_t     sin6_family;   /* AF_INET6 */
    in_port_t       sin6_port;     /* port number */
    uint32_t        sin6_flowinfo; /* IPv6 flow information */
    struct in6_addr sin6_addr;     /* IPv6 address */
    uint32_t        sin6_scope_id; /* Scope ID (new in 2.4) */
};
struct in6_addr {
    unsigned char   s6_addr[16];   /* IPv6 address */
};
```

Unix域对应的是：
```c
#define UNIX_PATH_MAX    108
struct sockaddr_un {
    sa_family_t sun_family;               /* AF_UNIX */
    char        sun_path[UNIX_PATH_MAX];  /* pathname */
};
```

**返回值**:如果函数执行成功，返回值为0，否则为SOCKET_ERROR。

## 监听socket--listen函数
如果作为一个服务器，在调用socket()、bind()之后就会调用listen()来监听这个socket，如果客户端这时调用connect()发出连接请求，服务器端就会接收到这个请求。
**函数原型**:
```c
int listen(int socketfd, int backlog);
```
**参数说明**:
- **socketfd**： 要监听的socket的描述字。
- **backlog**： 相应socket可以排队的最大连接个数。

socket()函数创建的socket默认是一个主动类型的，listen函数将socket变为被动类型的，等待客户的连接请求。

## 建立连接--connect函数
服务端已经做好被动接受连接的准备，那么客户端需要调用如下函数主动连接服务端，客户端利用connect函数连接服务端，如果连接成功后，其第一个参数sockfd就唯一标示这个连接。
**函数原型**:`int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);`
**参数说明**:
- **socketfd**： 客户端socket的描述字。
- **sockaddr**: 服务器的socket地址。
- **addrlen**: socket地址的长度

## 接受连接--accept函数
TCP服务器端依次调用 socket()、bind()、listen() 之后，就会监听指定的 socket 地址了。
TCP客户端依次调用 socket()、connect() 之后就向 TCP 服务器发送了一个连接请求。
TCP 服务器监听到这个请求之后，就会调用 accept() 函数取接收请求，这样连接就建立好了。
之后就可以开始网络I/O操作了，即类同于普通文件的读写I/O操作。

**函数原型**:
```c
int accept(int socketfd, struct sockaddr *addr, socklen_t *addrlen); //返回连接connect_fd
```
**参数说明**:
- **socketfd**: 就是上面解释中的监听套接字，这个套接字用来监听一个端口，当有一个客户与服务器连接时，它使用这个一个端口号，而此时这个端口号正与这个套接字关联。当然客户不知道套接字这些细节，它只知道一个地址和一个端口号。
- **sockaddr**: 结果参数，它用来接受一个返回值，这返回值指定客户端的地址，当然这个地址是通过某个地址结构来描述的，用户应该知道这一个什么样的地址结构。如果对客户的地址不感兴趣，那么可以把这个值设置为NULL。
- **len**: 它也是结果的参数，用来接受上述 addr 的结构的大小的，它指明 addr 结构所占有的字节个数。同样的，它也可以被设置为NULL。

**返回值**：成功返回客户端的文件描述符，失败返回-1。

如果accept成功返回，则服务器与客户已经正确建立连接了，此时服务器通过accept返回的套接字来完成与客户的通信。

accept默认会阻塞进程，直到有一个客户连接建立后返回，它返回的是一个新可用的套接字，这个套接字是连接套接字。

**监听套接字**：监听套接字是在调用listen函数之后，是服务器开始调用socket()函数生成的，称为监听socket描述字(监听套接字)。
**连接套接字**：accept函数返回的是已连接socket描述字(一个连接套接字)，它代表着网络中已经建立好的socket连接。

一个服务器通常通常仅仅只创建一个监听socket描述字，它在该服务器的生命周期内一直存在。内核为每个由服务器进程接受的客户连接创建了一个已连接socket描述字，当服务器完成了对某个客户的服务，相应的已连接socket描述字就被关闭。
连接套接字socketfd_new 并没有占用新的端口与客户端通信，依然使用的是与监听套接字socketfd一样的端口号。

## 数据通信--read()、write()等函数
```c
#include <unistd.h>

ssize_t read(int fd, void *buf, size_t count);
ssize_t write(int fd, const void *buf, size_t count);

#include <sys/types.h>
#include <sys/socket.h>

ssize_t send(int sockfd, const void *buf, size_t len, int flags);
ssize_t recv(int sockfd, void *buf, size_t len, int flags);

ssize_t sendto(int sockfd, const void *buf, size_t len, int flags,
                const struct sockaddr *dest_addr, socklen_t addrlen);
ssize_t recvfrom(int sockfd, void *buf, size_t len, int flags,
                struct sockaddr *src_addr, socklen_t *addrlen);

ssize_t sendmsg(int sockfd, const struct msghdr *msg, int flags);
ssize_t recvmsg(int sockfd, struct msghdr *msg, int flags);
```

**read**函数是负责从fd中读取内容，返回值如下：
- **返回值大于0**：说明读取成功，返回值是实际所读的字节数
- **返回值等于0**：表示已经读到文件的末尾
- **返回值小于0**：读取失败

**如果错误为EINTR说明读是由中断引起的，如果是ECONNREST表示网络连接出了问题。**

**write**函数将buf中的nbytes字节内容写入文件描述符fd，返回值说明如下：
- **返回值大于0**：说明写入成功，返回值是实际写入的字节数
- **返回值小于0**：写入失败，并设置errno变量

在网络程序中，当我们向套接字文件描述符写时有俩种可能:
1. write的返回值大于0，表示写了部分或者是全部的数据。
2. 返回的值小于0，此时出现了错误。我们要根据错误类型来处理。如果错误为EINTR表示在写的时候出现了中断错误。如果为EPIPE表示网络连接出现了问题(对方已经关闭了连接)。

##关闭连接--close函数
在服务器与客户端建立连接之后，会进行一些读写操作，完成了读写操作就要关闭相应的socket描述字。
**函数原型**：
```c
int close(int fd);
```

close一个TCP socket的缺省行为时把该socket标记为以关闭，然后立即返回到调用进程。该描述字不能再由调用进程使用，也就是说不能再作为read或write的第一个参数。

**注意：close操作只是使相应socket描述字的引用计数-1，只有当引用计数为0的时候，才会触发TCP客户端向服务器发送终止连接请求。**

## Select 函数说明
**Select函数用于判断Socket是否已经关闭**
**函数原型**:`int select(int nfds,fd_set *readfds, fd_set *writefds,fdset *exceptfds,const struct timval *timeout);`
**参数说明**:
- **nfds**： 忽略。
- **readfds**: 检查可读性。
- **writefds**: 检查可些性。
- **exceptfds**: 用于例外数据。
- **timeout**: 超时时间，传递NULL无限等待，0立刻返回。

### 可读性说明：
1. 有数据可以读入。
2. 连接已经关闭，重设或者中止。
3. 加入调用了listen，而且一个连接正在建立，那么accept函数调用会成功。

关于连接已经关闭，重设或者中止的判断：
当一个套接字在调用了select之后具有可读性，那么这个时候我们可以通过调用recv获得数据。如果真的有数据发送过来，那么这个调用会成功。如果是关闭，重设或者中止，那么recv的调用会失败，这个时候通过wsagetlasterror就可以判断连接是否已经中断。

### 可写性说明：
1. 有数据可以发出。
2. 如果已完成了对一个非锁定连接调用处理，连接就会成功。
对于可写性的检查，最好放在需要写数据的时候进行检查。如果和可读性放在同一个地方进行检查，那么select很可能每次都会因为可写性检查成功而返回。

### 例外数据说明：
1. 加入已完成了对一个非锁定连接调用的处理，连接尝试就会失败。
2. 有带外数据可供读写。

### fd_set几个宏的说明：
|          宏       |                          说明                              |
|-------------------|------------------------------------------------------------|
|FD_SETSIZE         |定义了fd_set所允许存放套接字的最大个数，默认是64            |
|FD_CLR(s,*set)     |从set中删除套接字s                                          |
|FD_ISSET(s, *set)  |检查s是否set集合的一名成员；如答案是肯定的是，则返回TRUE    |
|FD_SET(s, *set)    |将套接字s加入集合set                                        |
|FDZERO(*set)       |将set初始化成空集合                                         |

### select调用流程：
1. 使用FDZERO宏，初始化自己感兴趣的每一个fd_set。
2. 使用FDSET宏，将套接字句柄分配给自己感兴趣的每个fd_set。
3. 调用select函数，然后等待在指定的fd_set集合中，I/O活动设置好一个或多个套接字句柄。select完成后，会返回在所有fd_set集合中设置的套接字句柄总数，它会修改每个fd_set结构，删除那些不存在待决I/O操作的套接字句柄
4. 根据select的返回值，我们的应用程序便可判断出哪些套接字存在着尚未完成（待决）的I/O操作—具体的方法是使用FD_ISSET宏，对每个fd_set集合进行检查。
5. 知道了每个集合中“待决”的I/O操作之后，对I/O进行处理，然后返回步骤1，继续进行select处理。

# socket编程的其他函数说明
## 网络字节顺序及其转换函数
1. 网络字节顺序
每一台机器内部对变量的字节存储顺序不同，而网络传输的数据是一定要统一顺序的。所以对内部字节表示顺序与网络字节顺序不同的机器，
一定要对数据进行转换，从程序的可移植性要求来讲，就算本机的内部字节表示顺序与网络字节顺序相同也应该在传输数据以前先调用数据转换函数，
以便程序移植到其它机器上后能正确执行。真正转换还是不转换是由系统函数自己来决定的。

2. 有关的转换函数
```c
#include <netinet/in.h>
unsigned short int htons(unsigned short int hostshort);
//主机字节顺序转换成网络字节顺序，对无符号短型进行操作4bytes

unsigned long int htonl(unsigned long int hostlong);
//主机字节顺序转换成网络字节顺序，对无符号长型进行操作8bytes

unsigned short int ntohs(unsigned short int netshort);
//网络字节顺序转换成主机字节顺序，对无符号短型进行操作4bytes

unsigned long int ntohl(unsigned long int netlong);
//网络字节顺序转换成主机字节顺序，对无符号长型进行操作8bytes
```

## IP地址转换
有三个函数将数字点形式表示的字符串IP地址与32位网络字节顺序的二进制形式的IP地址进行转换：
```c
1. unsigned long int inet_addr(const char cp);
//该函数把一个用数字和点表示的IP地址的字符串转换成一个无符号长整型

//该函数成功时：返回转换结果；失败时返回常量INADDR_NONE，该常量=-1，二进制的无符号整数-1相当于255.255.255.255，这是一个广播地址，所以在程序中调用iner_addr（）时，一定要人为地对调用失败进行处理。由于该函数不能处理广播地址，所以在程序中应该使用函数inet_aton（）。

2. int inet_aton(const char cp,struct in_addr inp);
//此函数将字符串形式的IP地址转换成二进制形式的IP地址；成功时返回1，否则返回0，转换后的IP地址存储在参数inp中。

3. char inet_ntoa(struct in-addr in);
//将32位二进制形式的IP地址转换为数字点形式的IP地址，结果在函数返回值中返回，返回的是一个指向字符串的指针。
```

## 字节处理函数
Socket地址是多字节数据，不是以空字符结尾的，这和C语言中的字符串是不同的。Linux提供了两组函数来处理多字节数据，一组以b（byte）开头，是和BSD系统兼容的函数，另一组以mem（内存）开头，是ANSI C提供的函数。
以b开头的函数有：
```c
#include <strings.h>
void bzero(void s,int n);
//将参数s指定的内存的前n个字节设置为0，通常它用来将套接字地址清0。
void bcopy(const void src，void dest，int n);
//从参数src指定的内存区域拷贝指定数目的字节内容到参数dest指定的内存区域。
int bcmp(const void s1，const void s2，int n);
//比较参数s1指定的内存区域和参数s2指定的内存区域的前n个字节内容，如果相同则返回0，否则返回非0。
```
以mem开头的函数有：
```c
#include <strings.h>
void memset(void s，int c，size_t n);
//将参数s指定的内存区域的前n个字节设置为参数c的内容。
void memcpy(void dest，const void src，size_t n);
//功能同bcopy，区别：函数bcopy能处理参数src和参数dest所指定的区域有重叠的情况，memcpy则不能。
int memcmp(const void s1，const void s2，size_t n);
//比较参数s1和参数s2指定区域的前n个字节内容，如果相同则返回0，否则返回非0。
```

# 例子
## 服务端
```c
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<errno.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#define DEFAULT_PORT (8000)
#define MAXLINE (4096)
int main(int argc, char** argv){
    int socket_fd, connect_fd;
    struct sockaddr_in servaddr;
    char buff[MAXLINE];
    int n;
    //初始化Socket
    if( (socket_fd = socket(AF_INET, SOCK_STREAM, 0)) == -1 ){
        printf("create socket error: %s(errno: %d)\n",strerror(errno),errno);
        exit(0);
    }
    //初始化
    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY); //IP地址设置成INADDR_ANY,让系统自动获取本机的IP地址。
    servaddr.sin_port = htons(DEFAULT_PORT);      //设置的端口为DEFAULT_PORT
    //将本地地址绑定到所创建的套接字上
    if( bind(socket_fd, (struct sockaddr*)&servaddr, sizeof(servaddr)) == -1){
        printf("bind socket error: %s(errno: %d)\n",strerror(errno),errno);
        exit(0);
    }
    //开始监听是否有客户端连接
    if( listen(socket_fd, 10) == -1){
        printf("listen socket error: %s(errno: %d)\n",strerror(errno),errno);
        exit(0);
    }
    printf("======waiting for client's request======\n");
    while(1){
        //阻塞直到有客户端连接，不然多浪费CPU资源。
        if( (connect_fd = accept(socket_fd, (struct sockaddr*)NULL, NULL)) == -1){
            printf("accept socket error: %s(errno: %d)",strerror(errno),errno);
            continue;
        }
        //接受客户端传过来的数据
        n = recv(connect_fd, buff, MAXLINE, 0);
        //向客户端发送回应数据
        if(!fork()){
            if(send(connect_fd, "Hello,you are connected!\n", 26,0) == -1)
                perror("send error");
            close(connect_fd);
            exit(0);
        }
        buff[n] = '\0';
        printf("recv msg from client: %s\n", buff);
        close(connect_fd);
    }
    close(socket_fd);
}
```

## 客户端
```c
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<errno.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>

#define MAXLINE (4096)

int main(int argc, char** argv)
{
    int sockfd, n,rec_len;
    char recvline[MAXLINE], sendline[MAXLINE];
    char buf[MAXLINE];
    struct sockaddr_in servaddr;

    if( argc != 2){
        printf("usage: ./client <ipaddress>\n");
        exit(0);
    }

    if( (sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0){
        printf("create socket error: %s(errno: %d)\n", strerror(errno),errno);
        exit(0);
    }

    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(8000);
    if( inet_pton(AF_INET, argv[1], &servaddr.sin_addr) <= 0){ //inet_pton是Linux下IP地址转换函数，将IP地址在“点分十进制”和“整数”之间转换
        printf("inet_pton error for %s\n",argv[1]);
        exit(0);
    }

    if( connect(sockfd, (struct sockaddr*)&servaddr, sizeof(servaddr)) < 0){
        printf("connect error: %s(errno: %d)\n",strerror(errno),errno);
        exit(0);
    }

    printf("send msg to server: \n");
    fgets(sendline, 4096, stdin);
    if( send(sockfd, sendline, strlen(sendline), 0) < 0)  {
        printf("send msg error: %s(errno: %d)\n", strerror(errno), errno);
        exit(0);
    }
    if((rec_len = recv(sockfd, buf, MAXLINE,0)) == -1) {
       perror("recv error");
       exit(1);
    }
    buf[rec_len]  = '\0';
    printf("Received : %s ",buf);
    close(sockfd);
    exit(0);
}
```
