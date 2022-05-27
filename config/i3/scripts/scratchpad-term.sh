#!/bin/bash

_classname="scratchpad.tmux"
if ! xdotool search --classname "$_classname" >/dev/null 2>&1 ; then
    xterm -bg '#212121' -fs 12 -name "$_classname"
else
    i3-msg "[instance=\"$_classname\"] scratchpad show" >/dev/null 2>&1
fi
