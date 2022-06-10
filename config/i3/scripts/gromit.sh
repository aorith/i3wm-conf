#!/bin/sh -li
# La version de flatpak funciona con los hotkeys de i3, la nativa no
# por alguna razon que no he logrado averiguar
case $1 in
    active)
                flatpak run net.christianbeier.Gromit-MPX --quit
                flatpak run net.christianbeier.Gromit-MPX --active
                ;;
    clear)      flatpak run net.christianbeier.Gromit-MPX --clear ;;
    toggle)     flatpak run net.christianbeier.Gromit-MPX --toggle ;;
    visibility) flatpak run net.christianbeier.Gromit-MPX --visibility ;;
    undo)       flatpak run net.christianbeier.Gromit-MPX --undo ;;
    redo)       flatpak run net.christianbeier.Gromit-MPX --redo ;;
    quit)       flatpak run net.christianbeier.Gromit-MPX --quit ;;
    *) ;;
esac
exit 0

case $1 in
    active)
                gromix-mpx --quit
                gromit-mpx --active
                ;;
    clear)      gromit-mpx --clear ;;
    toggle)     gromit-mpx --toggle ;;
    visibility) gromit-mpx --visibility ;;
    undo)       gromit-mpx --undo ;;
    redo)       gromit-mpx --redo ;;
    quit)       gromit-mpx --quit ;;
    *) ;;
esac
