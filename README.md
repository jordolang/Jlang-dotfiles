# 🚀 Jordan Lang's Dotfiles

> **A comprehensive, battle-tested macOS development environment setup**

This repository contains my complete terminal configuration, CLI tools setup, and development environment. Designed by Claude AI and refined through daily use.

![ZSH](https://img.shields.io/badge/Shell-ZSH-89e051?style=flat-square)
![Powerlevel10k](https://img.shields.io/badge/Theme-Powerlevel10k-blue?style=flat-square)
![macOS](https://img.shields.io/badge/OS-macOS-000000?style=flat-square)

## ✨ Features

- 🎨 **Beautiful Terminal** - Powerlevel10k theme with custom configuration
- ⚡ **Fast & Efficient** - Optimized ZSH with lazy-loading and instant prompt
- 🛠️ **200+ Aliases** - Comprehensive shortcuts for Git, Docker, Kubernetes, and more
- 🔍 **Smart Navigation** - FZF-powered fuzzy finding for files, repos, and commands
- 📦 **All Dev Tools** - Python, Node, Ruby, Rust, Go, Docker, Kubernetes, Terraform
- 🎯 **Interactive Menus** - Command center with searchable command reference
- 🌈 **Syntax Highlighting** - Beautiful command highlighting with custom colors
- 🤖 **AI-Integrated** - Claude CLI and MCP server support

## 📸 Screenshots

The terminal features:
- Custom greeting with system stats
- Git-aware prompt with branch info
- Interactive command menu (`menu`)
- Searchable command cheatsheet (`commands`)
- FZF integration for everything

## 🚀 Quick Start

### One-Line Install (Fresh Mac)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/jordolang/Jlang-dotfiles/main/setup-mac.sh)
```

This will:
1. Install Xcode Command Line Tools
2. Install Homebrew + 150+ packages
3. Set up Python, Node, Ruby, Rust, Go
4. Configure ZSH with Powerlevel10k
5. Clone and link all dotfiles
6. Set macOS preferences

### Manual Installation

```bash
# Clone this repository
git clone https://github.com/jordolang/Jlang-dotfiles.git ~/.dotfiles

# Backup your existing dotfiles
mkdir -p ~/.dotfiles-backup
cp ~/.zshrc ~/.p10k.zsh ~/.gitconfig ~/.dotfiles-backup/ 2>/dev/null

# Symlink dotfiles
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/.zsh ~/.zsh

# Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages from Brewfile
brew bundle --file ~/.dotfiles/Brewfile

# Restart terminal
exec zsh
```

## 📦 What's Included

### Core Shell Configuration
- `.zshrc` - Main ZSH configuration with modular loading
- `.p10k.zsh` - Powerlevel10k theme configuration
- `.fzf.zsh` - FZF fuzzy finder integration

### Modular ZSH Configs (`.zsh/`)
- `aliases.zsh` - 200+ aliases for Git, Docker, K8s, system utilities
- `functions.zsh` - Custom shell functions (repo navigation, project scaffolding, etc.)
- `menu.zsh` - Interactive command center with FZF
- `greeting.zsh` - Custom terminal greeting with system info
- `local.zsh` - Machine-specific settings (gitignored)

### Application Configs (`.config/`)
- `micro/` - Micro text editor settings
- `yazi/` - File manager configuration
- More configs as needed

### Git Configuration
- `.gitconfig` - Git aliases, LFS, and credential helper setup

## 🎯 Key Features Breakdown

### Navigation & File Management
```bash
repo              # Jump to any project in ~/Repos (with fzf)
y                 # Yazi file browser (cd on exit)
fe                # Fuzzy find file and open in micro
fg <pattern>      # Fuzzy grep content and open
mkcd <dir>        # Make directory and cd into it
```

### Git Workflow
```bash
gs                # Git status (short)
glog              # Beautiful git log graph
gcm "message"     # Commit with message
gpush / gp        # Push / Pull with rebase
gclone <repo>     # Clone to ~/Repos and cd
gst / gstp        # Stash / Stash pop
```

### Docker & Kubernetes
```bash
dps               # List containers (formatted)
dcu / dcd         # Docker compose up/down
lzd               # Launch lazydocker TUI
k                 # kubectl shortcut
kgp / kgs         # Get pods/services
```

### Development Tools
```bash
devinfo           # Auto-detect project type and show info
venv create       # Create Python virtual environment
newproject <name> # Scaffold new project in ~/Repos
cheat <command>   # Lookup cheat.sh
gitignore <lang>  # Generate .gitignore
```

### System Utilities
```bash
myip / localip    # Show public/local IP
ports             # Show listening ports
killport <port>   # Kill process on port
brewup            # Update all Homebrew packages
weather           # Current weather
speedtest         # Quick bandwidth test
```

### Interactive Helpers
```bash
menu              # Interactive command menu (FZF)
commands          # Show all commands cheatsheet
backup            # Backup shell configs
colors256         # Show terminal color palette
```

## 🛠️ Installed Tools

### Shell & Terminal
- **ZSH** with Powerlevel10k theme
- **Zsh plugins**: autosuggestions, syntax-highlighting, completions
- **Terminals**: iTerm2, Warp, Alacritty

### Modern CLI Replacements
- `eza` → better `ls`
- `bat` → better `cat`
- `fd` → better `find`
- `ripgrep` → better `grep`
- `fzf` → fuzzy finder
- `zoxide` → smart `cd`
- `delta` → better `git diff`

### Languages & Runtimes
- **Python** 3.13, 3.14 + pyenv
- **Node.js** + nvm
- **Ruby** + rbenv
- **Rust** + cargo
- **Go**
- **PHP** + Composer
- **Bun** & Deno

### Development Tools
- **Editors**: Micro, Neovim, Cursor, VS Code
- **Git**: git, gh (GitHub CLI), git-lfs, git-flow
- **Containers**: Docker, Docker Compose, OrbStack, lazydocker
- **Orchestration**: Kubernetes (kubectl), Helm, Terraform
- **Databases**: PostgreSQL, MySQL, MongoDB, Redis, SQLite, TablePlus

### Utilities
- `tmux`, `htop`, `yazi`, `tree`, `fastfetch`
- `jq`, `yq`, `tldr`, `thefuck`
- `ollama`, `yt-dlp`, `ffmpeg`, `imagemagick`

## 📝 Customization

### Machine-Specific Settings
Create `~/.zsh/local.zsh` for machine-specific configuration:

```bash
# ~/.zsh/local.zsh (not tracked in git)

# Custom server hostname
export SERVER_HOST="my-server.local"

# Additional PATH entries
export PATH="$HOME/custom/bin:$PATH"

# Project-specific aliases
alias myproject="cd ~/Repos/my-project"
```

### Git Configuration
Update `.gitconfig` with your details:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Theme Customization
Run `p10k configure` to customize the Powerlevel10k theme interactively.

## 🔄 Keeping Updated

```bash
# Update dotfiles from GitHub
cd ~/.dotfiles
git pull

# Update Homebrew packages
brewup

# Update global npm packages
npm update -g

# Update Rust
rustup update
```

## 📚 Documentation

### Command Reference
Type `commands` in your terminal for a comprehensive cheatsheet, or `menu` for an interactive searchable menu.

### Key Bindings
- `Ctrl+R` - Search command history with FZF
- `Ctrl+T` - Fuzzy file search
- `Alt+C` - Fuzzy directory search
- `Up/Down` - Search history by prefix
- `Ctrl+Left/Right` - Jump words
- `Alt+.` - Insert last argument

## 🎨 Color Scheme
The terminal uses a custom color scheme optimized for dark backgrounds:
- **Prompt**: Blue, cyan, and lime accents
- **Syntax**: Commands (blue), aliases (cyan), paths (yellow), strings (green)
- **FZF**: Blue borders, red pointer, lime highlights
- **Git**: Yellow (modified), green (added), red (deleted)

## 🤝 Contributing

This is my personal configuration, but feel free to:
- Fork it and customize for yourself
- Open issues for bugs or questions
- Submit PRs for improvements

## 📄 License

MIT License - feel free to use, modify, and share.

## 🙏 Credits

- **Powerlevel10k**: [romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k)
- **FZF**: [junegunn/fzf](https://github.com/junegunn/fzf)
- **Zsh Plugins**: [zsh-users](https://github.com/zsh-users)
- **Design**: Created with Claude AI

## 📧 Contact

- GitHub: [@jordolang](https://github.com/jordolang)
- Email: jordolang@gmail.com

---

**⭐ If you find this useful, consider starring the repo!**

Made with ❤️ and ☕ by Jordan Lang
