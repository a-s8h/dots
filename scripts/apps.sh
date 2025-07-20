#!/bin/bash

set -euo pipefail

sudo dnf install curl
sudo dnf install git

# browser
read -p "install Zen browser (y/n)?" CONT
if [ "$CONT" = "y" ]; then
  bash <(curl -s https://updates.zen-browser.app/install.sh)
else
  echo "zen browser: skip";
fi

# programming languages
read -p "install Rustup and rust(y/n)?" CONT
if [ "$CONT" = "y" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
  echo "Rust: skip";
fi

read -p "NVM and node (y/n)?" CONT
if [ "$CONT" = "y" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  \. "$HOME/.nvm/nvm.sh"
  read -p "Node major version?" NV
  nvm install $NV 
else
  echo "Node: skip";
fi

read -p "Install zig (y/n)?" CONT
if [ "$CONT" = "y" ]; then
  sudo dnf install zig
else
  echo "Zig: skip";
fi

# dev tools
read -p "Install nvim (y/n)?" CONT
if [ "$CONT" = "y" ]; then
  sudo dnf install --setopt=install_weak_deps=False nvim
else
  echo "NVIM: skip"
fi

# communication
read -p "Install flatpacked Slack (y/n)?" CONT
if [ "$CONT" = "y" ]; then
  flatpak install flathub com.slack.Slack
else
  echo "Slack: skip"
fi

read -p "Install flatpacked Telegram (y/n)?" CONT
if [ "$CONT" = "y" ]; then
  flatpak install flathub org.telegram.desktop
else
  echo "Telegram: skip"
fi

# command-line tools and tty
read -p "Install ghostty (y/n)?" CONT
if [ "$CONT" = "y" ]; then
  sudo dnf copr enable scottames/ghostty
  sudo dnf install ghostty
else
  echo "NVIM: skip"
fi

sudo dnf install ripgrep
sudo dnf install fzf

# desktop management
read -p "Install niri wm and desktop command line tools? (y/n)?" CONT
if [ "$CONT" = "y" ]; then
  sudo dnf copr enable yalter/niri-git
  echo "priority=1" | sudo tee -a /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:yalter:niri-git.repo
  sudo dnf install niri
  sudo dnf install waybar
  sudo dnf install swaybg
  sudo dnf install swaylock
  sudo dnf install wl-clipboard
else
  echo "Skip WM and related tools"
end

