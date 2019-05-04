#!/bin/sh

declare -a packages=(
whalebrew/jq
whalebrew/the_silver_searcher
whalebrew/curl
hashicorp/terraform
hashicorp/packer
enogulabs/go
enogulabs/tree
enogulabs/node
enogulabs/npm
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

if test ! $(docker version --format '{{.Server.Version}}')
then
  exit 0
fi

echo 'start package install'

for package in ${packages[@]}
do
  info "Installing ${package}"
  whalebrew install -f ${package}
done
