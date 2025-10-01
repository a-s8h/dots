#!/bin/bash

set -euo pipefail

read -p "Copy niri config? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  mkdir -p ~/.config/niri
  cp ./.config/niri/config.kdl ~/.config/niri/config.kdl
  echo "✅ Niri config copied"
else
  echo "niri: skip config"
fi

read -p "Copy waybar config? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  cp -r ./.config/waybar ~/.config/
  echo "✅ Waybar config copied"
else
  echo "waybar: skip config"
fi

read -p "Copy fuzzel config? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  cp -r ./.config/fuzzel ~/.config/
  echo "✅ Fuzzel config copied"
else
  echo "fuzzel: skip config"
fi



read -p "Copy ghostty config? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  cp -r ./.config/ghostty ~/.config/
  echo "✅ Ghostty config copied"
else
  echo "ghostty: skip config"
fi

read -p "Copy dunst config? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  cp -r ./.config/dunst ~/.config/
  echo "✅ Dunst config copied"
else
  echo "dunst: skip config"
fi

read -p "Copy btop config? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  cp -r ./.config/btop ~/.config/
  echo "✅ Btop config copied"
else
  echo "btop: skip config"
fi

read -p "Copy nvim config? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  cp -r ./.config/nvim ~/.config/
  echo "✅ Neovim config copied"
else
  echo "nvim: skip config"
fi

