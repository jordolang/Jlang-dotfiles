# 📦 Installation Guide

This guide will help you set up Jordan Lang's development environment on a fresh or existing macOS system.

## 🚀 Quick Install (Recommended)

For a **fresh Mac**, run this one-liner:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/jordolang/Jlang-dotfiles/master/setup-mac.sh)
```

This will:
- ✅ Install Xcode Command Line Tools
- ✅ Install Homebrew
- ✅ Install 150+ packages (formulae and casks)
- ✅ Set up Python, Node.js, Ruby, Rust, and Go
- ✅ Configure ZSH with Powerlevel10k
- ✅ Clone and symlink all dotfiles
- ✅ Apply macOS preferences
- ✅ Create standard directories

**Duration:** 30-60 minutes (depending on internet speed)

## 🔧 Manual Installation

If you prefer more control or have an existing setup:

### Step 1: Install Prerequisites

```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Step 2: Clone Repository

```bash
# Clone to ~/.dotfiles
git clone https://github.com/jordolang/Jlang-dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### Step 3: Backup Existing Dotfiles

```bash
# Create backup directory
mkdir -p ~/.dotfiles-backup-$(date +%Y%m%d)

# Backup existing files
cp ~/.zshrc ~/.dotfiles-backup-$(date +%Y%m%d)/ 2>/dev/null
cp ~/.p10k.zsh ~/.dotfiles-backup-$(date +%Y%m%d)/ 2>/dev/null
cp ~/.gitconfig ~/.dotfiles-backup-$(date +%Y%m%d)/ 2>/dev/null
```

### Step 4: Symlink Dotfiles

```bash
# Link main config files
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/.fzf.zsh ~/.fzf.zsh

# Link .zsh directory
rm -rf ~/.zsh
ln -sf ~/.dotfiles/.zsh ~/.zsh

# Link config directories
mkdir -p ~/.config
ln -sf ~/.dotfiles/.config/micro ~/.config/micro
```

### Step 5: Install Packages

```bash
# Install from Brewfile
brew bundle --file ~/.dotfiles/Brewfile
```

This will install all CLI tools and applications defined in the Brewfile.

### Step 6: Set ZSH as Default Shell

```bash
# Change shell to ZSH
chsh -s $(which zsh)
```

### Step 7: Restart Terminal

```bash
# Restart your terminal
exec zsh
```

## 🎨 Post-Installation

### Configure Powerlevel10k

On first launch, Powerlevel10k will guide you through configuration. Or run:

```bash
p10k configure
```

### Configure Git

Update Git with your information:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Set Up Version Managers

#### Node.js (NVM)
```bash
# Install latest Node LTS
nvm install --lts
nvm use --lts
```

#### Python (pyenv)
```bash
# Install latest Python
pyenv install 3.13
pyenv global 3.13
```

#### Ruby (rbenv)
```bash
# Install latest Ruby
rbenv install 3.3.0
rbenv global 3.3.0
```

### Create Machine-Specific Config

Create `~/.zsh/local.zsh` for machine-specific settings:

```bash
touch ~/.zsh/local.zsh
```

Example content:
```bash
# Server hostname for SSH aliases
export SERVER_HOST="my-server.local"

# Custom PATH additions
export PATH="$HOME/custom/bin:$PATH"

# Machine-specific aliases
alias work="cd ~/Work"
```

## 🔄 Updating

### Update Dotfiles

```bash
cd ~/.dotfiles
git pull
```

### Update Packages

```bash
# Update Homebrew packages
brewup

# Update npm global packages
npm update -g

# Update Rust
rustup update

# Update Python packages
pipx upgrade-all
```

## 🐛 Troubleshooting

### Issue: ZSH Configuration Not Loading

**Solution:**
```bash
# Check if .zshrc is symlinked
ls -la ~/.zshrc

# If not, create symlink
ln -sf ~/.dotfiles/.zshrc ~/.zshrc

# Reload
exec zsh
```

### Issue: Powerlevel10k Not Showing

**Solution:**
```bash
# Verify Powerlevel10k is installed
brew list powerlevel10k

