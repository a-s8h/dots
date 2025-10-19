#!/bin/bash

set -eou pipefail

read -p "Run initial void linux script?" CONT
if [ "$CONT" = "y" ]; then
    bash ./scripts/initial-void.sh
else
    echo "Initial void linux: skip"
fi

read -p "Install apps (y/n)?" CONT
if [ "$CONT" = "y" ]; then
    bash ./scripts/apps.sh
else
    echo "Install apps: skip"
fi

read -p "Set configs (y/n)?" CONT
if [ "$CONT" = "y" ]; then
    bash ./scripts/copy-configs.sh
else
    echo "Install apps: skip"
fi

read -p "Genereate keys and set git settings (y/n)?" CONT
if [ "$CONT" = "y" ]; then
    bash ./scripts/keys+git-setup.sh
else
    echo "Keys and git: skip"
fi
