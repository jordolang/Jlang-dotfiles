#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║        JORDAN LANG'S MAC DEVELOPMENT ENVIRONMENT SETUP            ║
# ║                                                                  ║
# ║  Reproduces the full terminal dev setup on a fresh Mac:          ║
# ║    • Homebrew + everything in ./Brewfile (arch-aware)            ║
# ║    • Node / Python / Ruby / Rust / Go toolchains                ║
# ║    • Dotfiles (zsh, p10k, git) symlinked from this repo          ║
# ║    • Claude Code CLI + `claude` / `claude-go` / `claude-cmd`     ║
# ║                                                                  ║
# ║  Works on both Apple Silicon (/opt/homebrew) and Intel           ║
# ║  (/usr/local). Safe to re-run — every step is idempotent.        ║
# ║                                                                  ║
# ║  Usage:  bash setup-mac.sh                                       ║
# ╚══════════════════════════════════════════════════════════════════╝

# Fail on unset vars and broken pipes, but NOT on any single command
# error — a flaky cask must not abort a 45-minute unattended install.
set -uo pipefail

# ── Output helpers ──────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; NC='\033[0m'
print_header()  { echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; echo -e "${CYAN}  $1${NC}"; echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error()   { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_info()    { echo -e "${CYAN}ℹ${NC} $1"; }

# ── Resolve where this script (and the Brewfile) live ───────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_REPO="https://github.com/jordolang/Jlang-dotfiles.git"

if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is for macOS only."; exit 1
fi

print_header "Jordan Lang's Mac Setup"
echo "This installs Homebrew + the full Brewfile, all language toolchains,"
echo "your dotfiles, and Claude Code. It is safe to run more than once."
echo ""
read -rp "Continue? (y/n) " -n 1 REPLY; echo
[[ "$REPLY" =~ ^[Yy]$ ]] || { print_warning "Cancelled."; exit 0; }

# ══════════════════════════════════════════════════════════════════
# 1. XCODE COMMAND LINE TOOLS
# ══════════════════════════════════════════════════════════════════
print_header "Xcode Command Line Tools"
if xcode-select -p &>/dev/null; then
    print_success "Already installed"
else
    print_info "Installing… complete the GUI prompt, then re-run this script."
    xcode-select --install
    exit 0
fi

# ══════════════════════════════════════════════════════════════════
# 2. HOMEBREW (architecture-aware)
# ══════════════════════════════════════════════════════════════════
print_header "Homebrew"

# Apple Silicon → /opt/homebrew, Intel → /usr/local
if [[ "$(uname -m)" == "arm64" ]]; then
    BREW_BIN="/opt/homebrew/bin/brew"
else
    BREW_BIN="/usr/local/bin/brew"
fi

if [[ -x "$BREW_BIN" ]]; then
    print_success "Homebrew already installed"
else
    print_info "Installing Homebrew…"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Load brew into THIS shell for the rest of the script…
eval "$("$BREW_BIN" shellenv)"

# …and persist it to ~/.zprofile so future login shells find it too.
BREW_SHELLENV="eval \"\$($BREW_BIN shellenv)\""
if ! grep -qF "$BREW_BIN shellenv" "$HOME/.zprofile" 2>/dev/null; then
    print_info "Adding Homebrew to ~/.zprofile"
    printf '\n# Homebrew\n%s\n' "$BREW_SHELLENV" >> "$HOME/.zprofile"
fi

print_info "Updating Homebrew…"
brew update

# ══════════════════════════════════════════════════════════════════
# 3. INSTALL EVERYTHING FROM THE BREWFILE
# ══════════════════════════════════════════════════════════════════
print_header "Installing packages from Brewfile"
if [[ -f "$SCRIPT_DIR/Brewfile" ]]; then
    # Homebrew 6+ refuses to load formulae from untrusted third-party taps,
    # which aborts the WHOLE bundle run. Trust every tap the Brewfile declares
    # first so bundle can proceed past them (e.g. supabase/tap, hashicorp/tap).
    while IFS= read -r line; do
        [[ "$line" =~ ^tap[[:space:]]+\"([^\"]+)\" ]] || continue
        tapname="${BASH_REMATCH[1]}"
        brew tap "$tapname" >/dev/null 2>&1 || true
        brew trust "$tapname" >/dev/null 2>&1 && print_success "trusted tap $tapname"
    done < "$SCRIPT_DIR/Brewfile"

    print_info "Running brew bundle (formulae, casks, App Store apps, VS Code extensions)…"
    # Modern Homebrew doesn't write a Brewfile.lock.json by default and has
    # dropped the --no-lock flag, so we no longer pass it.
    brew bundle install --file="$SCRIPT_DIR/Brewfile" || \
        print_warning "Some packages failed — see the summary above. Re-running the script will retry them."
    print_success "Brewfile processed"
else
    print_error "Brewfile not found next to this script ($SCRIPT_DIR/Brewfile)"
fi

# ══════════════════════════════════════════════════════════════════
# 4. DEFAULT SHELL → ZSH
# ══════════════════════════════════════════════════════════════════
print_header "Default shell"
if [[ "$SHELL" == */zsh ]]; then
    print_success "Already zsh"
else
    print_info "Switching default shell to zsh…"
    chsh -s "$(command -v zsh)" && print_success "Done (restart terminal to apply)"
fi

# ══════════════════════════════════════════════════════════════════
# 5. DOTFILES — clone (if needed) + symlink
# ══════════════════════════════════════════════════════════════════
print_header "Dotfiles"

# Prefer this repo if the script is being run from inside it; otherwise
# fall back to ~/Repos/Jlang-dotfiles, cloning if it isn't there yet.
if [[ -d "$SCRIPT_DIR/.git" ]]; then
    DOTFILES_DIR="$SCRIPT_DIR"
elif [[ -d "$HOME/Repos/Jlang-dotfiles/.git" ]]; then
    DOTFILES_DIR="$HOME/Repos/Jlang-dotfiles"
else
    print_info "Cloning dotfiles to ~/Repos/Jlang-dotfiles…"
    mkdir -p "$HOME/Repos"
    git clone "$DOTFILES_REPO" "$HOME/Repos/Jlang-dotfiles"
    DOTFILES_DIR="$HOME/Repos/Jlang-dotfiles"
fi
print_success "Using dotfiles at $DOTFILES_DIR"

# Back up anything real that we're about to replace with a symlink.
backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"
link() {  # link <source-in-repo> <target-in-home>
    local src="$DOTFILES_DIR/$1" dest="$2"
    [[ -e "$src" ]] || { print_warning "missing in repo: $1"; return; }
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        mkdir -p "$backup_dir"; cp -R "$dest" "$backup_dir/" 2>/dev/null
    fi
    mkdir -p "$(dirname "$dest")"
    ln -sfn "$src" "$dest" && print_success "linked $(basename "$dest")"
}

link ".zshrc"     "$HOME/.zshrc"
link ".p10k.zsh"  "$HOME/.p10k.zsh"
link ".gitconfig" "$HOME/.gitconfig"
link ".fzf.zsh"   "$HOME/.fzf.zsh"
link ".zsh"       "$HOME/.zsh"
link ".config/micro" "$HOME/.config/micro"
# .config/yazi is not tracked in this repo yet — add it here once it exists.

# claude-cmd lives inside ~/.claude (a directory Claude Code manages), so
# symlink JUST the one file rather than the whole directory.
if [[ -f "$DOTFILES_DIR/.claude/claude-cmd.zsh" ]]; then
    mkdir -p "$HOME/.claude"
    ln -sfn "$DOTFILES_DIR/.claude/claude-cmd.zsh" "$HOME/.claude/claude-cmd.zsh"
    print_success "linked claude-cmd.zsh"
fi

[[ -d "$backup_dir" ]] && print_info "Replaced files backed up to $backup_dir"

# ══════════════════════════════════════════════════════════════════
# 6. CLAUDE CODE CLI  →  claude / claude-go / claude-cmd
# ══════════════════════════════════════════════════════════════════
print_header "Claude Code"
if [[ -x "$HOME/.local/bin/claude" ]] || command -v claude &>/dev/null; then
    print_success "Claude Code already installed"
else
    print_info "Installing Claude Code (native installer)…"
    curl -fsSL https://claude.ai/install.sh | bash || \
        print_warning "Claude install failed — install manually: https://docs.claude.com/claude-code"
fi
# `claude` (alias), `claude-go` (alias) and `claude-cmd` (function) are all
# defined in the dotfiles: aliases in .zshrc, claude-cmd in ~/.claude/claude-cmd.zsh.
print_info "claude / claude-go / claude-cmd are provided by your dotfiles once the new shell loads."

# ══════════════════════════════════════════════════════════════════
# 7. NODE.JS  (nvm)
# ══════════════════════════════════════════════════════════════════
print_header "Node.js"
export NVM_DIR="$HOME/.nvm"; mkdir -p "$NVM_DIR"
if [[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ]]; then
    # shellcheck disable=SC1091
    . "$(brew --prefix)/opt/nvm/nvm.sh"
    print_info "Installing Node LTS + current via nvm…"
    nvm install --lts && nvm alias default 'lts/*'
    nvm install node   # latest current
    print_success "Node $(node -v 2>/dev/null) active"

    print_info "Installing global npm packages…"
    for pkg in pm2 vercel; do
        npm install -g "$pkg" >/dev/null 2>&1 && print_success "npm -g $pkg" || print_warning "npm -g $pkg failed"
    done
    corepack enable 2>/dev/null || true   # pnpm/yarn shims
else
    print_warning "nvm not found — skipping Node (is 'nvm' in the Brewfile installed?)"
fi

# ══════════════════════════════════════════════════════════════════
# 8. PYTHON  (pyenv + pipx tools)
# ══════════════════════════════════════════════════════════════════
print_header "Python"
if command -v pyenv &>/dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"; export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    print_success "pyenv ready ($(pyenv --version 2>/dev/null))"
fi
if command -v pipx &>/dev/null; then
    pipx ensurepath >/dev/null 2>&1
    print_info "Installing pipx CLI tools…"
    for pkg in black flake8 ipython pytest; do
        pipx install "$pkg" >/dev/null 2>&1 && print_success "pipx $pkg" || print_warning "pipx $pkg (already installed or failed)"
    done
fi

# ══════════════════════════════════════════════════════════════════
# 9. RUBY  (rbenv + gems)
# ══════════════════════════════════════════════════════════════════
print_header "Ruby"
if command -v rbenv &>/dev/null; then
    export RBENV_ROOT="$HOME/.rbenv"; export PATH="$RBENV_ROOT/bin:$PATH"
    eval "$(rbenv init - zsh)" 2>/dev/null || eval "$(rbenv init -)"
    latest_ruby="$(rbenv install -l 2>/dev/null | grep -vE '[a-zA-Z-]' | tail -1 | xargs)"
    if [[ -n "$latest_ruby" ]]; then
        if rbenv versions --bare 2>/dev/null | grep -qx "$latest_ruby"; then
            print_success "Ruby $latest_ruby already installed"
        else
            print_info "Installing Ruby $latest_ruby (this can take a while)…"
            rbenv install "$latest_ruby" && rbenv global "$latest_ruby"
        fi
        print_info "Installing gems (bundler, cocoapods, fastlane)…"
        gem install bundler cocoapods fastlane >/dev/null 2>&1 && print_success "gems installed" || print_warning "gem install had issues"
    fi
else
    print_warning "rbenv not found — skipping Ruby"
fi

# ══════════════════════════════════════════════════════════════════
# 10. RUST  (rustup)
# ══════════════════════════════════════════════════════════════════
print_header "Rust"
if command -v rustup &>/dev/null || [[ -x "$HOME/.cargo/bin/rustup" ]]; then
    "$HOME/.cargo/bin/rustup" update 2>/dev/null || rustup update
    print_success "Rust toolchain up to date"
else
    print_info "Installing Rust via rustup…"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    print_success "Rust installed"
fi

# ══════════════════════════════════════════════════════════════════
# 11. GIT IDENTITY
# ══════════════════════════════════════════════════════════════════
print_header "Git identity"
# .gitconfig is symlinked from the repo; only fill in name/email if unset.
if [[ -z "$(git config --global user.email 2>/dev/null)" ]]; then
    read -rp "Git name  [Jordan Lang]: " git_name;  git_name="${git_name:-Jordan Lang}"
    read -rp "Git email [jordolang@gmail.com]: " git_email; git_email="${git_email:-jordolang@gmail.com}"
    git config --global user.name  "$git_name"
    git config --global user.email "$git_email"
    print_success "Set git identity: $git_name <$git_email>"
else
    print_success "Git identity already configured ($(git config --global user.email))"
fi

# ══════════════════════════════════════════════════════════════════
# 12. STANDARD DIRECTORIES
# ══════════════════════════════════════════════════════════════════
print_header "Directories"
for d in "$HOME/Repos" "$HOME/.config" "$HOME/.local/bin"; do
    mkdir -p "$d" && print_success "$d"
done

# ══════════════════════════════════════════════════════════════════
# 13. MACOS DEFAULTS
# ══════════════════════════════════════════════════════════════════
print_header "macOS defaults"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
killall Finder 2>/dev/null || true
print_success "Applied (some changes need a logout/restart)"

# ══════════════════════════════════════════════════════════════════
# DONE
# ══════════════════════════════════════════════════════════════════
print_header "Setup complete 🎉"
cat <<'EOF'
Next steps:
  1. Restart your terminal:            exec zsh
  2. Set your terminal font to a Nerd Font (e.g. "MesloLGS NF") for the P10k prompt
  3. Sign in:  gh auth login  •  claude  •  Docker Desktop  •  App Store (for `mas`)
  4. Verify the Claude commands:
       claude --version
       claude-go        (claude with --dangerously-skip-permissions)
       claude-cmd "list files changed in the last commit"

Handy shell commands from your dotfiles: menu · commands · repo · devinfo
EOF
read -rp "Restart the shell now? (y/n) " -n 1 REPLY; echo
[[ "$REPLY" =~ ^[Yy]$ ]] && exec zsh
