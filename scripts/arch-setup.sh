#!/usr/bin/env bash
# ==============================================================================
#  🏛️ Arch Linux 自动化桌面环境与依赖配置脚本 (arch-setup.sh)
#  作者: shenchuchu91-hub
#  协议: MIT License
# ==============================================================================

set -e

C_RESET="\033[0m"
C_BOLD="\033[1m"
C_BLUE="\033[38;2;137;180;250m"
C_PINK="\033[38;2;243;139;168m"
C_GREEN="\033[38;2;166;227;161m"
C_YELLOW="\033[38;2;249;226;175m"
C_CYAN="\033[38;2;137;220;235m"

print_header() {
    echo -e "${C_BLUE}"
    cat << 'BANNER'
      /\_/\   
     ( o.o )  🏛️ Arch-Linux-Guide 自动化配置套件
      > ^ <   Pure Arch Linux · Niri Wayland · Rice Environment
BANNER
    echo -e "${C_RESET}"
}

ask_yes_no() {
    local prompt="$1"
    local reply
    read -r -p "${prompt} (y/N): " reply
    [[ "$reply" =~ ^[Yy]$ ]]
}

# 判断包名是否在列表中
in_list() {
    local needle="$1"
    shift
    local item
    for item in "$@"; do
        if [[ "$item" == "$needle" ]]; then
            return 0
        fi
    done
    return 1
}

# 安装失败时给出明确提示并退出，不再用 || true 吞掉错误
install_official() {
    if [ "$#" -eq 0 ]; then
        return 0
    fi
    echo -e "${C_BLUE}[*] 正在通过 pacman 安装（需你在提示时确认，不会自动跳过）：${C_RESET}"
    printf '    %s\n' "$@"
    if ! sudo pacman -S --needed "$@"; then
        echo -e "${C_YELLOW}[!] 官方源软件包安装失败，已中止，未继续执行后续步骤。${C_RESET}"
        echo -e "${C_YELLOW}    请检查：网络是否通畅、镜像源是否可用、包名是否仍然存在。${C_RESET}"
        echo -e "${C_YELLOW}    建议先执行：sudo pacman -Syu${C_RESET}"
        echo -e "${C_YELLOW}    确认无误后再重新运行本脚本。${C_RESET}"
        exit 1
    fi
}

install_aur() {
    local helper="$1"
    shift
    if [ "$#" -eq 0 ]; then
        return 0
    fi
    echo -e "${C_BLUE}[*] 正在通过 ${helper} 安装 AUR 软件包（需你在提示时确认）：${C_RESET}"
    echo -e "${C_YELLOW}[!] AUR 软件包由社区维护、默认未经官方审查。安装前请自行检查 PKGBUILD。${C_RESET}"
    printf '    %s\n' "$@"
    if ! "$helper" -S --needed "$@"; then
        echo -e "${C_YELLOW}[!] AUR 软件包安装失败，已中止，未继续执行后续步骤。${C_RESET}"
        echo -e "${C_YELLOW}    请检查 PKGBUILD、网络与 AUR 助手本身是否正常，然后再重新运行本脚本。${C_RESET}"
        exit 1
    fi
}

print_header

# 1. 环境校验
if [ ! -f /etc/arch-release ]; then
    echo -e "${C_YELLOW}[!] 警告：当前系统未检测到 /etc/arch-release，本脚本专为 Arch Linux 设计。${C_RESET}"
    if ! ask_yes_no "是否仍然继续？"; then
        exit 1
    fi
fi

echo -e "${C_CYAN}[*] 系统环境校验通过 (Arch Linux x86_64)。${C_RESET}\n"

# 2. 检查并准备 dotfiles
DOTFILES_DIR="$HOME/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${C_BLUE}[*] 正在克隆核心 dotfiles 仓库...${C_RESET}"
    git clone https://github.com/shenchuchu91-hub/dotfiles.git "$DOTFILES_DIR"
else
    echo -e "${C_GREEN}[✔] 检测到本地已存在 dotfiles 仓库: ${DOTFILES_DIR}${C_RESET}"
fi

# 硬件驱动与可选软件：从核心列表中拆出，改为单独询问
NVIDIA_PKGS=(nvidia-open-dkms nvidia-settings nvidia-utils lib32-nvidia-utils)
NIC_PKGS=(broadcom-wl-dkms linux-firmware-broadcom b43-fwcutter linux-firmware-marvell linux-firmware-qcom linux-firmware-qlogic)
OPTIONAL_APPS=(v2rayn linuxqq linuxqq-wayland-fix-git)

# 3. 解析官方源清单并分类
CORE_PKGS=()
FOUND_NVIDIA=()
FOUND_NIC=()
FOUND_OPTIONAL=()

if [ -f "$DOTFILES_DIR/pkglist-native.txt" ]; then
    while IFS= read -r raw || [ -n "$raw" ]; do
        raw="${raw%%#*}"
        read -r pkg _ <<< "$raw"
        [[ -z "$pkg" ]] && continue
        if in_list "$pkg" "${NVIDIA_PKGS[@]}"; then
            FOUND_NVIDIA+=("$pkg")
        elif in_list "$pkg" "${NIC_PKGS[@]}"; then
            FOUND_NIC+=("$pkg")
        elif in_list "$pkg" "${OPTIONAL_APPS[@]}"; then
            FOUND_OPTIONAL+=("$pkg")
        else
            CORE_PKGS+=("$pkg")
        fi
    done < "$DOTFILES_DIR/pkglist-native.txt"
