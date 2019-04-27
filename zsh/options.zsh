# options
setopt complete_aliases
setopt list_packed
setopt nolistbeep
setopt no_beep
setopt no_flow_control
setopt auto_list
setopt auto_menu
setopt auto_param_slash
setopt auto_cd
setopt auto_pushd
setopt extended_history
setopt extended_glob
setopt hist_ignore_space
setopt hist_ignore_dups
setopt share_history
setopt interactive_comments
setopt list_types
setopt numeric_glob_sort
setopt rm_star_silent
setopt prompt_subst

# autoload
autoload -U compinit
compinit
autoload -Uz colors
colors

# zstyle
zstyle ':complete:*' list-colors ${(s.:.)LSCOLORS}

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
# zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-max 0
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both
