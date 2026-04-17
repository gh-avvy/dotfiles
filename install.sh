#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}>> Iniciando instalación de Dotfiles...${NC}"

# 1. Lista de paquetes (Repos oficiales y AUR)
PACKAGES=(
    hyprland hyprshot hyprlock hypriddle waybar kitty rofi-wayland 
    swww pipewire wireplumber qt6-wayland 
    qt6ct ttf-font-awesome ttf-jetbrains-mono-nerd
    fastfetch grim slurp wf-recorder libnotify blueman
    pavucontrol network-manager-applet brightnessctl btop
    spacefm-gtk3 xdg-desktop-portal-hyprland visual-studio-code-bin
    cava yazi cmatrix
)

# 2. Instalación de Yay si no existe
if ! command -v yay &> /dev/null; then
    echo -e "${BLUE}>> Instalando Yay...${NC}"
    sudo pacman -S --needed base-devel git --noconfirm
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm && cd - || return
fi

echo -e "${GREEN}>> Instalando paquetes necesarios...${NC}"
yay -S --needed --noconfirm "${PACKAGES[@]}"

# 3. INSTALACIÓN MANUAL (Apps que no están en AUR/Pacman)
# Ejemplo: Supongamos que quieres instalar una app llamada "miproyecto"
APPS_MANUALES=(
    ""
)

echo -e "${BLUE}>> Instalando aplicaciones manuales...${NC}"
for repo in "${APPS_MANUALES[@]}"; do
    repo_name=$(basename "$repo" .git)
    if [ ! -d "/tmp/$repo_name" ]; then
        echo -e "${BLUE}>> Clonando $repo_name...${NC}"
        git clone "$repo" "/tmp/$repo_name"
        cd "/tmp/$repo_name"
        
        # Aquí defines cómo se instala. 
        # Si tiene un PKGBUILD:
        if [ -f "PKGBUILD" ]; then
            makepkg -si --noconfirm
        # Si es C puro (necesita make):
        elif [ -f "Makefile" ]; then
            make && sudo make install
        fi
        cd - || return
    fi
done

# 4. Enlaces simbólicos
echo -e "${GREEN}>> Enlazando configuraciones...${NC}"
mkdir -p ~/.config
ln -sf ~/dotfiles/config/hypr ~/.config/
ln -sf ~/dotfiles/config/waybar ~/.config/
ln -sf ~/dotfiles/config/kitty ~/.config/
ln -sf ~/dotfiles/config/btop ~/.config/
ln -sf ~/dotfiles/config/yazi ~/.config/

if [ -d ~/dotfiles/config/fastfetch ]; then
    ln -sf ~/dotfiles/config/fastfetch ~/.config/
fi

echo -e "${BLUE}>> ¡Todo listo! Reinicia Hyprland para ver los cambios.${NC}"
