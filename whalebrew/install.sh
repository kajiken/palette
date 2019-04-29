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

# Check for Whalebrew
if test ! $(which whalebrew)
then
  echo "  Installing Whalebrew."
  curl -L "https://github.com/whalebrew/whalebrew/releases/download/0.1.0/whalebrew-$(uname -s)-$(uname -m)" -o /usr/local/bin/whalebrew
  chmod +x /usr/local/bin/whalebrew
fi

for package in ${packages[@]}
do
  info "Installing ${package}"
  whalebrew install -f ${package}
done
