function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "${selected_dir}" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

function peco-history-selection() {
  BUFFER=$(history -n 1 | tail -r  | awk '!a[$0]++' | peco)
  CURSOR=$#BUFFER
  zle clear-screen
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

function peco-ssh() {
  host=`grep -w Host ~/.ssh/config | awk '{print $2}' | peco --query "$LBUFFER"`

  if [ -n "${host}" ]; then
    BUFFER="ssh ${host}"
    zle accept-line
  fi
  zle clear-screen
}

zle -N peco-ssh
bindkey 'SS' peco-ssh

function peco-file() {
  local selected_file=$(rg -l . | peco)
  local file=$(echo ${selected_file} | head -n 1)
  if [ -n "${selected_file}" ]; then
    BUFFER="${EDITOR} ${selected_file}"
    zle accept-line
  fi
  zle clear-screen
}

zle -N peco-file
bindkey '^s' peco-file
