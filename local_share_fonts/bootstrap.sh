#!/usr/bin/env bash

set -e

cd ~/.local/share/fonts || exit 1

URLS=(
    "https://github.com/be5invis/Iosevka/releases/download/v15.3.1/ttf-iosevka-aile-15.3.1.zip"
    "https://github.com/be5invis/Iosevka/releases/download/v15.3.1/ttc-sgr-iosevka-fixed-15.3.1.zip"
)

for url in ${URLS[@]}; do
    echo "$url"
    curl --fail -L -o ./fonts.zip "$url" && unzip -u -o fonts.zip && rm -f fonts.zip
done

fc-cache -f