# If missing, install it
brew install powerlevel10k

# Reload
exec zsh
```

### Issue: NVM Command Not Found

**Solution:**
```bash
# Verify NVM is installed
brew list nvm

# Source NVM manually
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"

# Then install Node
nvm install --lts
```

### Issue: Command Not Found (for brew packages)

**Solution:**
```bash
# Verify Homebrew is in PATH
echo $PATH | grep brew

# Add to PATH if missing (Intel Mac)
eval "$(/usr/local/bin/brew shellenv)"

# Add to PATH if missing (Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Reload
exec zsh
```

### Issue: Git Credential Helper Not Working

**Solution:**
```bash
# Install git-credential-manager
brew install git-credential-manager

# Configure Git
git config --global credential.helper manager
```

## 📋 What Gets Installed

### Homebrew Formulae (~150 packages)
- **Shell tools**: zsh, zsh-autosuggestions, zsh-syntax-highlighting, powerlevel10k
- **Modern CLI tools**: eza, bat, fd, ripgrep, fzf, zoxide
- **Dev languages**: python, node, ruby, rust, go, gcc
- **Version managers**: nvm, pyenv, rbenv
- **Containers**: docker, docker-compose, lazydocker, kubernetes-cli, helm
- **Databases**: postgresql, mysql, mongodb, redis, sqlite
- **Dev tools**: git, gh, micro, neovim, tmux, jq, yq
- **And many more...**

### Homebrew Casks (~20 applications)
- **Browsers**: Chrome, Firefox, Arc
- **Editors**: Cursor, VS Code, iTerm2, Warp, Alacritty
- **Productivity**: Obsidian, Rectangle, Maccy
- **Dev tools**: Docker Desktop, OrbStack, TablePlus, Figma
- **Fonts**: Multiple Nerd Fonts for terminal icons

### Global npm Packages
- vercel
- @modelcontextprotocol/inspector
- @modelcontextprotocol/server-github
- openclaw
- mcporter

### Python Packages (via pipx)
- youtube-dl
- black
- flake8
- pytest
- ipython

### Ruby Gems
- bundler
- cocoapods
- fastlane

### Rust Crates
- matugen

## 🎯 Directory Structure

After installation, your home directory will have:

```
~/
├── .dotfiles/               # This repository (symlinked)
│   ├── .zshrc
│   ├── .p10k.zsh
│   ├── .gitconfig
│   ├── .zsh/
│   │   ├── aliases.zsh
│   │   ├── functions.zsh
│   │   ├── menu.zsh
│   │   ├── greeting.zsh
│   │   └── local.zsh       # Create this for machine-specific config
│   └── .config/
│       └── micro/
├── .zshrc -> .dotfiles/.zshrc
├── .p10k.zsh -> .dotfiles/.p10k.zsh
├── .gitconfig -> .dotfiles/.gitconfig
├── .zsh -> .dotfiles/.zsh/
├── Repos/                   # Your projects go here
├── .config/
│   └── micro -> .dotfiles/.config/micro
└── .local/bin/              # Custom scripts
```

## 💡 Tips

1. **Use `menu`** - Interactive searchable command menu
2. **Use `commands`** - Quick reference cheatsheet
3. **Use `repo`** - Jump to any project in ~/Repos with fuzzy search
4. **Use `devinfo`** - Auto-detect project type and show relevant info
5. **Customize** - Edit `~/.zsh/local.zsh` for machine-specific settings

## 📞 Support

- 🐛 **Issues**: [GitHub Issues](https://github.com/jordolang/Jlang-dotfiles/issues)
- 📧 **Email**: jordolang@gmail.com
- 📚 **Docs**: See [README.md](README.md) for detailed documentation

## 🔐 Security Note

This setup script will:
- Install software on your system
- Modify shell configuration
- Set macOS system preferences
- Install fonts and applications

**Always review scripts before running them on your system!** You can view the setup script at:
https://github.com/jordolang/Jlang-dotfiles/blob/master/setup-mac.sh

---

Made with ❤️ by Jordan Lang
