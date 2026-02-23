#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║        JORDAN LANG'S MAC DEVELOPMENT ENVIRONMENT SETUP           ║
# ║                                                                  ║
# ║  This script installs all CLI tools, development environments,  ║
# ║  and configurations needed to replicate Jordan's dev setup.     ║
# ║                                                                  ║
# ║  Usage: bash setup-mac.sh                                        ║
# ╚══════════════════════════════════════════════════════════════════╝

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only."
    exit 1
fi

print_header "Jordan Lang's Mac Setup Script"
echo "This will install:"
echo "  • Homebrew + all formulae and casks"
echo "  • Python, Node, Ruby, Rust, Go toolchains"
echo "  • Docker, Kubernetes, Terraform tools"
echo "  • ZSH with Powerlevel10k theme"
echo "  • All CLI utilities and dev tools"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Setup cancelled."
    exit 0
fi

# ══════════════════════════════════════════════════════════════════
# 1. XCODE COMMAND LINE TOOLS
# ══════════════════════════════════════════════════════════════════
print_header "Installing Xcode Command Line Tools"
if xcode-select -p &>/dev/null; then
    print_success "Xcode Command Line Tools already installed"
else
    print_info "Installing Xcode Command Line Tools..."
    xcode-select --install
    print_warning "Please complete the Xcode installation and re-run this script."
    exit 0
fi

# ══════════════════════════════════════════════════════════════════
# 2. HOMEBREW
# ══════════════════════════════════════════════════════════════════
print_header "Installing Homebrew"
if command -v brew &>/dev/null; then
    print_success "Homebrew already installed"
    print_info "Updating Homebrew..."
    brew update
else
    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    print_success "Homebrew installed"
fi

# ══════════════════════════════════════════════════════════════════
# 3. HOMEBREW FORMULAE (CLI tools)
# ══════════════════════════════════════════════════════════════════
print_header "Installing Homebrew Formulae"

# Core utilities
formulae=(
    # Shell & Terminal
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    powerlevel10k
    bash
    bash-completion@2
    
    # Modern CLI replacements
    eza          # Better ls
    bat          # Better cat
    fd           # Better find
    ripgrep      # Better grep
    fzf          # Fuzzy finder
    zoxide       # Smart cd
    delta        # Better git diff
    
    # File managers & viewers
    yazi
    tree
    htop
    fastfetch
    
    # Text editors
    micro
    neovim
    
    # Version control
    git
    git-lfs
    git-delta
    git-flow
    gh           # GitHub CLI
    
    # Languages & compilers
    python@3.13
    python@3.14
    node
    go
    rust
    gcc
    
    # Version managers
    nvm          # Node version manager
    pyenv        # Python version manager
    rbenv        # Ruby version manager
    ruby-build
    
    # Package managers
    composer     # PHP
    cocoapods    # iOS
    pnpm
    
    # Build tools
    cmake
    make
    automake
    autoconf
    libtool
    pkg-config
    
    # Container & orchestration
    docker
    docker-compose
    docker-completion
    lazydocker
    kubernetes-cli
    helm@3
    terraform
    ansible
    
    # Databases
    postgresql@14
    mysql
    mariadb
    redis
    mongodb-community
    mongodb-atlas-cli
    mongodb-database-tools
    mongosh
    sqlite
    
    # Cloud & DevOps
    wget
    curl
    rsync
    aria2
    rclone
    
    # Development utilities
    jq           # JSON processor
    yq           # YAML processor
    tldr         # Simplified man pages
    thefuck      # Command correction
    terminal-notifier
    trash
    
    # Media & image processing
    ffmpeg
    imagemagick
    
    # Network tools
    nmap
    telnet
    netcat
    
    # Compression
    unzip
    xz
    zstd
    
    # Misc dev tools
    ollama
    tmux
    multitail
    lolcat
    figlet
    mas          # Mac App Store CLI
    yt-dlp       # YouTube downloader
    
    # Specific tools from your setup
    try-rs
    deno
    bun
    uv
    pipx
    yamllint
    tidy-html5
    tesseract
    
    # Homebrew management
    brew-cleanup-go
)

for formula in "${formulae[@]}"; do
    if brew list --formula | grep -q "^${formula}\$"; then
        print_success "$formula already installed"
    else
        print_info "Installing $formula..."
        brew install "$formula" || print_warning "Failed to install $formula"
    fi
done

# ══════════════════════════════════════════════════════════════════
# 4. HOMEBREW CASKS (Applications)
# ══════════════════════════════════════════════════════════════════
print_header "Installing Homebrew Casks"

