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
    cat << 'EOF'
      /\_/\   
     ( o.o )  🏛️ Arch-Linux-Guide 自动化配置套件
      > ^ <   Pure Arch Linux · Niri Wayland · Rice Environment
EOF
    echo -e "${C_RESET}"
}

print_header

# 1. 环境校验
if [ ! -f /etc/arch-release ]; then
    echo -e "${C_YELLOW}[!] 警告：当前系统未检测到 /etc/arch-release，本脚本专为 Arch Linux 设计。${C_RESET}"
    read -p "是否仍然继续？(y/N): " CONFIRM
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
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

# 3. 询问是否安装依赖软件包
echo -e "\n${C_BOLD}>>> 是否需要自动安装系统核心依赖软件包？${C_RESET}"
echo -e "包含：niri, wayland, pipewire, fcitx5, fonts, fish, starship, kitty, foot, yazi 等。"
read -p "是否现在安装系统依赖包？(Y/n): " INSTALL_PKGS
if [[ ! "$INSTALL_PKGS" =~ ^[Nn]$ ]]; then
    if [ -f "$DOTFILES_DIR/pkglist-native.txt" ]; then
        echo -e "${C_BLUE}[*] 正在通过 pacman 安装官方源核心包...${C_RESET}"
        sudo pacman -S --needed --noconfirm - < "$DOTFILES_DIR/pkglist-native.txt" || true
    fi

    # 检查 AUR 助手
    AUR_HELPER=""
    if command -v yay >/dev/null 2>&1; then
        AUR_HELPER="yay"
    elif command -v paru >/dev/null 2>&1; then
        AUR_HELPER="paru"
    fi

    if [ -n "$AUR_HELPER" ] && [ -f "$DOTFILES_DIR/pkglist-aur.txt" ]; then
        echo -e "${C_BLUE}[*] 检测到 AUR 助手 (${AUR_HELPER})，正在安装 AUR 社区扩展包...${C_RESET}"
        $AUR_HELPER -S --needed --noconfirm - < "$DOTFILES_DIR/pkglist-aur.txt" || true
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
