<div align="center">

  <!-- 本地自托管高清 Banner -->
  <img src="./assets/banner.svg" width="100%" alt="Arch Linux Guide Banner"/>

  <br><br>

  <p align="center">
    <img src="https://img.shields.io/badge/Platform-Pure%20Arch%20Linux-1793d1?style=for-the-badge&logo=archlinux&logoColor=white" />
    <img src="https://img.shields.io/badge/Compositor-Niri%20Wayland-FF69B4?style=for-the-badge&logo=wayland&logoColor=white" />
    <img src="https://img.shields.io/badge/Graphics-Vulkan%20%26%20NVIDIA%20Prime-76B900?style=for-the-badge&logo=nvidia&logoColor=white" />
    <img src="https://img.shields.io/badge/Shell-Fish%204.x-008080?style=for-the-badge&logo=gnubash&logoColor=white" />
    <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" />
    <img src="https://img.shields.io/badge/Author-shenchuchu91--hub-ffb6c1?style=for-the-badge" />
  </p>

  <p align="center">
    <i>从裸机系统底座构建，到现代化 Wayland 卷轴平铺桌面的全景实战工程指南</i>
    <br>
    <sub>“代码当严谨，系统亦优雅。记录纯正 Arch Linux 体系下每一处经过实践检验的技术细节。”</sub>
  </p>

</div>

---

## 📑 目录全景 (Table of Contents)