casks=(
    # Browsers
    google-chrome
    firefox
    arc
    
    # Development
    cursor           # AI code editor
    visual-studio-code
    iterm2
    warp
    alacritty
    docker-desktop
    orbstack
    
    # Design & Creative
    figma
    
    # Communication
    whatsapp
    telegram
    messenger
    
    # Productivity
    obsidian
    notion
    rectangle        # Window management
    maccy           # Clipboard manager
    
    # Database tools
    tableplus
    
    # API & Network
    postman
    
    # Utilities
    keka            # Archive manager
    vlc
    the-unarchiver
    appcleaner
    
    # Fonts (Nerd Fonts for terminal)
    font-fira-code-nerd-font
    font-jetbrains-mono-nerd-font
    font-meslo-lg-nerd-font
    font-hack-nerd-font
    font-sauce-code-pro-nerd-font
    font-roboto-mono-nerd-font
    font-inconsolata-nerd-font
    font-ubuntu-mono-nerd-font
)

print_info "Installing casks (this may take a while)..."
for cask in "${casks[@]}"; do
    if brew list --cask | grep -q "^${cask}\$"; then
        print_success "$cask already installed"
    else
        print_info "Installing $cask..."
        brew install --cask "$cask" 2>/dev/null || print_warning "Failed to install $cask (may require manual installation)"
    fi
done

# ══════════════════════════════════════════════════════════════════
# 5. SET ZSH AS DEFAULT SHELL
# ══════════════════════════════════════════════════════════════════
print_header "Setting ZSH as default shell"
if [[ "$SHELL" == */zsh ]]; then
    print_success "ZSH is already the default shell"
else
    print_info "Changing default shell to ZSH..."
    chsh -s "$(which zsh)"
    print_success "Default shell changed to ZSH (restart terminal to apply)"
fi

# ══════════════════════════════════════════════════════════════════
# 6. PYTHON SETUP
# ══════════════════════════════════════════════════════════════════
print_header "Setting up Python environment"

# Install pipx packages
print_info "Installing Python packages via pipx..."
pipx_packages=(
    "youtube-dl"
    "black"
    "flake8"
    "pytest"
    "ipython"
)

for pkg in "${pipx_packages[@]}"; do
    if pipx list | grep -q "$pkg"; then
        print_success "$pkg already installed"
    else
        print_info "Installing $pkg..."
        pipx install "$pkg" || print_warning "Failed to install $pkg"
    fi
done

# ══════════════════════════════════════════════════════════════════
# 7. NODE.JS SETUP
# ══════════════════════════════════════════════════════════════════
print_header "Setting up Node.js environment"

