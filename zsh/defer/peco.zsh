# Check if required commands exist
if ! command -v peco &> /dev/null; then
  echo "Warning: peco is not installed"
  return 1
fi

function peco-src () {
  if ! command -v ghq &> /dev/null; then
    echo "Error: ghq is not installed"
    zle reset-prompt
    return 1
  fi

  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${(q)selected_dir}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N peco-src
bindkey '^]' peco-src

function peco-history-selection() {
  BUFFER=$(history -n 1 | tail -r  | awk '!a[$0]++' | peco)
  CURSOR=$#BUFFER
  zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

function peco-file() {
  if ! command -v rg &> /dev/null; then
    echo "Error: ripgrep (rg) is not installed"
    zle reset-prompt
    return 1
  fi

  local selected_file=$(rg --files | peco)
  if [ -n "$selected_file" ]; then
    BUFFER="${EDITOR:-vim} ${(q)selected_file}"
    zle accept-line
  fi
  zle reset-prompt
}

zle -N peco-file
bindkey '^s' peco-file
