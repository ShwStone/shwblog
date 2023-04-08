---
title: NOI-Linux
comments: true
top: 2
date: 2023-04-08 09:53:09
updateDate: 2023-04-08 09:53:09
tags:
categories:
---

---

<!--more-->

## 安装

NOI-Linux 的安装程序和 Ubuntu 的 20.04 安装程序是一样的，但是如果想要配置出和省选赛场一样的环境，需要注意以下几点：

1. 安装时断开网络
2. 在第一个界面语言选择中文（这样会预装输入法），第二个界面键盘可选 `English(US)` 或者 `Chinese` 。
3. 选择正常安装（不是最小化）
4. **分区时清除整个磁盘**

## 配置

### 网络

省选赛场是没有网络连接的，但是训练的时候还是联网方便。（最好不要去装 VSCode 的插件，因为赛场上没有）

机房的网络是没有 DHCP 的，所以需要手动配置 IP 。

编辑 `/etc/netplan/01-networkmanager-all.yaml` ：

```yaml
network:
  version: 2
  renderer: networkmanager #大小写可能不太一样，我记不太清了
  ethernets:
    ens0p1:
      dhcp4: no
      addresses: #IP/掩码，例如 192.167.16.80/24
      gateway4: #网关
      nameservers:
        addresses: [8.8.8.8, 114.114.114.114]
```

然后执行 `sudo netplan try` 。确认无误后按下回车即可应用。

### 联网更新（不推荐）

也说不准要自己装一些工具。和正常的 ubuntu 没啥区别，换一下源之后就可以用 `apt` 了。

### 关闭 sudo

省选赛场居然没有 sudo 是我没想到的（可能是被卡老师整怕了）

为了还原，我们也做一下吧：

```sh
sudo su # 进入root
passwd # 设置root密码，启用root账户
gpasswd -d username sudo # 删除普通用户的sudo权限
reboot # 重启生效
```

之后需要管理员的时候就输入root的密码；在终端下就直接用 `su` 登陆 root 账户。

### ulimit

基于上一条，更改全局的 ulimit 是不可能的。普通用户使用 ulimit 只对当前 shell 和其子进程有效。如果要对所有用户或某个用户设置全局的资源限制，需要修改 /etc/security/limits.conf 文件，并重新登录。

而想要更改当前 shell 下的栈空间，就用 `ulimit -s unlimited` 就好。

还有一个误区： Linux 下无限栈显然不是在 IDE 里开的。不管用什么软件编辑代码，程序肯定是在终端里运行的，更改那个终端的 ulimit 就好。

