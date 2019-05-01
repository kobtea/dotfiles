#!/bin/sh
if [ -x /usr/local/bin/xkeysnail ]; then
    xhost +SI:localuser:xkeysnail
    sudo -u xkeysnail DISPLAY=$DISPLAY /usr/local/bin/xkeysnail $HOME/dotfiles/xkeysnail.py
fi
