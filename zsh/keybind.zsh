# keybind
bindkey -e
autoload -Uz history-serach-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^p' history-beginning-search-backward
bindkey '^n' history-beginning-search-forward
