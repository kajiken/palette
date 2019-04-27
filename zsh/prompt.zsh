# vim:ft=zsh ts=2 sw=2 sts=2

prompt_git() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    local -a messages
    local prompt

    setopt promptsubst
    autoload -Uz vcs_info
    autoload -Uz is-at-least

    zstyle ':vcs_info:*' max-exports 3
    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr "%F{green}+"
    zstyle ':vcs_info:git:*' unstagedstr "%F{red}-"
    zstyle ':vcs_info:*' formats "%F{blue}%s:%F{white}(%b) %u%c%m"
    zstyle ':vcs_info:*' actionformats "%F{blue}%s:(%b|%a) %u%c%m"

    if is-at-least 4.3.11; then
      # http://qiita.com/mollifier/items/8d5a627d773758dd8078
      zstyle ':vcs_info:git+set-message:*' hooks \
                                              git-not-pushed

      function +vi-git-not-pushed() {
        if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) = 'true' ]]; then
          head="$(git rev-parse HEAD)"
          for x in $(git rev-parse --remotes)
          do
            if [ "$head" = "$x" ]; then
              return 0
            fi
          done
          hook_com[misc]+="%F{196}?"
        fi
        return 0
      }
    fi

    LANG=en_US.UTF-8 vcs_info

    [[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{green}${vcs_info_msg_0_}%f" )
    [[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
    [[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )

    prompt="${(j: :)messages}"

    echo -n " ${prompt}"
  fi
}

prompt_lambda() {
  echo -n "%F{blue}λ "
}

# Dir: current working directory
prompt_dir() {
  echo -n '%F{white}%.'
}

prompt_end() {
  echo -n "%{%k%}"
  echo -n " %F{216}✘%{%f%}"
}

build_prompt() {
  RETVAL=$?
  prompt_lambda
  prompt_dir
  prompt_git
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '
