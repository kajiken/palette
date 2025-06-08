# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal dotfiles repository called "palette" that manages development environment configuration for macOS. The repository uses a symlink-based architecture where configuration files are stored with `.symlink` extensions and then linked to their proper locations in the home directory.

## Installation Commands

- **Bootstrap entire setup**: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/kajiken/palette/master/script/bootstrap)"`
- **Install all dotfiles**: `./script/install` (runs all install.sh scripts in subdirectories)
- **Install Homebrew packages**: `brew bundle` (uses the Brewfile)

## Architecture

### Symlink System
Files ending with `.symlink` are automatically linked to `~/.{filename}` by the bootstrap script:
- `git/gitconfig.symlink` → `~/.gitconfig`
- `zsh/zshrc.symlink` → `~/.zshrc`
- `tmux/tmux.conf.symlink` → `~/.tmux.conf`
- `vim/vimrc.symlink` → `~/.vimrc`
- `ruby/gemrc.symlink` → `~/.gemrc`

### Directory Structure
- **script/**: Contains bootstrap and install scripts
- **config/**: Shared configuration files (starship.toml)
- **alfread/**: Alfred appearance themes
- **crossnote/**: CrossNote markdown editor configuration
- **gh/**: GitHub CLI configuration
- **peco/**: Interactive filtering tool configuration
- **ruby/**: Ruby configuration with gemrc
- **{tool}/**: Tool-specific directories with configs and install.sh scripts
- **Brewfile**: Homebrew package definitions

### Key Environment Variables
- `DOTFILES_REPOS`: Set to 'kajiken/palette'
- `GHQ_ROOT`: Repository root at `~/src`
- `XDG_CONFIG_HOME`: Points to the palette directory
- `ZSH`: Points to the zsh subdirectory

### Shell Configuration
The zsh setup sources multiple files:
- `zsh/aliases.zsh`: Command aliases
- `zsh/keybind.zsh`: Key bindings
- `zsh/options.zsh`: Shell options
- `zsh/lib/*.zsh`: Tool-specific configurations (nvm, rbenv, peco)

Uses Starship prompt with custom configuration in `config/starship.toml`.

## Development Tools

The Brewfile installs development tools including:
- **Languages**: go, kotlin, rust, ruby (via rbenv)
- **CLI Tools**: git, ghq, peco, mise, terraform, awscli, act, protobuf, starship, tree, vim, zsh
- **Shell Enhancements**: zsh-autosuggestions, zsh-completions, zsh-syntax-highlighting
- **Applications**: Alfred, Android Studio, AppCleaner, Dash, DeepL, Docker, Figma, Flutter, GitHub Desktop, Google Chrome, Google Cloud SDK, Google Japanese IME, Hammerspoon, Insomnia, iTerm2, Karabiner Elements, Notion, Obsidian, Slack, Visual Studio Code, Zoom
- **Fonts**: JetBrains Mono

## Configuration Management

When modifying configurations:
1. Edit the source file in the repository
2. The symlink will automatically reflect changes
3. For new symlink files, they'll be picked up by the next `./script/install` run
4. For new tools, add an `install.sh` script in the tool's directory