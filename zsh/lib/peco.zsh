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

function peco-devtree() {
  # Load devtree configuration to ensure DEVTREE_DEFAULT_PATH is set
  if [[ -f "$HOME/.devtreerc" ]]; then
    source "$HOME/.devtreerc"
  fi

  local devtree_path="${DEVTREE_DEFAULT_PATH:-$HOME/.devtree/worktrees}"

  # Expand tilde and resolve relative paths
  devtree_path="${devtree_path/#\~/$HOME}"
  local resolved_devtree_path="$(cd "${devtree_path}" 2>/dev/null && pwd)"

  if [ ! -d "${resolved_devtree_path}" ]; then
    echo "Error: DEVTREE_DEFAULT_PATH directory does not exist: ${devtree_path}"
    if [[ -n "$ZLE_STATE" ]]; then
      zle clear-screen
    fi
    return 1
  fi

  local dirs=()
  while IFS= read -r dir; do
    dirs+=("${dir#${resolved_devtree_path}/}")
  done < <(find "${resolved_devtree_path}" -maxdepth 1 -type d -not -path "${resolved_devtree_path}" | sort)
  local selected_dir=$(printf '%s\n' "${dirs[@]}" | peco --query "$LBUFFER")

  if [ -n "${selected_dir}" ]; then
    if [[ -n "$ZLE_STATE" ]]; then
      BUFFER="cd ${resolved_devtree_path}/${selected_dir}"
      zle accept-line
    else
      cd "${resolved_devtree_path}/${selected_dir}"
    fi
  fi
  if [[ -n "$ZLE_STATE" ]]; then
    zle clear-screen
  fi
}

# The peco-devtree widget is intended to be invoked via the `dtcd` alias and does not require a key binding.
zle -N peco-devtree
