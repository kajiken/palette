all: sync

sync:
	mkdir -p ~/.config/ghostty
	mkdir -p ~/.claude

	[ -f ~/.config/starship.toml ] || ln -s $(PWD)/starship.toml ~/.config/starship.toml
	[ -f ~/.config/ghostty/config ] || ln -s $(PWD)/ghostty/config ~/.config/ghostty/config

clean:
	rm -f ~/.config/starship.toml
	rm -f ~/.config/ghostty/config

.PHONY: all sync clean
