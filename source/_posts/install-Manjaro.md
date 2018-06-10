---
title: 安装Linux/Manjaro
date: 2017-08-20 22:28:19
tags: 
    - Linux 
    - Manjaro
categories: 学习
---

# Manjaro介绍
Manjaro 是一款基于 Arch Linux 、对用户友好、全球排名前3的、高于国内优秀Linux系统Deepin 6个名次的Linux发行版，它使用Xfce，KDE和Gnome作为默认桌面环境，和Arch一样，采用滚动更新。其目标是为PC提供易于使用的自由的操作系统。

<!-- more --> 

## 优势
* 滚动更新可以使软件保持最新
* AUR软件仓库有着世界上最齐全的Linux软件
* 丰富的wiki和活跃的社区让所有问题都可以快速得到满意的答案

## 相对于 Arch Linux 的改进
* 简单、用户友好的图形化安装程序
* 自动检测计算机的硬件（例如显卡）
* 为系统自动安装必要的软件（例如图形驱动程序）
* 它自己的专用软件仓库，以确保提供完全测试过的稳定的软件包
* 支持轻松安装和使用多个内核。
* 预安装桌面环境
* 独家开发的pamac软件管理器，轻松安装软件和更新您的系统
* 预安装编解码器播放多媒体文件

#  Manjaro安装
## 下载Manjaro安装盘
首先是到[Manjaro官方下载地址](https://manjaro.org/get-manjaro/)下载 Manjaro安装盘。

## 刻录 Manjaro安装盘

### Linux / Mac OS
在命令行中输入`dd bs=4M if=/path/to/manjaro.iso of=/dev/sd[drive letter] status=progress`即可将其烧录至U盘中。

### Windows
使用 **[Rufus](http://rufus.akeo.ie/)** 或者是 **[ ImageWriter For Windows](https://sourceforge.net/projects/win32diskimager/)** 进行烧录操作，切记要选择 **DD** 模式，否则会导致引导失败。

## 安装 Manjaro
安装过程中唯一要说的是启动时选择第二项boot（non-free),Manjaro自带的驱动精灵会帮你安装好所需驱动，笔记本双显卡则会帮你安装bumblebee。

## 配置 Manjaro
### 更新系统

Manjaro 是一个滚动更新的 Linux 发行版，所以下载到的系统的未必是最新的，所以需要更新一下。

1. 更新仓库列表`sudo pacman-mirrors -g`
2. 同步远程仓库内容`sudo pacman-optimize && sync`
3. 升级系统：`sudo pacman -Syyu`

*有可能产生的问题*

1. 运行`sudo pacman -Syyu`提示无法锁定database的错误：
运行这个命令：`sudo rm /var/lib/pacman/db.lck`。
2. 运行`sudo pacman -Syyu`提示Keys，GPG错误的，依次运行以下命令：
``` bash
sudo rm -r /etc/pacman.d/gnupg                                                    #移除旧的keys
sudo pacman -Sy gnupg archlinux-keyring manjaro-keyring                           #重新安装最新keys
sudo pacman-key --init                                                            #初始化pacman的keys
sudo pacman-key --populate archlinux manjaro                                      #加载签名的keys
sudo pacman-key –refresh-keys                                                     #刷新升级已签名keys
sudo pacman -Sc                                                                   #清空并下载新数据
```
最后运行：`sudo pacman -Syu`。

### 安装中文语言包
Manjaro 默认的语言包不全，所以需要安装libreoffice和firefox等软件的中文语言包，进入设置
![设置界面](http://outffp6yd.bkt.clouddn.com/Manjaro-Setting.png)
进入`Manjaro Settings Mannager`选择 **语言包** ，然后选择 **已安装的语言包** （肯定是翻译错了）即可安装。

### 添加国内源
运行这个命令：`sudo nano /etc/pacman.conf`在`pacman.conf`中添加如下信息
```
[archlinuxcn]
SigLevel = Optional TrustedOnly
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
```
再执行下列命令`sudo pacman -Syy && sudo pacman -S archlinuxcn-keyring`。

而后就可以在Pacman里面找到 **Chrome** 浏览器和输入法了，可以根据需要安装。

### 安装中文输入法
这里我安装的是谷歌拼音：
```bash
sudo pacman -S fcitx-googlepinyin   #安装谷歌拼音
sudo pacman -S fcitx-im                         # 全部安装
sudo pacman -S fcitx-configtool        # fcitx图形化配置工具
```
设置中文输入法环境变量，否则中文输入法无法启动，终端输入：
```bash
sudo nano ~/.xprofile
```
将以下文本追加到文件后面：
```bash
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
```
而后在命令行输入`fcitx`启动输入法。

### 安装zsh
既然是用 Linux 当然没有忘记把 bash 换成 zsh
首先是安装 zsh:`sudo pacman -S zsh`
接着配置 oh-my-zsh:
`sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" `
最后更换默认的 shell:`chsh -s /bin/zsh`

# 常用软件介绍
## 上网
* Chrome- 一款流行的浏览器，有着无数插件和应用。
* Firefox- 一款流行的浏览器，有着无数插件和应用
* Vivaldi- 一款新兴的浏览器，有着许多的个性化配置
* uGet- Linux 下最好的下载管理器
* Filezilla- 免费的 FTP 解决方案
* Syncthing- Syncthing 用开放，值得信赖，去中心化的方案取代专有的同步和云服务。
* Teamviewer- PC 远程控制/远程访问软件，对个人使用免费
* aMule- 着名的eDonkey / Kad客户端，具有守护进程版本和GTK +，Web和CLI前端。

## 多媒体
* Kodi- 一款获得殊荣的免费开源（GPL）软件，支持视频，音乐，图片，游戏以及更多内容的媒体中心。
* VLC- VLC 是一个免费且开源的跨平台媒体播放器以及框架，可以播放大多数格式的多媒体文件以及 DVS，音频 CD，VCD，以及各种流媒体协议。
* 网易云音乐：本土的网络音乐播放器，可以和其他平台一帐号使用。
* 深度音乐：深度系统的音乐播放器

## 办公
* Calibre- 难以置信的丑但很强大的电子书管理和转换软件。
* Foxit- Foxit Reader 8.0——获得殊荣的 PDF 阅读器。
* Thunderbird- Thunderbird 是一款免费的电子邮件客户端，设置以及个性化简单方便，功能强大。
* WPS office- Linux 上的最佳办公套件之一。
* LibreOffice- Linux 上的最佳办公套件。
* goldendict:linux一款强大的字典
* SpeedCrunch- 一个漂亮，开源，高精度的科学计算器。

## 安全
* ClamAV- Clam 防病毒
* GuFW- Linux 世界中最简单的防火墙之一
* Bleach bit- BleachBit 快速释放磁盘空间并不知疲倦地守卫你的隐私。释放缓存，删除 cookie，清除互联网浏览历史，清理临时文件，删除日志，以及更多功能...

## 聊天
* Skype- Skype 让世界保持沟通，免费的。
* franz:一个集合wechat.google.fancebook等的客户端。
* QQ和微信:国内应用最多的聊天工具。一般是用wine或者虚拟机解决，
