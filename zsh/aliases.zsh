case "${OSTYPE}" in
    darwin*)
        alias ls="ls -G -w"
        ;;
    linux*)
        alias ls="ls --color"
        ;;
esac

alias l='ls'
alias la='ls -d .*'
alias ll='ls -l'

alias gs='git status --short --branch'

alias b='bundle'
alias binit='bundle install --path .bundle/gems'
alias rinit='bundle install --path .bundle/gems && rake db:create'
alias c='code'
alias s='bundle exec rails s'

alias docker-gc='docker system prune'
alias docker-gc-with-volume='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc -e REMOVE_VOLUMES=1 spotify/docker-gc'
