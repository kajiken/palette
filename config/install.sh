#!/bin/sh

if [ ! -e $HOME/.config ]; then
  mkdir -p $HOME/.config
fi

ln -s $PWD/config/starship.toml $HOME/.config/starship.toml
