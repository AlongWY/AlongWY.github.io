---
title: 安装Windows和Linux双系统
tags:
  - Windows
  - Linux
date: 2017-09-06 10:06:59
categories: 教程
---

# 简介
相信很多人都想尝试一下传说中的Linux，但是不能下定决心把Windows卸载掉安装Linux，我们可以采用一种折中的方式让大家体验到Linux的魅力，那就是安装双系统。

<!-- more -->

# 制作安装盘
估计现在用光盘的也不多了，我们这里采用U盘来制作。
下载Linux安装盘，我这里采用的是[Manjaro](https://manjaro.org/get-manjaro/)，
下面是一些流行的Linux发行版：
- [Manjaro](https://manjaro.org/get-manjaro/)
- [Mint](https://www.linuxmint.com/download.php)
- [Ubuntu](http://www.ubuntu.org.cn/download/desktop)
- [CentOS](https://www.centos.org/download/)

下载**[ImageWriter For Windows](https://sourceforge.net/projects/win32diskimager/)**，我们将使用它来制作安装盘。
选择DD模式，选择你的U盘和刚才下载下来的Linux安装盘，点击刻录，然后等待制作完成即可。

**注意： 这里你U盘的数据将会被全部清空，需要再次使用时需要重新格式化**

# 关闭BIOS的Secure Boot
一般是在开机时按 **F2** 键即可进入BIOS设置界面，在Secure选项卡中将Secure Boot选项改为Disabled即可。

# 设置U盘启动
开机时按下 **F9** 即会出现启动选项卡，选择你的U盘，按下回车即可进入。

下面是一些常见品牌进入启动选项卡的按键：

|品牌 |按键|
|----|----|
|DELL|F12 |
|联想 |F12 |
|华硕 |ESC |
|惠普 |F9  |

## 关于DELL
昨天给室友安装Linux，有两台笔记本都是DELL的，设置U盘启动比较怪，需要自己添加U盘启动项：
在 **BIOS界面** 的Boot选项卡中选择添加启动项（一般在这个界面你会见到有Windows boot loader之类的东西），选择你的U盘，他会让你选择路径，大概是这个路径 *EFI/grubx64.efi* ，
然后就可以进入了。

# 安装系统
有的人会问怎么腾出来给Linux用的空间啊，可以用Windows下的磁盘分区管理器压缩空间，也可以使用Linux下的Gparted，或者Manjaro中的partitionmanager。
**可能需要用到Root权限，在终端中输入SU，而后输入Gpart或者partitionmanager即可**

## Manjaro
启动时选择第二项boot（non-free),Manjaro自带的驱动精灵会帮你安装好所需驱动，笔记本双显卡则会帮你安装bumblebee。

## 关于分区
不得不讲一下分区的问题，要不然可能会出现错误。
1. swap交换空间，这个也就是虚拟内存的地方，选择主分区和空间起始位置。如果你给Ubuntu系统分区容量足够的话，最好是能给到你物理内存的2倍大小，像我8GB内存，就可以给个16GB的空间给它，这个看个人使用情况，太小也不好，太大也没用。（其实我只给了8GB，没什么问题）

2. 新建efi系统分区，格式为Fat32,设置挂载点为 **boot/efi** ，设置标识为 **esp**，有的人硬盘上已经有efi分区了，可以直接挂载上去。

3. 最后，挂载“/”，类型为EXT4日志文件系统。

## 安装Grub2
Mangaro安装好之后，选择现在进入Manjaro，单击退出即可进入Manjaro，这个时候重启，十有八九你是进入不了Manjaro了，只会进入Windows，我们需要重写MBR，在终端下输入如下命令：

```bash
sudo grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

即可完成安装。

## 如果重启了怎么办？
使用用Manjaro的安装盘，再次进入安装初始界面，选择倒数第二个选项，大概是EFI什么的，选中里面的grubx64.efi，进入grub2引导界面，选择Manjaro即可进入系统。

## Manjaro
如果你和我做了同样的选择，安装的是Manjaro的话，安装后配置可以参照我的另一篇博客:{% post_link install-Manjaro %}