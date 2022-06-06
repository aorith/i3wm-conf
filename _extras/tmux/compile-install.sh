#!/usr/bin/env bash
set -ex
cd "$(dirname "$0")" || exit 1

REF="3.3"

rm -rf tmux
mkdir -p "${HOME}/.local/etc/xdg"

echo "Installing dependencies..."
sudo apt install automake libevent-dev bison

git clone --depth=1 --branch="$REF" https://github.com/tmux/tmux.git
rm -rf tmux/.git
cd tmux

./autogen.sh
./configure
make
sudo make install

cd ..
rm -rf ./tmux
