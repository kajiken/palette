#!/bin/sh

if [ ! -e $HOME/.hammerspoon ]; then
  mkdir $HOME/.hammerspoon
fi

ln -s $PWD/init.lua $HOME/.hammerspoon/init.lua
