#!/usr/bin/env bash
set -e

# ========================
# USER AND LOCALE SETTINGS
# ========================
USER_NAME="ashinkevich"  
LOCALE_DEFAULT="en_US.UTF-8"
LOCALE_RU="ru_RU.UTF-8"
TIMEZONE="Europe/Minsk"

echo "=== Updating system ==="
sudo xbps-install -Syu

echo "=== Checking what's already configured ==="
echo "Current timezone: $(readlink /etc/localtime | sed 's|/usr/share/zoneinfo/||' || echo 'not set')"
echo "Current locale: $(grep '^LANG=' /etc/locale.conf 2>/dev/null | cut -d= -f2 || echo 'not set')"
echo "DHCP service: $([ -L /var/service/dhcpcd ] && echo 'enabled' || echo 'not enabled')"
echo "User groups: $(groups ${USER_NAME:-$USER} 2>/dev/null || echo 'user not found')"

echo "=== Installing base packages ==="
sudo xbps-install -Sy \
  glibc-locales \              # Required for locale generation
  curl \                       # Required for downloading in apps.sh
  jq \                         # JSON processor, required for Zig installation in apps.sh
  tar \                        # Archive extraction, required for Zig installation
  iwd \                        # Minimal Wi-Fi daemon, allows TUI control via iwctl
  pipewire wireplumber libspa-bluetooth \  # Modern audio server + Bluetooth support
  bluez \                      # Bluetooth daemon
  dbus \                       # System D-Bus for IPC (required by PipeWire, Bluetooth)
  wireguard-tools \             # CLI tools for WireGuard VPN
  chrony                       # NTP client to sync system time

echo "=== Enabling services ==="
# Enable essential services with runit
sudo ln -sf /etc/sv/dbus /var/service       # D-Bus daemon
# Check if dhcpcd is already enabled for wired network
if [ ! -L /var/service/dhcpcd ]; then
  sudo ln -sf /etc/sv/dhcpcd /var/service   # Wired network DHCP (if not already enabled)
fi
sudo ln -sf /etc/sv/iwd /var/service        # Wi-Fi daemon
sudo ln -sf /etc/sv/bluetoothd /var/service # Bluetooth daemon
sudo ln -sf /etc/sv/chronyd /var/service    # Time sync
sudo ln -sf /etc/sv/fstrim /var/service     # Periodic SSD trim

echo "=== Adding user to groups ==="
# Use current user if USER_NAME doesn't exist
target_user="${USER_NAME:-$USER}"
if id "$target_user" &>/dev/null; then
  sudo usermod -aG wheel,audio,video,bluetooth,input "$target_user"
  echo "User $target_user added to groups: wheel,audio,video,bluetooth,input"
else
  echo "Warning: User $target_user not found. Skipping group assignment."
fi
echo "Check sudo permissions: run 'sudo visudo' and ensure '%wheel ALL=(ALL) ALL' is uncommented"

echo "=== Configuring locales ==="
# Add Russian locale if missing (en_US.UTF-8 usually already available)
if ! grep -q "^$LOCALE_RU" /etc/locale.gen 2>/dev/null; then
  echo "$LOCALE_RU UTF-8" | sudo tee -a /etc/locale.gen
  sudo locale-gen
fi

# Set default locale if not already set
current_locale=$(grep '^LANG=' /etc/locale.conf 2>/dev/null | cut -d= -f2 || echo "")
if [ "$current_locale" != "$LOCALE_DEFAULT" ]; then
  echo "LANG=$LOCALE_DEFAULT" | sudo tee /etc/locale.conf
fi

echo "=== Setting timezone ==="
# Set timezone if not already correct
current_tz=$(readlink /etc/localtime | sed 's|/usr/share/zoneinfo/||')
if [ "$current_tz" != "$TIMEZONE" ]; then
  sudo ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
  sudo sv restart chronyd 2>/dev/null || true
fi

echo "=== Configuring PipeWire ==="
# ALSA → PipeWire for audio compatibility
sudo mkdir -p /etc/alsa/conf.d
if [ -f /usr/share/alsa/alsa.conf.d/50-pipewire.conf ]; then
  sudo ln -sf /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d/
fi
if [ -f /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf ]; then
  sudo ln -sf /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d/
fi

# PulseAudio emulation for apps expecting pulseaudio API
sudo mkdir -p /etc/pipewire/pipewire.conf.d
if [ -f /usr/share/examples/pipewire/20-pipewire-pulse.conf ]; then
  sudo ln -sf /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
fi

echo "=== Restarting services ==="
sudo sv restart dbus || true
[ -L /var/service/dhcpcd ] && sudo sv restart dhcpcd || true
sudo sv restart iwd || true
sudo sv restart bluetoothd || true
sudo sv restart chronyd || true
sudo sv restart fstrim || true

echo "=== Wi-Fi and WireGuard instructions ==="
echo "Wi-Fi via iwctl (TUI):"
echo "  iwctl -> device list -> station wlan0 scan -> station wlan0 get-networks -> station wlan0 connect <SSID>"

echo "WireGuard:"
echo "  sudo wg-quick up wg0"
echo "  sudo wg-quick down wg0"

echo "=== Done! Reboot system to apply all changes ==="
