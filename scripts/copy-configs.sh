#!/bin/bash

set -euo pipefail
read -p "Copy niri config? (y/n)" CONT
if [ "$CONT" = "y" ]; then
  mkdir ~/.config/niri
  cp ./.config/niri/config.kdl ~/.config/niri/config.kdl
else
  echo "Niri: skip config"
fi
