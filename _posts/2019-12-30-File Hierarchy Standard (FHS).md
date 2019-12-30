---
layout: post
categories: posts
title: File Hierarchy Standard (FHS)
subtitle: 翻译/整理自https://www.linux.org/threads/file-hierarchy-standard-fhs.9999/。
tags: [linux]
date-string: DECEMBER 30, 2019
---

# File Hierarchy Standard (FHS)

> 翻译/整理自https://www.linux.org/threads/file-hierarchy-standard-fhs.9999/，是kubernetes学习计划的第一篇文章。

FHS是绝大多数GNU/Linux和Unix/Unix-like系统的文件目录标准，被 [Linux Standard Base (LSB)](http://www.linux.org/threads/linux-standard-base-lsb.5113/#post-15085) 采用。FHS统一了GNU/Linux下数据的存放规范，定义了系统中每个区域的用途、所需要的最小构成的文件和目录同时还给出了例外处理与矛盾处理。

FHS有不同的版本，本文基于FHSv2.3。

所有的文件、文件夹、存储设备都在根目录下，被标记为`/`。根目录下有很多目录，包括标准目录和非标准目录。

## 标准目录

**/bin/**:BINary - 二进制文件存放在这里，但不是所有的二进制文件，一般是需要在单用户模式可用的必要命令和程序，例如`cp`,`ls`,`cat`等。该目录下没有其他目录。

**/boot/**: 引导程序文件，*例如：* kernel、initrd；时常是一个单独的分区。GRUB, Syslinux和其他bootloaders一般存放在此。

**/dev/**:DEVice - 代表设备的文件存放在此。GNU/Linux下一切皆文件，包括设备、目录，network sockets等。但不是所有文件都代表真实的设备，有一些是虚拟设备，比如`/dev/null`和`/dev/random`。

**/etc/**:Editable Text Configuration - 系统层面的配置文件。如在`/opt/`目录下的程序，配置文件会存放在`/etc/opt/`。`X Window`系统的文件会被存放在`/etc/X11`。

**/home/**: 用户的home目录。目录一般为`/home/USER/*`。用户在此存储他们的个人文件和配置文件。只有用户自己和root用户可以访问用户的home目录。但`/home/USER/Public(~/Public)`公共目录可被其他用户访问。Linux系统使用`~`来作为用户home目录的shortcut。

**/lib/**: 存放`/bin/` 和 `/sbin/`中二进制文件必要的库文件。如Linux内核模块存放在`/lib/modules/`中，而硬件驱动则在`/lib/firmware/`目录下。

**/lib*/**: 根目录下可能有其他库目录存在，例如`/lib64/`存放64-bit的库。

**/lost+found/**: 磁盘检查如fsck发现或者恢复了一个损坏的文件就会放在这里。

**/media/**: 可移除媒体的挂载点，一般用于挂在储存单元。

**/mnt/**: 临时挂载的文件系统。一些系统可能会将存储空间挂载在此。

**/opt/**: OPTional - 可选应用软件。如游戏、第三方应用软件等。

**/proc/**: 进程文件系统（ProcFS）挂在于此。

**/root/**: root用户的home目录。同样地，root用户的public目录也是公开的。

**/sbin/** - Like `/bin/`

