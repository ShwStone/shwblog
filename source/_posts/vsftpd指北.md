---
title: vsftpd指北
comments: true
top: 2
date: 2022-10-04 05:49:31
updateDate: 2022-10-04 05:49:31
tags:
- vsftpd 
categories: 
- linux
- ftp
---

温馨提示：本文适合那些需要在 linux 上配置 ftp 而又**不需要考虑安全性**的人阅读。（比如想在机房专门开一个服务器跑评测）

<!--more-->

## 安装

这种需求的话，用的都是 Ubuntu 吧。 ~~(不过还是贴一下常见的三种安装)~~

```sh
yay -S vsftpd
# sudo pacman -S vsftpd
# sudo apt install vsftpd
# sudo yum install vsftpd
```

然后开机自启动:

```sh
sudo systemctl enable vsftpd
sudo systemctl start vsftpd
```

## 配置

机房的使用，就不用 local 账户登录了，这里全部采用匿名用户登录，并且免去密码。

### First of All

编辑 `/etc/hosts.allow` :

```yaml
# Allow all connections
vsftpd: ALL
# IP address range
vsftpd: 10.0.0.0/255.255.255.0
```

### /etc/vsftpd.conf

编辑 `/etc/vsftpd.conf` :

```conf
listen=NO
listen_ipv6=YES

write_enable=YES

anonymous_enable=YES
anon_mkdir_write_enable=YES
anon_upload_enable=YES
no_anon_password=YES

chroot_local_user=YES

allow_writeable_chroot=YES

anon_root=#Your ftp path
anon_umask=000
## anon_umask
## 设置用户上传后的文件的权限情况。用户上传的文件的权限 = `777 xor anon_umask` （八进制）。如果需要在 upload 上直接跑CCR、Lemon之类的话最好开000，否则开022
```

## debug

目前遇到了两个 bug ，一个是在加入 `allow_writeable_chroot=YES` 之后仍然不能将 ftp 根目录设置为可读可写（出现 `500 OOPS: vsftpd: refusing to run with writable root inside chroot()` ）。解决方案：

在 ftp  目录下设置两个目录： upload 和 download 。然后执行：

```sh
chmod 755 -R ftp
chmod 777 -R upload
```

这样 upload 就实现了可写，而 download 就只能只读。并且 ftp 可以成功访问。

另一个是乱码问题。 Windows 使用的是 GBK 编码，但是 Linux 上一般是 UTF-8 ，而 vsftpd 是不支持编码转换的，所以要在 Windows 端做手脚：

（参考[这里](https://blog.51cto.com/461205160/1729465)）

如 Windows 上是 FlashFXP 客户端，选择 **站点** - **站点管理器** - **站点列表** - **快速连接** ，选择 **使用的连接** ，点击 **选项** - **字符编码** - **UTF-8** 。

FileZilla 客户端，选择 **站点** - **站点管理器** - **站点列表** - **字符集** ，选择 **强制UTF-8** 。

其他客户端大同小异，总之是要在 Windows 客户端上把 GBK 编码转为 UTF-8 编码。