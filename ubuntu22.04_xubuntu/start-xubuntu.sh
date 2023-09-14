#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

export XKL_XMODMAP_DISABLE=1 # disable keyboard layout switching

export XDG_DATA_DIRS="/usr/share/xfce4:/usr/share/xubuntu:/usr/local/share:/usr/share:/var/lib/snapd/desktop:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg/xdg-xubuntu:/etc/xdg"

export LANG=en_US.UTF-8
export GDM_LANG=en_US.UTF-8
export DESKTOP_SESSION=xubuntu
export GDMSESSION=xubuntu
export XDG_SESSION_DESKTOP=xubuntu
PATH=/usr/local/bin:/usr/bin:/usr/sbin

[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources

# propagate to X sessions. It is important when user first
# login, they decide on the initial xfce/xubuntu template settings.
dbus-update-activation-environment --verbose XDG_DATA_DIRS XDG_CONFIG_DIRS DESKTOP_SESSION GDMSESSION XDG_SESSION_DESKTOP


xset s noblank &
xset s off &
xsetroot -solid grey

tigervncconfig -iconic &
exec startxfce4