- [前言与架构准则 (Preface & Philosophy)](#-前言与架构准则-preface--philosophy)
- [硬件测试基准与环境对照 (System Specs & Testing Rig)](#-硬件测试基准与环境对照-system-specs--testing-rig)
- [卷一：纯净 Arch Linux 裸机系统安装与底座 (Base Installation)](#-卷一纯净-arch-linux-裸机系统安装与底座-base-installation)
  - [1.1 介质准备与 UEFI 引导前置](#11-介质准备与-uefi-引导前置)
  - [1.2 Live 环境联网与时钟同步](#12-live-环境联网与时钟同步)
  - [1.3 GPT 磁盘分区与文件系统规划](#13-gpt-磁盘分区与文件系统规划)
  - [1.4 系统引导与 pacstrap 核心包安装](#14-系统引导与-pacstrap-核心包安装)
  - [1.5 系统基础配置与 Chroot 环境](#15-系统基础配置与-chroot-环境)
  - [1.6 GRUB 双系统引导与 os-prober 配置](#16-grub-双系统引导与-os-prober-配置)
  - [1.7 权限分配、用户创建与核心守护进程](#17-权限分配用户创建与核心守护进程)
- [卷二：现代硬件驱动与混合显卡调度 (Hardware Drivers & Hybrid GPU)](#-卷二现代硬件驱动与混合显卡调度-hardware-drivers--hybrid-gpu)
  - [2.1 CPU 微码加载与动态电源管理](#21-cpu-微码加载与动态电源管理)
  - [2.2 NVIDIA + Intel 混合双显卡 Prime 独显渲染架构](#22-nvidia--intel-混合双显卡-prime-独显渲染架构)
  - [2.3 PipeWire 现代低延迟音频架构](#23-pipewire-现代低延迟音频架构)
  - [2.4 蓝牙与外设 udev 设备规则](#24-蓝牙与外设-udev-设备规则)
- [卷三：Niri 卷轴式平铺桌面环境工程 (Niri Rice & Compositor)](#-卷三niri-卷轴式平铺桌面环境工程-niri-rice--compositor)
  - [3.1 卷轴平铺哲学：为什么选择 Niri？](#31-卷轴平铺哲学为什么选择-niri)
  - [3.2 模块化配置体系拆解 (Window Rules & Animations)](#32-模块化配置体系拆解-window-rules--animations)
  - [3.3 桌面外壳、状态栏与启动器 (DMS / Waybar / Fuzzel)](#33-桌面外壳状态栏与启动器-dms--waybar--fuzzel)
  - [3.4 终端生产力套件 (Fish 4.x + Starship + Kitty / Foot + Yazi)](#34-终端生产力套件-fish-4x--starship--kitty--foot--yazi)
  - [3.5 Material You 动态色彩提取与主题统合](#35-material-you-动态色彩提取与主题统合)
- [卷四：中文本地化与现代字体排版 (Localization & Typography)](#-卷四中文本地化与现代字体排版-localization--typography)
  - [4.1 Fcitx5 输入法在 Wayland 会话中的配置](#41-fcitx5-输入法在-wayland-会话中的配置)
  - [4.2 字体矩阵与 fontconfig 渲染规则](#42-字体矩阵与-fontconfig-渲染规则)
- [卷五：游戏与生产力运行时生态 (Gaming & Productivity Runtime)](#-卷五游戏与生产力运行时生态-gaming--productivity-runtime)
  - [5.1 Multilib 32位库与 Vulkan 环境配置](#51-multilib-32位库与-vulkan-环境配置)
  - [5.2 Steam 原生与 Proton-GE 兼容层配置](#52-steam-原生与-proton-ge-兼容层配置)
  - [5.3 Gamescope 144Hz 锁帧与性能监控实践](#53-gamescope-144hz-锁帧与性能监控实践)
- [卷六：自动化无损部署脚本与维护 (Automated Setup & Safety)](#-卷六自动化无损部署脚本与维护-automated-setup--safety)
  - [6.1 一键部署脚本执行逻辑](#61-一键部署脚本执行逻辑)
  - [6.2 自动时间戳备份与无损回滚机制](#62-自动时间戳备份与无损回滚机制)
- [致敬、安全守则与许可证 (Credits & Disclaimer)](#-致敬安全守则与许可证-credits--disclaimer)

---

## 🌸 前言与架构准则 (Preface & Philosophy)

在 Linux 世界中，**Arch Linux** 始终代表着追求透明、简洁（KISS 原则）与极高自主控制权的极客精神。

不同于各类封装好的开箱即用衍生版，**真正的纯正 Arch Linux (Pure Arch Way)** 意味着每一个软件包、每一项守护进程、每一行内核参数均由用户亲手挑选并知晓其运行机制。

本文档立足于**实机生产力与日常娱乐环境**，记录了从裸机硬件准备开始，一步步搭建出稳定底座，并最终演进为现代化 **Niri Wayland 卷轴平铺桌面** 的全流程实战经验。

### 核心工程原则：
1. **真实可复现**：拒绝玄学参数与不可查证的调整，所有步骤均基于官方文档并经实机验证；
2. **非破坏性与数据安全**：所有辅助脚本均遵循无损软链接规则，强制执行备份前置；
3. **架构整洁与现代标准**：全面拥抱现代 Linux 栈（Wayland, PipeWire, systemd-resolved, DKMS, Vulkan 1.3）。

---

## 💻 硬件测试基准与环境对照 (System Specs & Testing Rig)

为便于评估本套指南在不同设备上的适用性，下表列出了本文档编写所基于的**测试验证环境**与建议的**最低运行基准**：

<div align="center">

| 硬件 / 环境项目 | 测试验证参考规格 (Tested Environment) | 建议最低运行门槛 (Minimum Requirements) |
| :--- | :--- | :--- |
| **设备类型** | 现代混合显卡游戏笔记本 (HP Victus 15) | 常见 64 位 x86_64 笔记本或台式机 |
| **处理器 (CPU)** | 13th Gen Intel Core i7-13620H (16 线程 @ 4.9GHz) | 4 核心 8 线程以上 x86_64 处理器 |
| **独立显卡 (GPU)** | NVIDIA GeForce RTX 5060 Laptop (驱动: 565+/615+) | 支持 Vulkan 1.3 的独立显卡或现代核心显卡 |
| **核心显卡 (iGPU)** | Intel UHD Graphics (13th Gen) | 任意具备硬件加速能力的核显 |
| **屏幕规格** | 1080p @ 144Hz IPS 高刷新率屏 | 1080p @ 60Hz 标准显示屏 |
| **运行内存** | 16 GB DDR5 高速内存 | 8 GB RAM (日常流畅运行门槛) |
| **固态硬盘** | NVMe PCIe 4.0 SSD | 任意 SATA / NVMe 固态硬盘 |

</div>

---

## 🏛️ 卷一：纯净 Arch Linux 裸机系统安装与底座 (Base Installation)

### 1.1 介质准备与 UEFI 引导前置
1. 从 [Arch Linux 官方镜像站](https://archlinux.org/download/) 下载最新的 ISO 镜像；
2. 使用 Ventoy 或 `dd` 写入 U 盘启动介质：
   ```bash
   sudo dd bs=4M if=archlinux-*.iso of=/dev/sdX status=progress oflag=sync
   ```
3. 进入主机 BIOS/UEFI 设置界面：
   - **关闭 Secure Boot**（安全引导）；
   - 将 SATA/NVMe 控制器模式设置为 **AHCI / NVMe**（禁止 Intel RST/RAID 模式）；
   - 保存并从制作好的 UEFI U 盘启动。

---

### 1.2 Live 环境联网与时钟同步
进入终端后，首先确认网络连通性：

```bash
# 1. 有线网络通常自动获取 IP；若使用无线网络，调用 iwctl:
iwctl
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "你的WiFi名称"
exit

# 2. 测试网络连通性
ping -c 3 archlinux.org

# 3. 启用网络时间同步 (NTP)，防止时间偏差导致 SSL 证书验证失败
timedatectl set-ntp true
```

---

### 1.3 GPT 磁盘分区与文件系统规划
推荐使用 `cfdisk` 对目标固态硬盘（如 `/dev/nvme0n1`）进行规划：

```
+--------------------------------------------------------------+
| 分区规划推荐模型 (单盘双系统或纯 Arch 推荐)                   |
|                                                              |
| 分区 1: 1024 MB  FAT32 (类型: EFI System Partition) -> /boot |
| 分区 2: 剩余全部  Ext4 或 Btrfs (类型: Linux Filesystem) -> / |
+--------------------------------------------------------------+
```

```bash
# 查看硬盘标识
lsblk

# 使用 cfdisk 图形化分区
cfdisk /dev/nvme0n1

# 格式化分区
mkfs.vfat -F 32 /dev/nvme0n1p1       # EFI 分区
mkfs.ext4 /dev/nvme0n1p2              # 根分区 (若使用 Btrfs 亦可)

# 挂载分区至 /mnt
mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

---

### 1.4 系统引导与 pacstrap 核心包安装
选择速度最佳的国内官方镜像源，并安装最小化现代底座包：

```bash
# 1. 刷新镜像源 (推荐清华 TUNA / 中科大 USTC)
reflector --country China --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# 2. 核心包初始化 (pacstrap)
pacstrap -K /mnt base base-devel linux-zen linux-firmware intel-ucode btrfs-progs e2fsprogs git nano vim
```

> 💡 *内核选型说明：推荐选择 `linux-zen` 内核，其针对桌面交互延迟与多任务响应进行了专门调度优化。若为 AMD 平台，请将 `intel-ucode` 替换为 `amd-ucode`。*

---

### 1.5 系统基础配置与 Chroot 环境

```bash
# 1. 生成并校验文件系统挂载表
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

# 2. 进入新系统环境 (chroot)
arch-chroot /mnt

# 3. 设置时区为亚洲/上海，并同步硬件时钟
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

# 4. 生成字符集 Locale
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

# 5. 设置主机名与 hosts
echo "arch-laptop" > /etc/hostname
cat << 'EOF' > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch-laptop.localdomain arch-laptop
EOF

# 6. 设置 root 管理员密码
passwd
```

---

### 1.6 GRUB 双系统引导与 os-prober 配置

```bash
# 安装引导加载程序与系统探测器
pacman -S grub efibootmgr os-prober ntfs-3g

# 开启 GRUB 的第三方系统探测支持
sed -i 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub

# 安装 GRUB 引导至 EFI 系统分区
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch

# 重新生成 grub.cfg 引导文件
LANGUAGE=en_US.UTF-8 grub-mkconfig -o /boot/grub/grub.cfg
```

---

### 1.7 权限分配、用户创建与核心守护进程

```bash
# 1. 创建属于 wheel 组的日常普通用户（请把 <你的用户名> 换成自己的用户名）
useradd -m -G wheel -s /bin/bash <你的用户名>
passwd <你的用户名>

# 2. 赋予 wheel 组 sudo 提权权限
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# 3. 启用基础网络与时间管理服务
pacman -S networkmanager systemd-resolved openssh
systemctl enable NetworkManager
systemctl enable systemd-resolved

# 4. 退出 chroot，卸载分区并重启
exit
umount -R /mnt
reboot
```

---

## ⚡ 卷二：现代硬件驱动与混合显卡调度 (Hardware Drivers & Hybrid GPU)

重启登录刚建好的普通用户，开始配置底层显卡与现代驱动。

### 2.1 CPU 微码加载与动态电源管理
```bash
# 安装电源调控服务与微码工具
sudo pacman -S power-profiles-daemon acpid
sudo systemctl enable power-profiles-daemon
sudo systemctl enable acpid
```

### 2.2 NVIDIA + Intel 混合双显卡 Prime 独显渲染架构
游戏笔记本（例如 13代酷睿 + RTX 5060）的核心关键在于：**既能使用 Intel 核显保障日常低功耗与续航，又能在游戏时完整委托 NVIDIA 独立显卡渲染**。

```bash
# 1. 安装匹配 Zen 内核的 DKMS 驱动与工具包
sudo pacman -S linux-zen-headers nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader

# 2. 开启早期内核 KMS 加载 (Early KMS)，彻底避免进入桌面时黑屏或撕裂
sudo nano /etc/mkinitcpio.conf
# 在 MODULES=(...) 中填入:
# MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)

# 3. 启用 DRM 模式并重新生成 initramfs
echo "options nvidia_drm modeset=1 fbdev=1" | sudo tee /etc/modprobe.d/nvidia.conf
sudo mkinitcpio -P

# 4. 启用 NVIDIA 系统挂起/休眠恢复服务 (解决睡眠唤醒黑屏)
sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service
```

---

### 2.3 PipeWire 现代低延迟音频架构
```bash
sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber pavucontrol
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

---

### 2.4 蓝牙与外设 udev 设备规则
```bash
sudo pacman -S bluez bluez-utils steam-devices
sudo systemctl enable --now bluetooth
```

---

## 🪟 卷三：Niri 卷轴式平铺桌面环境工程 (Niri Rice & Compositor)

### 3.1 卷轴平铺哲学：为什么选择 Niri？
在平铺窗口管理器（Tiling WM）的演进历程中：
- 传统切屏（i3 / bspwm / Hyprland）按固定屏幕划分空间，窗口开多后每个窗口变得狭窄不堪；
- **Niri** 采用现代的**无限水平滚动卷轴（Infinite Horizontal Strip）**设计理念：每个窗口始终拥有最舒适的阅读与工作宽度，通过快捷键丝滑横向平移，兼具平铺的键盘流效率与浮动的视觉舒展度。

---

### 3.2 模块化配置体系拆解 (Window Rules & Animations)
在我们的开源配置 [`shenchuchu91-hub/dotfiles`](https://github.com/shenchuchu91-hub/dotfiles) 中，Niri 采用清晰的模块化拆解：

```
~/.config/niri/
├── config.kdl              # 核心快捷键与输出显示配置
├── layout.kdl              # 卷轴视口间隙、边框厚度与聚焦规则
├── animations.kdl          # 物理弹簧曲线与平滑过渡
├── blur.kdl                # 高斯模糊与毛玻璃透明度
└── shorin-windowrules.kdl  # 常用国产软件（微信、QQ、播放器）浮动/居中过滤规则
```

#### 关键快捷键映射：
- <kbd>Super</kbd> + <kbd>Return</kbd>：打开轻量终端 (Foot / Kitty)
- <kbd>Super</kbd> + <kbd>D</kbd>：唤出应用启动器 (Fuzzel)
- <kbd>Super</kbd> + <kbd>H</kbd> / <kbd>L</kbd>：水平平移聚焦视口
- <kbd>Super</kbd> + <kbd>Q</kbd>：关闭聚焦窗口
- <kbd>Super</kbd> + <kbd>F</kbd>：切换窗口全屏扩展

---

### 3.3 桌面外壳、状态栏与启动器 (DMS / Waybar / Fuzzel)
- **外壳体系**：Dank Material Shell (DMS) 或精简版 Waybar，实时显示工作区状态、音量、电池与网络；
- **启动器**：Fuzzel（纯 C 编写的极速 Wayland 启动器，内存占用极小）；
- **截图工具**：Satty + Grim + Slurp，支持划线、马赛克与即时复制。

---

### 3.4 终端生产力套件 (Fish 4.x + Starship + Kitty / Foot + Yazi)
```bash
# 安装终端工具链
sudo pacman -S fish starship kitty foot yazi btop fastfetch

# 设置 Fish 为默认交互 Shell
chsh -s /usr/bin/fish
```

配置 `~/.config/starship.toml` 呈现柔和渐变色提示符，兼顾 Git 分支状态与命令执行耗时。

---

### 3.5 Material You 动态色彩提取与主题统合
通过工具（如 `matugen`）监听当前二次元桌面壁纸切换，自动提取基准调和色（Accent Color），实时动态生成 GTK-3.0/4.0 样式表与终端颜色映射，保持全局视觉的高度统一与舒心。

---

## 🔤 卷四：中文本地化与现代字体排版 (Localization & Typography)

### 4.1 Fcitx5 输入法在 Wayland 会话中的配置
```bash
sudo pacman -S fcitx5-im fcitx5-chinese-addons fcitx5-pinyin-zhwiki fcitx5-material-color
```

在 `~/.config/environment.d/im.conf` 中声明全局环境变量：
```ini
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
```

---

### 4.2 字体矩阵与 fontconfig 渲染规则
安装兼顾代码、常规文本与 Emoji 的开源字族：

```bash
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-fira-code ttf-liberation wqy-microhei
```

通过配置 `~/.config/fontconfig/fonts.conf`，将思源黑体（Noto Sans CJK SC）与 Fira Code 作为主字体优先回退链，彻底根绝字体发虚、中英混排错位与方块豆腐块。

---

## 🎮 卷五：游戏与生产力运行时生态 (Gaming & Productivity Runtime)

### 5.1 Multilib 32位库与 Vulkan 环境配置
编辑 `/etc/pacman.conf`，取消以下两行的注释以启用 32 位软件支持：

```ini
[multilib]
Include = /etc/pacman.d/mirrorlist
```

更新软件包数据库：
```bash
sudo pacman -Syu
```

---

### 5.2 Steam 原生与 Proton-GE 兼容层配置
```bash
sudo pacman -S steam wine-staging winetricks gamescope mangohud
```

---

### 5.3 Gamescope 144Hz 锁帧与自研独显调度实践
在 1080p @ 144Hz 高刷屏幕下，通过我们的开源工具 [`moe-game-launcher`](https://github.com/shenchuchu91-hub/moe-game-launcher) 一键调起游戏：

```bash
# 绑定 NVIDIA 独显 + 144Hz 锁帧 + FSR 锐化 + 监控启动 Windows 游戏
moe-game run -g -m /path/to/game.exe
```

---

## 🚀 卷六：自动化无损部署脚本与维护 (Automated Setup & Safety)

为便于新装机快速还原整套环境，本仓库提供类似大老师工程的自动化脚本：

```bash
# 1. 克隆指南与脚本仓库
git clone https://github.com/shenchuchu91-hub/Arch-Linux-Guide.git ~/arch-guide

# 2. 赋予执行权限并运行
cd ~/arch-guide
chmod +x scripts/arch-setup.sh
./scripts/arch-setup.sh
```

脚本在安装软件包时遵循以下约定：

- **默认不安装**：所有安装确认均为 `(y/N)`，直接回车等于跳过，避免误装一整份清单；
- **不会使用 `--noconfirm`**：pacman / yay / paru 都会停下来让你确认；
- **失败即中止**：安装出错时会打印原因和下一步建议，不再用 `|| true` 把失败吞掉；
- **驱动与可选软件单独询问**：`nvidia-open-dkms`、`broadcom-wl-dkms` 等显卡/网卡驱动，以及 `v2rayn`、`linuxqq` 这类可选应用，都不会和核心依赖一起默认安装，需要你另行确认；
- **AUR 需自查 PKGBUILD**：若系统已安装 yay 或 paru，才会询问是否安装 AUR 清单中的软件包。

### 🛡️ 核心安全准则：
- **无损软链接**：绝不硬拷贝覆盖配置；
- **智能时间戳备份**：检测到已有配置目录时，自动归档至 `~/.config_backup_时间戳/`；
- **一键回滚支持**：移除符号链接并复原备份目录即可瞬间回到初始状态。

---

## 🌸 致敬、安全守则与许可证 (Credits & Disclaimer)

### 💖 致敬与致谢 (Credits)
- **[Arch Linux](https://archlinux.org/)**：致敬最纯粹的 Linux 滚动发行版与无比强大的 ArchWiki 社区；
- **[@SHORiN-KiWATA (Shorin 大老师)](https://github.com/SHORiN-KiWATA)**：致谢大老师在 Arch Linux 中文新手教程、Niri 窗口过滤规则与自动化脚本领域的无私探索；
- **[Niri 社区](https://github.com/YaLTeR/niri)**：感谢现代 Wayland 卷轴平铺窗口管理器的创造者。

### 🛡️ 安全守则与免责提示 (Disclaimer)
本项目涉及磁盘分区、引导加载器及驱动配置等系统级操作。操作前请确保重要数据已妥善备份。完整使用安全规范请参阅全局：  
👉 **[免责声明与通用安全规范 (Disclaimer)](https://github.com/shenchuchu91-hub/disclaimer)**

---

<div align="center">

🌸 **版权与许可** 🌸  
本项目基于 [MIT License](LICENSE) 开源发布。

<sub>Designed with precision &amp; care for Arch Linux · <b>shenchuchu91-hub</b></sub>

</div>
