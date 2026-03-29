#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}>> Iniciando instalación de Dotfiles de Avvy...${NC}"

# 1. Lista de paquetes esenciales
PACKAGES=(
    hyprland hyprshot hyprlock hypriddle  waybar kitty rofi-wayland 
    swww pipewire wireplumber qt6-wayland 
    qt6ct ttf-font-awesome ttf-jetbrains-mono-nerd
    fastfetch dolphin grim slurp wf-recorder libnotify
)

if ! command -v yay &> /dev/null; then
    echo -e "${BLUE}>> Instalando Yay...${NC}"
    sudo pacman -S --needed base-devel git --noconfirm
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm && cd ~/dotfiles
fi

echo -e "${GREEN}>> Instalando paquetes necesarios...${NC}"
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

echo -e "${GREEN}>> Creando estructura de directorios...${NC}"
mkdir -p ~/.config

echo -e "${GREEN}>> Enlazando configuraciones...${NC}"

ln -sf ~/dotfiles/config/hypr ~/.config/
ln -sf ~/dotfiles/config/waybar ~/.config/
ln -sf ~/dotfiles/config/kitty ~/.config/
ln -sf ~/dotfiles/config/neofetch ~/.config/{

echo -e "${BLUE}>> ¡Todo listo! Reinicia Hyprland para ver los cambios.${NC}"
