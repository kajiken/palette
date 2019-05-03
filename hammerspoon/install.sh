#!/bin/sh

if [ ! -e $HOME/.hammerspoon ]; then
  mkdir $HOME/.hammerspoon
fi

ln -s $PWD/hammerspoon/init.lua $HOME/.hammerspoon/init.lua
