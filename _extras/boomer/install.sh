#!/usr/bin/env bash
set -eo pipefail
cd "$(dirname -- "$0")"

# https://github.com/tsoding/boomer

rm -rf ./boomer
git clone --depth 1 "https://github.com/tsoding/boomer.git" boomer

echo "Installing dependencies..."
sudo apt install nim libgl1-mesa-dev libx11-dev libxext-dev libxrandr-dev

FLAGS='-d:live' # doesn't work with nvidia
FLAGS=
cd boomer
nimble build $FLAGS
cp boomer ~/.local/bin/
cd ..
rm -rf boomer
