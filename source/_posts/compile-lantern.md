---
title: 编译安装不限流量的Lantern
tags:
  - lantern
date: 2017-09-16 20:29:59
categories: 学习
---

# Lantern简介
蓝灯是一款很不错的软件，然而近来它开始收费了，不过自己编译的版本好像没有这个限制，现在让我们自己动手编译一个蓝灯出来。

<!-- more --> 
# 安装Lantern的依赖
1. [Go语言](https://golang.org/dl/)
2. [Git](https://git-scm.com/)
3. GNU Make / [MinGW](https://xylc.cc/install-mingw-w64-on-windows/)
4. [Nodejs & NPM](https://nodejs.org/zh-cn/)
5. Glup ：安装 NPM 之后在命令行输入 `npm i gulp-cli -g` 即可安装

**注意配置好环境变量**

# 下载Lantern Git仓库
找到一个你喜欢的位置，右键 `Git Bash here`，输入 `git clone https://github.com/getlantern/lantern.git` 即可下载。

# 修改代码
Lantern使用的是自己修改的Go语言，有些东西官方的没有，我们把这部分代码给注释掉。

打开 *lantern/src/github.com/getlantern/flashlight/client* 下的 **reverseproxy.go** 文件：
将以下代码注释掉：
```go
func (client *Client) newReverseProxy() *httputil.ReverseProxy {
    transport := &http.Transport{
        TLSHandshakeTimeout: 40 * time.Second,
//      MaxIdleTime:         30 * time.Second,       **注释掉**
    }
//  transport.EnforceMaxIdleTime()                   **注释掉**
```
然后打开 *lantern/src/github.com/getlantern/flashlight/proxied* 下的 **proxied.go** 文件：
将以下代码注释掉：
```go
//  if persistent {                                 **注释掉**
//      tr.MaxIdleTime = 30 * time.Second           **注释掉**
//      tr.EnforceMaxIdleTime()                     **注释掉**
//  }                                               **注释掉**
```

# 编译
在lantern目录下，使用gitbash，输入 `make lantern`，即可完成编译。
windows下可能需要输入 `mingw32-make lantern` 。

# 配置
lantern的代理端口如下：

| 代理模式 |            代理端口               |
|----------|-----------------------------------|
|   http   |http://127.0.0.1:8087              |
|   https  |http://127.0.0.1:8088              |
|   pac    |http://127.0.0.1:16823/proxy_on.pac|

如果不想使用全局代理的话可能会用到。
