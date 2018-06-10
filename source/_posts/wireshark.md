---
title: Wireshark解决权限问题
tags:
  - 网络
  - Wireshark
date: 2017-11-17 15:30:16
categories: 学习
---
# Wireshark 简介
Wireshark是一个免费开源的网络数据包分析软件。网络数据包分析软件的功能是截取网络数据包，并尽可能显示出最为详细的网络数据包数据。 在过去，网络数据包分析软件是非常昂贵，或是专门属于营利用的软件，Wireshark的出现改变了这一切。
<!-- more --> 

# 权限问题
安装了 Wireshark 后会遇到没有权限的问题。

# 解决方案
1. 添加wireshark用户组
   `$ sudo groupadd wireshark`

2. 将dumpcap更改为wireshark用户组
   `$ sudo chgrp wireshark /usr/bin/dumpcap`

3. 让wireshark用户组有root权限使用dumpcap
   `$ sudo chmod 4755 /usr/bin/dumpcap`
   (注意:如果设为4754 Wireshark还是会提示没有权限 )

4. 将用户加入wireshark组
`$ sudo gpasswd -a username wireshark`或者`$ sudo usermod -a -G wireshark username`