fi

echo -e "\n${C_BOLD}>>> 是否需要安装系统核心依赖软件包？${C_RESET}"
echo -e "包含：niri、wayland、pipewire、fcitx5、字体、fish、starship、kitty、foot、yazi 等。"
echo -e "默认不安装。显卡/网卡驱动以及 v2rayn、linuxqq 等可选软件会在后面单独询问。"
if ask_yes_no "是否现在安装系统核心依赖包？"; then
    if [ "${#CORE_PKGS[@]}" -gt 0 ]; then
        install_official "${CORE_PKGS[@]}"
    else
        echo -e "${C_YELLOW}[!] 未找到 ${DOTFILES_DIR}/pkglist-native.txt，或清单为空，已跳过官方源核心包安装。${C_RESET}"
    fi
else
    echo -e "${C_CYAN}[*] 已跳过核心依赖包安装。${C_RESET}"
fi

# 3b. 显卡 / 网卡驱动（按需询问，默认否）
if [ "${#FOUND_NVIDIA[@]}" -gt 0 ]; then
    echo -e "\n${C_BOLD}>>> 可选：NVIDIA 显卡驱动${C_RESET}"
    echo -e "清单中的相关包：${FOUND_NVIDIA[*]}"
    echo -e "仅在你确认为 NVIDIA 显卡，并且需要专有/开源 DKMS 驱动时再安装。"
    if ask_yes_no "是否安装 NVIDIA 显卡驱动？"; then
        install_official "${FOUND_NVIDIA[@]}"
    else
        echo -e "${C_CYAN}[*] 已跳过 NVIDIA 显卡驱动。${C_RESET}"
    fi
fi

if [ "${#FOUND_NIC[@]}" -gt 0 ]; then
    echo -e "\n${C_BOLD}>>> 可选：网卡驱动与厂商固件${C_RESET}"
    echo -e "清单中的相关包：${FOUND_NIC[*]}"
    echo -e "例如 broadcom-wl-dkms 仅适用于部分 Broadcom 网卡，装错可能影响无线网络。"
    if ask_yes_no "是否安装网卡驱动与相关厂商固件？"; then
        install_official "${FOUND_NIC[@]}"
    else
        echo -e "${C_CYAN}[*] 已跳过网卡驱动与厂商固件。${C_RESET}"
    fi
fi

# 3c. 可选应用
if [ "${#FOUND_OPTIONAL[@]}" -gt 0 ]; then
    echo -e "\n${C_BOLD}>>> 可选：额外应用（v2rayn、linuxqq 等）${C_RESET}"
    echo -e "清单中的相关包：${FOUND_OPTIONAL[*]}"
    if ask_yes_no "是否安装这些可选应用？"; then
        install_official "${FOUND_OPTIONAL[@]}"
    else
        echo -e "${C_CYAN}[*] 已跳过可选应用。${C_RESET}"
    fi
fi

# 3d. AUR 软件包
AUR_HELPER=""
if command -v yay >/dev/null 2>&1; then
    AUR_HELPER="yay"
elif command -v paru >/dev/null 2>&1; then
    AUR_HELPER="paru"
fi

AUR_PKGS=()
if [ -f "$DOTFILES_DIR/pkglist-aur.txt" ]; then
    while IFS= read -r raw || [ -n "$raw" ]; do
        raw="${raw%%#*}"
        read -r pkg _ <<< "$raw"
        [[ -z "$pkg" ]] && continue
        AUR_PKGS+=("$pkg")
    done < "$DOTFILES_DIR/pkglist-aur.txt"
fi

if [ "${#AUR_PKGS[@]}" -gt 0 ]; then
    echo -e "\n${C_BOLD}>>> 是否安装 AUR 社区扩展包？${C_RESET}"
    echo -e "来源：${DOTFILES_DIR}/pkglist-aur.txt"
    if [ -n "$AUR_HELPER" ]; then
        echo -e "检测到 AUR 助手：${AUR_HELPER}。安装过程中请自行检查 PKGBUILD。"
        if ask_yes_no "是否现在安装 AUR 软件包？"; then
            install_aur "$AUR_HELPER" "${AUR_PKGS[@]}"
        else
            echo -e "${C_CYAN}[*] 已跳过 AUR 软件包安装。${C_RESET}"
        fi
    else
        echo -e "${C_YELLOW}[!] 未检测到 yay 或 paru，已跳过 AUR 软件包。如需安装，请先自行配置 AUR 助手后再运行本脚本。${C_RESET}"
    fi
fi

# 4. 执行无损软链接安装
echo -e "\n${C_BLUE}[*] 正在调用 dotfiles 安全部署流程...${C_RESET}"
if [ -f "$DOTFILES_DIR/install.sh" ]; then
    chmod +x "$DOTFILES_DIR/install.sh"
    (cd "$DOTFILES_DIR" && ./install.sh)
fi

# 5. 完成提示
echo -e "\n${C_GREEN}✔ Arch Linux 桌面环境与基础配置已成功就绪！${C_RESET}"
echo -e "${C_CYAN}推荐下一步：${C_RESET}"
echo -e "  1. 启动 Niri 会话：在登录管理器中选择 Niri，或在 tty 运行 ${C_BOLD}niri-session${C_RESET}"
echo -e "  2. 查阅完整指南：${C_BLUE}https://github.com/shenchuchu91-hub/Arch-Linux-Guide${C_RESET}\n"
