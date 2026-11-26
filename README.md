<p align="center">
  <img src="./assets/banner.jpg" width="100%" alt="" />
</p>

<p align="center"><sub>雨还在下</sub></p>

# Arch 安装笔记

从 U 盘进 Live 环境，分区，装系统，配驱动，最后到 niri。这是自己机器上记下来的，磁盘名、显卡和你的不一样就停。分区之前先备份。

装好系统之后的桌面配置在 [dotfiles](https://github.com/shenchuchu91-hub/dotfiles)。系统进不去看 [Arch-Disaster-Recovery](https://github.com/shenchuchu91-hub/Arch-Disaster-Recovery)。

## 目录

1. [U 盘和 BIOS](#1-u-盘和-bios)
2. [联网](#2-联网)
3. [分区](#3-分区)
4. [装基础包](#4-装基础包)
5. [进新系统](#5-进新系统)
6. [GRUB](#6-grub)
7. [用户和网络](#7-用户和网络)
8. [电源](#8-电源)
9. [NVIDIA 双显卡](#9-nvidia-双显卡)
10. [声音和蓝牙](#10-声音和蓝牙)
11. [niri](#11-niri)
12. [中文和字体](#12-中文和字体)
13. [游戏](#13-游戏)
14. [装好后的脚本](#14-装好后的脚本)

## 1. U 盘和 BIOS

1. 从 [Arch 官方](https://archlinux.org/download/) 下 ISO。
2. 用 Ventoy，或：

```bash
sudo dd bs=4M if=archlinux-*.iso of=/dev/sdX status=progress oflag=sync
```

`sdX` 换成 U 盘，不要写成硬盘。

3. BIOS 里关掉 Secure Boot。硬盘模式用 AHCI / NVMe，不要用 Intel RST / RAID。从 U 盘的 UEFI 项启动。

## 2. 联网

```bash
iwctl
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "你的WiFi名称"
exit

ping -c 3 archlinux.org
timedatectl set-ntp true
```

有线一般会自己拿到地址。时间不对的话，后面下包会因为证书失败。

## 3. 分区

先 `lsblk`。下面的 `nvme0n1` 只是例子。

```text
分区 1   1024 MB   FAT32   EFI    挂到 /boot
分区 2   剩下      Ext4 或 Btrfs  挂到 /
```

```bash
cfdisk /dev/nvme0n1

mkfs.vfat -F 32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2

mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

格式化会清掉那个分区上的东西。盘符看错就没了。

## 4. 装基础包

```bash
reflector --country China --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

pacstrap -K /mnt base base-devel linux-zen linux-firmware intel-ucode btrfs-progs e2fsprogs git nano vim
```

`linux-zen` 是给桌面用的内核。AMD 的机器把 `intel-ucode` 换成 `amd-ucode`。

## 5. 进新系统

```bash
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "arch-laptop" > /etc/hostname
cat << 'EOF' > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch-laptop.localdomain arch-laptop
EOF

passwd
```

主机名 `arch-laptop` 随便改，三处一起改。

## 6. GRUB

还在 chroot 里。

```bash
pacman -S grub efibootmgr os-prober ntfs-3g

sed -i 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch

LANGUAGE=en_US.UTF-8 grub-mkconfig -o /boot/grub/grub.cfg
```

`os-prober` 用来让菜单里出现 Windows。中文终端下 `grub-mkconfig` 有时会因为字符集中断，所以前面加了 `LANGUAGE=en_US.UTF-8`。

## 7. 用户和网络

```bash
useradd -m -G wheel -s /bin/bash <你的用户名>
passwd <你的用户名>

sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

pacman -S networkmanager systemd-resolved openssh
systemctl enable NetworkManager
systemctl enable systemd-resolved

exit
umount -R /mnt
reboot
```

`sudoers` 用 `visudo` 改更稳。上面这行是直接替换注释，改完看一眼文件。

## 8. 电源

重启后用刚建的普通用户登录。

```bash
sudo pacman -S power-profiles-daemon acpid
sudo systemctl enable power-profiles-daemon
sudo systemctl enable acpid
```

微码如果第 4 步没装，Intel 装 `intel-ucode`，AMD 装 `amd-ucode`，然后 `sudo mkinitcpio -P`，再生成一次 GRUB 菜单。

## 9. NVIDIA 双显卡

核显负责平时，游戏交给独显。下面按 zen 内核写。不是 NVIDIA 就不要装这些。

```bash
sudo pacman -S linux-zen-headers nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader
```

`/etc/mkinitcpio.conf` 的 `MODULES` 里加上：

```text
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

```bash
echo "options nvidia_drm modeset=1 fbdev=1" | sudo tee /etc/modprobe.d/nvidia.conf
sudo mkinitcpio -P

sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service
```

这三行是为了睡眠唤醒后不是黑屏。

## 10. 声音和蓝牙

```bash
sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber pavucontrol
systemctl --user enable --now pipewire pipewire-pulse wireplumber

sudo pacman -S bluez bluez-utils steam-devices
sudo systemctl enable --now bluetooth
```

## 11. niri

窗口横着排，不把屏幕切成越来越小的格子。配置在 [dotfiles](https://github.com/shenchuchu91-hub/dotfiles)：

```text
~/.config/niri/
├── config.kdl
├── layout.kdl
├── animations.kdl
├── blur.kdl
└── shorin-windowrules.kdl
```

`shorin-windowrules.kdl` 里是微信、QQ 这类窗口的浮动规则，整理自 [SHORiN-KiWATA](https://github.com/SHORiN-KiWATA)。

| 键 | 做什么 |
| --- | --- |
| Super + Return | 终端 |
| Super + D | 启动器 Fuzzel |
| Super + H / L | 左右移 |
| Super + Q | 关窗口 |
| Super + F | 全屏 |

外壳用 Dank Material Shell 或 Waybar。截图是 Satty + Grim + Slurp。

```bash
sudo pacman -S fish starship kitty foot yazi btop fastfetch
chsh -s /usr/bin/fish
```

壁纸变了之后，`matugen` 会从壁纸取一个颜色，写到 GTK 和终端。不需要可以不装。

## 12. 中文和字体

```bash
sudo pacman -S fcitx5-im fcitx5-chinese-addons fcitx5-pinyin-zhwiki fcitx5-material-color
```

`~/.config/environment.d/im.conf`：

```ini
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
```

```bash
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-fira-code ttf-liberation wqy-microhei
```

## 13. 游戏

`/etc/pacman.conf` 里打开：

```ini
[multilib]
Include = /etc/pacman.d/mirrorlist
```

```bash
sudo pacman -Syu
sudo pacman -S steam wine-staging winetricks gamescope mangohud
```

独显加锁帧：

```bash
moe-game run -g -m /path/to/game.exe
```

脚本在 [moe-game-launcher](https://github.com/shenchuchu91-hub/moe-game-launcher)。

## 14. 装好后的脚本

```bash
git clone https://github.com/shenchuchu91-hub/Arch-Linux-Guide.git ~/arch-guide
cd ~/arch-guide
chmod +x scripts/arch-setup.sh
./scripts/arch-setup.sh
```

脚本用软链接。已有的配置会先挪到 `~/.config_backup_时间戳/`。要退回去，删掉链接，把备份挪回来。

## 致谢

- [Arch Linux](https://archlinux.org/) 和 ArchWiki
- [SHORiN-KiWATA](https://github.com/SHORiN-KiWATA) 的 niri 窗口规则和安装脚本
- [niri](https://github.com/YaLTeR/niri)

本仓库 [MIT](LICENSE)。磁盘、引导、驱动写错会进不了系统。命令对不上自己的机器就停。

<p align="center"><sub>雨还在下</sub></p>
