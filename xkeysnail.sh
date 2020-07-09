#!/bin/sh
# to restart manually, Alt + F2
if [ -x /usr/local/bin/xkeysnail ]; then
    xhost +SI:localuser:xkeysnail
    sudo -u xkeysnail DISPLAY=$DISPLAY /usr/local/bin/xkeysnail --watch --quiet $HOME/dotfiles/xkeysnail.py
fi
