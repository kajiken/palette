all: sync

sync:
	mkdir -p ~/.config/ghostty
	mkdir -p ~/.hammerspoon
	mkdir -p ~/.sheldon

	[ -f ~/.config/starship.toml ] || ln -s $(PWD)/starship.toml ~/.config/starship.toml
	[ -f ~/.config/ghostty/config ] || ln -s $(PWD)/ghostty/config ~/.config/ghostty/config
	[ -f ~/.gitconfig ] || ln -s $(PWD)/gitconfig ~/.gitconfig
	[ -f ~/.hammerspoon/init.lua ] || ln -s $(PWD)/hammerspoon/init.lua ~/.hammerspoon/init.lua
	[ -f ~/.vimrc ] || ln -s $(PWD)/vimrc ~/.vimrc
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmux/tmux.conf ~/.tmux.conf
	[ -f ~/.zprofile ] || ln -s $(PWD)/zsh/zprofile ~/.zprofile
	[ -f ~/.zshenv ] || ln -s $(PWD)/zsh/zshenv ~/.zshenv
	[ -f ~/.zshrc ] || ln -s $(PWD)/zsh/zshrc ~/.zshrc
	[ -f ~/.sheldon/plugins.toml ] || ln -s $(PWD)/zsh/plugins.toml ~/.sheldon/plugins.toml

clean:
	rm -f ~/.config/starship.toml
	rm -f ~/.config/ghostty/config
	rm -f ~/.gitconfig
	rm -f ~/.hammerspoon/init.lua
	rm -f ~/.vimrc
	rm -f ~/.tmux.conf
	rm -f ~/.zprofile
	rm -f ~/.zshenv
	rm -f ~/.zshrc
	rm -f ~/.sheldon/plugins.toml

vim-plugin:
	[ -f ~/.vim/autoload/plug.vim ] || curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim: vim-plugin

.PHONY: all clean sync
