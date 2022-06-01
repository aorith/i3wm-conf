#!/usr/bin/env bash
set -ex
cd "$(dirname "$0")" || exit 1

rm -rf dunst
mkdir -p "${HOME}/.local/etc/xdg"

echo "Installing dependencies..."
sudo apt install libnotify-dev libxss-dev libxdg-basedir-dev libxinerama-dev libxft-dev libcairo2-dev libxrandr-dev libpango1.0-dev

git clone --depth=1 https://github.com/dunst-project/dunst.git
rm -rf dunst/.git
cd dunst

export WAYLAND=0
export PREFIX="${HOME}/.local"

make
make install

cd ..
rm -rf ./dunst
