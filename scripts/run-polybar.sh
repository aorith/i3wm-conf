#!/bin/bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do
    killall -q polybar
    sleep 1
done

polybar -c ~/.config/i3/polybar.conf example
