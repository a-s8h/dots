#!/bin/bash

set -euo pipefail


read -p "Copy niri config? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  mkdir ~/.config/niri
  cp ./.config/niri/config.kdl ~/.config/niri/config.kdl
else
  echo "niri: skip config"
fi


read -p "Copy swaync config? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  cp -r ./.config/swaync ~/.config/
else
  echo "swaync: skip config"
fi

read -p "Copy waybar config? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  cp -r ./.config/waybar ~/.config/
else
  echo "waybar: skip config"
fi

read -p "Copy fuzzel config? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  cp -r ./.config/fuzzel ~/.config/
else
  echo "fuzzel: skip config"
fi

read -p "Copy networkmanager-dmenu config? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  cp -r ./.config/networkmanager-dmenu ~/.config/
else
  echo "networkmanager-dmenu: skip config"
fi

read -p "Copy ghostty config? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  mkdir ~/.config/ghostty/
  cp ./.config/ghostty/config ~/.config/ghostty/config
else
  echo "ghostty: skip config"
fi

read -p "Copy btop config? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  cp -r ./.config/btop ~/.config/
else
  echo "btop: skip config"
fi

read -p "Copy nvim config? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  cp -r ./.config/nvim ~/.config/
else
  echo "nvim: skip config"
fi

