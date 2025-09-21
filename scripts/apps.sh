#!/bin/bash
set -euo pipefail

### ---------- Base utilities ----------
sudo xbps-install -Sy \
    curl git ripgrep fzf btop jq

### ---------- NVIDIA + Vulkan ----------
sudo xbps-install -Sy \
    nvidia nvidia-dkms nvidia-libs \
    mesa vulkan-loader vulkan-tools

echo "✅ Base utilities and NVIDIA/Vulkan installed. Reboot recommended if driver installed."

### ---------- Wayland / Niri ----------
read -p "Install Niri WM and related Wayland tools? (y/n) " CONT
if [ "$CONT" = "y" ]; then
    sudo xbps-install -Sy \
        niri waybar fuzzel swaybg swaylock \
        swayidle papirus-icon-theme wl-clipboard \
        playerctl dunst xwayland-satellite \
        seatd
    sudo usermod -aG seat "$USER"
else
    echo "Skip Niri and Wayland environment"
fi

### ---------- Rust ----------
read -p "Install Rust (rustup)? (y/n) " CONT
if [ "$CONT" = "y" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    mkdir -p ~/.local/bin
    curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz \
        | gunzip -c - > ~/.local/bin/rust-analyzer
    chmod +x ~/.local/bin/rust-analyzer
else
    echo "Rust: skip"
fi

### ---------- Node.js ----------
read -p "Install NVM and Node.js? (y/n) " CONT
if [ "$CONT" = "y" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    . "$HOME/.nvm/nvm.sh"
    read -p "Enter major Node version (e.g. 20): " NV
    nvm install "$NV"
    npm install -g typescript typescript-language-server
else
    echo "Node.js: skip"
fi

### ---------- Neovim ----------
read -p "Install Neovim? (y/n) " CONT
if [ "$CONT" = "y" ]; then
    sudo xbps-install -Sy neovim
else
    echo "Neovim: skip"
fi

### ---------- Ghostty ----------
read -p "Install Ghostty (y/n) " CONT
if [ "$CONT" = "y" ]; then
    sudo xbps-install -Sy ghostty
    echo "Ghostty installed: $(ghostty --version 2>/dev/null || echo 'ok')"
else
    echo "Ghostty: skip"
fi

### ---------- Zig (latest master) ----------
read -p "Install latest Zig master? (y/n) " CONT
if [ "$CONT" = "y" ]; then
    mkdir -p "$HOME/.local/zig" "$HOME/.local/bin"

    JSON=$(curl -fsSL "https://ziglang.org/download/index.json")
    TARBALL_URL=$(echo "$JSON" | jq -r '.master["x86_64-linux"].tarball')

    if [ -z "$TARBALL_URL" ]; then
        echo "ERROR: Could not find Zig master tarball URL in index.json" >&2
        exit 1
    fi

    echo "Downloading Zig from: $TARBALL_URL"
    TMP=/tmp/zig.tar.xz
    curl -L "$TARBALL_URL" -o "$TMP"

    rm -rf "$HOME/.local/zig"/*
    tar -xf "$TMP" -C "$HOME/.local/zig" --strip-components=1
    rm -f "$TMP"
    ln -sf "$HOME/.local/zig/zig" "$HOME/.local/bin/zig"

    echo "Zig installed: $($HOME/.local/bin/zig version)"
else
    echo "Zig: skip"
fi

echo "✅ Installation complete."
echo "If NVIDIA driver was installed, reboot is recommended."

