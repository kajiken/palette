#!/bin/sh

if [ ! -e $HOME/.hammerspoon ]; then
  mkdir $HOME/.hammerspoon
fi

ln -nfs $PWD/hammerspoon/init.lua $HOME/.hammerspoon/init.lua
