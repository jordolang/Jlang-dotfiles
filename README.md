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
- 🤖 **AI-Integrated** - Claude Code (`claude`, `claude-go`, `claude-cmd`), Codex, opencode, gemini-cli

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
bash <(curl -fsSL https://raw.githubusercontent.com/jordolang/Jlang-dotfiles/master/setup-mac.sh)
```

The setup script is **architecture-aware** — it works on both Apple Silicon
(`/opt/homebrew`) and Intel (`/usr/local`) Macs — and every step is
idempotent, so it's safe to re-run. It will:

1. Install Xcode Command Line Tools
2. Install Homebrew + everything in the [`Brewfile`](Brewfile) (~140 dev-core packages) via `brew bundle`
3. Set up Node (nvm), Python (pyenv), Ruby (rbenv), Rust (rustup), and Go
4. Symlink all dotfiles and configure ZSH with Powerlevel10k
5. Install Claude Code and wire up the `claude` / `claude-go` / `claude-cmd` commands
6. Apply macOS preferences

> The `Brewfile` is a curated **dev-core** subset. A complete snapshot of the
> source machine (every formula, cask, and App Store app — including niche and
> beta apps) lives in [`Brewfile.full`](Brewfile.full) if you ever want the full mirror.

### Manual Installation

```bash
# Clone this repository (the setup script uses ~/Repos/Jlang-dotfiles)
git clone https://github.com/jordolang/Jlang-dotfiles.git ~/Repos/Jlang-dotfiles
cd ~/Repos/Jlang-dotfiles

# Backup your existing dotfiles
mkdir -p ~/.dotfiles-backup
cp ~/.zshrc ~/.p10k.zsh ~/.gitconfig ~/.fzf.zsh ~/.dotfiles-backup/ 2>/dev/null

# Symlink dotfiles
ln -sf "$PWD/.zshrc"     ~/.zshrc
ln -sf "$PWD/.p10k.zsh"  ~/.p10k.zsh
ln -sf "$PWD/.gitconfig" ~/.gitconfig
ln -sf "$PWD/.fzf.zsh"   ~/.fzf.zsh
ln -sfn "$PWD/.zsh"      ~/.zsh
mkdir -p ~/.claude && ln -sf "$PWD/.claude/claude-cmd.zsh" ~/.claude/claude-cmd.zsh

# Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages from Brewfile
brew bundle --file "$PWD/Brewfile"

# Install Claude Code
curl -fsSL https://claude.ai/install.sh | bash

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

### Package Manifests & Setup
- `Brewfile` - Curated dev-core package list (`brew bundle`)
- `Brewfile.full` - Complete machine snapshot (full mirror)
- `setup-mac.sh` - Idempotent, architecture-aware bootstrap script
- `.claude/claude-cmd.zsh` - The `claude-cmd` shell function (symlinked to `~/.claude/`)

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

### Claude Code (AI)
```bash
claude                      # Launch Claude Code (~/.local/bin/claude)
claude-go                   # Claude Code with --dangerously-skip-permissions
claude-cmd "<request>"      # One-shot: print a single shell command for a request
claude-cmd -c "<request>"   # …and copy it to the clipboard (pbcopy)
```
- `claude` and `claude-go` are aliases defined in `.zshrc`.
- `claude-cmd` is a shell function loaded from `~/.claude/claude-cmd.zsh`
  (tracked in this repo at `.claude/claude-cmd.zsh` and symlinked by the setup
  script). It asks Claude for exactly one shell command and prints nothing else.

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
- **Python** 3.11 / 3.13 / 3.14 + pyenv, pipx, uv
- **Node.js** + nvm (pnpm, corepack)
- **Ruby** + rbenv
- **Rust** + rustup / cargo
- **Go**
- **PHP** + Composer
- **mise** — polyglot version manager (asdf-compatible)

### Development Tools
- **Editors**: Micro, Neovim, Cursor, VS Code, Zed
- **Git**: git, gh (GitHub CLI), git-lfs, git-flow, git-delta, gitleaks
- **Containers**: Docker, Docker Compose, Colima, OrbStack, lazydocker
- **Orchestration**: Kubernetes (kubectl), Helm, Terraform, Ansible
- **Databases**: PostgreSQL, MySQL, MongoDB (atlas-cli), Redis, Supabase, TablePlus
- **AI/dev**: Claude Code, Codex, opencode, gemini-cli, ollama, semgrep

### Utilities
- `tmux`, `htop`, `yazi`, `tree`, `fastfetch`
- `jq`, `yq`, `tldr`, `thefuck`, `just`, `cheat`
- `ffmpeg`, `imagemagick`, `pandoc`, `tesseract`

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
cd ~/Repos/Jlang-dotfiles
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
