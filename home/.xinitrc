#!/bin/sh

export XDG_CURRENT_DESKTOP="i3:xfce"
export XDG_SESSION_DESKTOP="i3:xfce"
export XDG_CURRENT_SESSION="i3:xfce"
export XDG_SESSION_TYPE="X11"

xrdb -merge ~/.config/Xresources/Xresources
xset r rate 300 36 || exit 26
xset fp rehash || exit 26
xsetroot -cursor_name left_ptr || exit 26

# NOTE: Logitech MX Keys FN keys can be switched by pressing fn+ESC
#xmodmap - <<EOF
#clear lock
#keycode 66 = Home
#EOF

#autocutsel -fork &
autorandr -c

if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
    eval "$(dbus-launch --exit-with-session --sh-syntax)" || exit 26
fi
if command -v dbus-update-activation-environment >/dev/null; then
    dbus-update-activation-environment DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE
fi
if command -v systemctl >/dev/null; then
    systemctl --user import-environment DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE
fi

if command -v systemd-cat >/dev/null; then
    # Connect stdout to the journal
    systemd-cat --identifier=i3wm i3
else
    exec i3
fi

if command -v systemctl >/dev/null; then
  # this teardown makes it easier to switch between compositors
  unset DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE
  systemctl --user unset-environment DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE
fi
