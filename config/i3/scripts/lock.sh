#!/usr/bin/env bash
img_path="${HOME}/.config/i3/scripts/overlay.png"
clean() {
    xset dpms 0 0 0
}
red=$(printf '%02d' "$(( RANDOM % 99 ))")
green=$(printf '%02d' "$(( RANDOM % 99 ))")
blue=$(printf '%02d' "$(( RANDOM % 99 ))")
trap revert HUP INT TERM
xset +dpms dpms 5 5 5
i3lock -e -p default -t -i "$img_path" --color=$red$green$blue
clean
