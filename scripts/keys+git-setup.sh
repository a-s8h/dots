#!/bin/bash

set -e

read -p "email:" EMAIL
read -p "full name:" FNAME

ssh-keygen -t ed25519 -C $EMAIL

echo "Your public key:"
cat ~/.ssh/id_ed25519.pub 

git config --global user.email "$EMAIL"
git config --global user.name "$FNAME"
