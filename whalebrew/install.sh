#!/bin/sh

declare -a packages=(
whalebrew/jq
whalebrew/node
whalebrew/npm
whalebrew/the_silver_searcher
whalebrew/curl
hashicorp/terraform
hashicorp/packer
kajiken/go
kajiken/tree
)

info () {
  printf "\r  \033[00;34m>>>\033[0m $1\n"
}

for package in ${packages[@]}
do
  info "Installing ${package}"
  whalebrew install ${package}
done