# Load NVM
export NVM_DIR="$HOME/.nvm"
if [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
    source "/usr/local/opt/nvm/nvm.sh"
elif [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
    source "/opt/homebrew/opt/nvm/nvm.sh"
fi

# Install latest Node LTS
if command -v nvm &>/dev/null; then
    print_info "Installing Node.js LTS via NVM..."
    nvm install --lts
    nvm use --lts
    print_success "Node.js LTS installed"
else
    print_warning "NVM not found, skipping Node installation via NVM"
fi

# Install global npm packages
print_info "Installing global npm packages..."
npm_packages=(
    "vercel"
    "npm"
    "node-gyp"
    "@modelcontextprotocol/inspector"
    "@modelcontextprotocol/server-github"
    "openclaw"
    "mcporter"
)

for pkg in "${npm_packages[@]}"; do
    print_info "Installing $pkg..."
    npm install -g "$pkg" || print_warning "Failed to install $pkg"
done

# ══════════════════════════════════════════════════════════════════
# 8. RUBY SETUP
# ══════════════════════════════════════════════════════════════════
print_header "Setting up Ruby environment"

if command -v rbenv &>/dev/null; then
    export RBENV_ROOT="$HOME/.rbenv"
    export PATH="$RBENV_ROOT/bin:$PATH"
    eval "$(rbenv init - zsh)"
    
    # Install latest stable Ruby
    print_info "Installing latest stable Ruby..."
    latest_ruby=$(rbenv install -l | grep -v - | tail -1 | xargs)
    if rbenv versions | grep -q "$latest_ruby"; then
        print_success "Ruby $latest_ruby already installed"
    else
        rbenv install "$latest_ruby"
        rbenv global "$latest_ruby"
        print_success "Ruby $latest_ruby installed and set as global"
    fi
    
    # Install common gems
    print_info "Installing common Ruby gems..."
    gem install bundler cocoapods fastlane
else
    print_warning "rbenv not found, skipping Ruby setup"
fi

# ══════════════════════════════════════════════════════════════════
# 9. RUST SETUP
# ══════════════════════════════════════════════════════════════════
print_header "Setting up Rust environment"

if command -v cargo &>/dev/null; then
    print_success "Rust already installed"
    print_info "Updating Rust..."
    rustup update
else
    print_info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    print_success "Rust installed"
fi

# Install Rust tools
print_info "Installing Rust-based tools..."
cargo install matugen || print_warning "Failed to install matugen"

# ══════════════════════════════════════════════════════════════════
# 10. RESTORE DOTFILES FROM GITHUB
# ══════════════════════════════════════════════════════════════════
print_header "Restoring dotfiles"

DOTFILES_REPO="https://github.com/jordolang/Jlang-dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

print_info "Cloning dotfiles repository..."
if [ -d "$DOTFILES_DIR" ]; then
    print_warning "Dotfiles directory already exists, pulling latest changes..."
    cd "$DOTFILES_DIR"
    git pull
else
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# Backup existing files
print_info "Backing up existing dotfiles..."
backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

files_to_backup=(
    "$HOME/.zshrc"
    "$HOME/.p10k.zsh"
    "$HOME/.gitconfig"
    "$HOME/.fzf.zsh"
)

for file in "${files_to_backup[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "$backup_dir/"
        print_success "Backed up $(basename $file)"
    fi
done

# Restore dotfiles
print_info "Restoring dotfiles from repository..."
if [ -d "$DOTFILES_DIR" ]; then
    # Link main dotfiles
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
    ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
    
    # Link .zsh directory
    rm -rf "$HOME/.zsh"
    ln -sf "$DOTFILES_DIR/.zsh" "$HOME/.zsh"
    
    # Link config directories (if they exist in dotfiles)
    if [ -d "$DOTFILES_DIR/.config/micro" ]; then
        ln -sf "$DOTFILES_DIR/.config/micro" "$HOME/.config/micro"
    fi
    
    if [ -d "$DOTFILES_DIR/.config/yazi" ]; then
        ln -sf "$DOTFILES_DIR/.config/yazi" "$HOME/.config/yazi"
    fi
    
    print_success "Dotfiles restored and symlinked"
else
    print_warning "Dotfiles directory not found, skipping restoration"
    print_info "You can manually clone the repository later: git clone $DOTFILES_REPO ~/.dotfiles"
fi

# ══════════════════════════════════════════════════════════════════
# 11. CREATE DIRECTORIES
# ══════════════════════════════════════════════════════════════════
print_header "Creating standard directories"

directories=(
    "$HOME/Repos"
    "$HOME/.config"
    "$HOME/.local/bin"
)

for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        print_success "$(basename $dir) already exists"
    else
        mkdir -p "$dir"
        print_success "Created $dir"
    fi
done

# ══════════════════════════════════════════════════════════════════
# 12. CONFIGURE GIT
# ══════════════════════════════════════════════════════════════════
print_header "Configuring Git"

read -p "Enter your Git name (default: Jordan Lang): " git_name
git_name=${git_name:-"Jordan Lang"}

read -p "Enter your Git email (default: jordolang@gmail.com): " git_email
git_email=${git_email:-"jordolang@gmail.com"}

git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global core.editor micro

print_success "Git configured with name: $git_name and email: $git_email"

# ══════════════════════════════════════════════════════════════════
# 13. MACOS DEFAULTS
# ══════════════════════════════════════════════════════════════════
print_header "Setting macOS defaults"

print_info "Configuring macOS preferences..."

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Trackpad: enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

print_success "macOS defaults configured"
print_info "Some changes require a restart to take effect"

# ══════════════════════════════════════════════════════════════════
# 14. FINAL STEPS
# ══════════════════════════════════════════════════════════════════
print_header "Setup Complete!"

echo ""
print_success "Your Mac development environment has been set up successfully!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal (or run: exec zsh)"
echo "  2. Run 'p10k configure' to customize your prompt"
echo "  3. Sign in to your accounts (GitHub, Docker, etc.)"
echo "  4. Review and customize your .zshrc if needed"
echo ""
echo "Useful commands:"
echo "  • 'commands' - Show command cheatsheet"
echo "  • 'menu' - Interactive command menu"
echo "  • 'repo' - Jump to a project"
echo "  • 'devinfo' - Show project information"
echo ""
print_info "Your old dotfiles have been backed up to: $backup_dir"
echo ""
print_warning "Some applications may require manual configuration or login."
echo ""

read -p "Would you like to restart the terminal now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    exec zsh
fi
