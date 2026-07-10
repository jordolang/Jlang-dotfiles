#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║        JORDAN LANG'S MAC DEVELOPMENT ENVIRONMENT SETUP            ║
# ║                                                                  ║
# ║  Reproduces a comprehensive terminal dev setup on a fresh Mac:   ║
# ║    • Homebrew + everything in the repo Brewfile (arch-aware)     ║
# ║    • Node/Python/Ruby/Rust/Go/Java/PHP/Elixir... toolchains        ║
# ║    • Dotfiles (zsh, p10k, git) symlinked from this repo          ║
# ║    • Claude Code CLI + `claude` / `claude-go` / `claude-cmd`     ║
# ║                                                                  ║
# ║  Works on Apple Silicon (/opt/homebrew) and Intel (/usr/local),  ║
# ║  whether run from a local file OR piped:                         ║
# ║      bash <(curl -fsSL .../main/setup-mac.sh)                    ║
# ║  Safe to re-run - every step is idempotent.                     ║
# ╚══════════════════════════════════════════════════════════════════╝

# Fail on unset vars and broken pipes, but NOT on any single command
# error - a flaky cask must not abort a long unattended install.
set -uo pipefail

# ── Output helpers ──────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; NC='\033[0m'
print_header()  { echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; echo -e "${CYAN}  $1${NC}"; echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error()   { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_info()    { echo -e "${CYAN}ℹ${NC} $1"; }

# ── Repo coordinates ────────────────────────────────────────────────
DOTFILES_REPO="https://github.com/jordolang/Jlang-dotfiles.git"
DOTFILES_DIR="$HOME/Repos/Jlang-dotfiles"
BRANCH="main"
REPO_RAW="https://raw.githubusercontent.com/jordolang/Jlang-dotfiles/$BRANCH"

if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is for macOS only."; exit 1
fi

print_header "Jordan Lang's Mac Setup"
echo "Installs Homebrew + a comprehensive dev toolchain (languages, version"
echo "managers, databases, containers, cloud CLIs, and terminal tools), your"
echo "dotfiles, and Claude Code. Idempotent - safe to run more than once."
echo ""
read -rp "Continue? (y/n) " -n 1 REPLY; echo
[[ "$REPLY" =~ ^[Yy]$ ]] || { print_warning "Cancelled."; exit 0; }

# ══════════════════════════════════════════════════════════════════
# 1. XCODE COMMAND LINE TOOLS  (provides git, cc, make...)
# ══════════════════════════════════════════════════════════════════
print_header "Xcode Command Line Tools"
if xcode-select -p &>/dev/null; then
    print_success "Already installed"
else
    print_info "Installing... complete the GUI prompt, then re-run this script."
    xcode-select --install
    exit 0
fi

# ══════════════════════════════════════════════════════════════════
# 2. HOMEBREW (architecture-aware)
# ══════════════════════════════════════════════════════════════════
print_header "Homebrew"
if [[ "$(uname -m)" == "arm64" ]]; then
    BREW_BIN="/opt/homebrew/bin/brew"   # Apple Silicon
else
    BREW_BIN="/usr/local/bin/brew"      # Intel
fi

if [[ -x "$BREW_BIN" ]]; then
    print_success "Homebrew already installed"
else
    print_info "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Load brew into THIS shell...
eval "$("$BREW_BIN" shellenv)"
# ...and persist to ~/.zprofile for future login shells.
if ! grep -qF "$BREW_BIN shellenv" "$HOME/.zprofile" 2>/dev/null; then
    printf '\n# Homebrew\neval "$(%s shellenv)"\n' "$BREW_BIN" >> "$HOME/.zprofile"
    print_info "Added Homebrew to ~/.zprofile"
fi

print_info "Updating Homebrew..."
brew update

# ══════════════════════════════════════════════════════════════════
# 3. DOTFILES REPO  (clone/refresh FIRST - the Brewfile lives here)
#    Done before `brew bundle` so the Brewfile is always on disk even
#    when this script is piped via `bash <(curl ...)`.
# ══════════════════════════════════════════════════════════════════
print_header "Dotfiles repository"
if [[ -d "$DOTFILES_DIR/.git" ]]; then
    print_info "Updating existing clone at $DOTFILES_DIR..."
    git -C "$DOTFILES_DIR" pull --ff-only 2>/dev/null || print_warning "Could not fast-forward (local changes?) - using current checkout."
else
    print_info "Cloning $DOTFILES_REPO -> $DOTFILES_DIR..."
    mkdir -p "$HOME/Repos"
    git clone --branch "$BRANCH" "$DOTFILES_REPO" "$DOTFILES_DIR" \
        || git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi
print_success "Dotfiles at $DOTFILES_DIR"

# ══════════════════════════════════════════════════════════════════
# 4. INSTALL EVERYTHING FROM THE BREWFILE
#    Resolve the Brewfile from the clone; fall back to a fresh curl
#    so this step can never be silently skipped.
# ══════════════════════════════════════════════════════════════════
print_header "Installing packages from Brewfile"
BREWFILE="$DOTFILES_DIR/Brewfile"
if [[ ! -f "$BREWFILE" ]]; then
    print_warning "Brewfile not found in clone - fetching from $REPO_RAW"
    BREWFILE="$(mktemp -t Brewfile.XXXXXX)"
    curl -fsSL "$REPO_RAW/Brewfile" -o "$BREWFILE" \
        || { print_error "Could not download Brewfile - aborting package install."; BREWFILE=""; }
fi
if [[ -n "$BREWFILE" && -f "$BREWFILE" ]]; then
    # Homebrew 6+ refuses to load formulae from untrusted third-party taps,
    # which aborts the WHOLE bundle run. Trust every tap the Brewfile declares
    # first so bundle can proceed past them (e.g. supabase/tap, hashicorp/tap).
    while IFS= read -r line; do
        [[ "$line" =~ ^tap[[:space:]]+\"([^\"]+)\" ]] || continue
        tapname="${BASH_REMATCH[1]}"
        brew tap "$tapname" >/dev/null 2>&1 || true
        brew trust "$tapname" >/dev/null 2>&1 && print_success "trusted tap $tapname"
    done < "$BREWFILE"

    print_info "Running brew bundle (formulae, casks, App Store apps, VS Code extensions)…"
    # Modern Homebrew doesn't write a Brewfile.lock.json by default and has
    # dropped the --no-lock flag, so we no longer pass it.
    brew bundle install --file="$BREWFILE" \
        || print_warning "Some packages failed — see the summary above. Re-running the script will retry them."
    print_success "Brewfile processed"
else
    print_error "Skipped package install (no Brewfile). Fix connectivity and re-run."
fi

# ══════════════════════════════════════════════════════════════════
# 5. SYMLINK DOTFILES
# ══════════════════════════════════════════════════════════════════
print_header "Linking dotfiles"
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

# claude-cmd lives inside ~/.claude (Claude Code's managed dir) - link the file only.
if [[ -f "$DOTFILES_DIR/.claude/claude-cmd.zsh" ]]; then
    mkdir -p "$HOME/.claude"
    ln -sfn "$DOTFILES_DIR/.claude/claude-cmd.zsh" "$HOME/.claude/claude-cmd.zsh"
    print_success "linked claude-cmd.zsh"
fi
[[ -d "$backup_dir" ]] && print_info "Replaced files backed up to $backup_dir"

# ══════════════════════════════════════════════════════════════════
# 6. DEFAULT SHELL -> ZSH
# ══════════════════════════════════════════════════════════════════
print_header "Default shell"
if [[ "$SHELL" == */zsh ]]; then
    print_success "Already zsh"
else
    print_info "Switching default shell to zsh..."
    chsh -s "$(command -v zsh)" && print_success "Done (restart terminal to apply)"
fi

# ══════════════════════════════════════════════════════════════════
# 7. CLAUDE CODE CLI  ->  claude / claude-go / claude-cmd
# ══════════════════════════════════════════════════════════════════
print_header "Claude Code"
if [[ -x "$HOME/.local/bin/claude" ]] || command -v claude &>/dev/null; then
    print_success "Claude Code already installed"
else
    print_info "Installing Claude Code (native installer)..."
    curl -fsSL https://claude.ai/install.sh | bash \
        || print_warning "Claude install failed - see https://docs.claude.com/claude-code"
fi
print_info "claude / claude-go / claude-cmd load from your dotfiles in a new shell."

# ══════════════════════════════════════════════════════════════════
# 8. NODE.JS  (nvm + global tools)
# ══════════════════════════════════════════════════════════════════
print_header "Node.js"
export NVM_DIR="$HOME/.nvm"; mkdir -p "$NVM_DIR"
if [[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ]]; then
    # shellcheck disable=SC1091
    . "$(brew --prefix)/opt/nvm/nvm.sh"
    print_info "Installing Node LTS + current via nvm..."
    nvm install --lts && nvm alias default 'lts/*'
    nvm install node        # latest current
    nvm use --lts >/dev/null
    corepack enable 2>/dev/null || true   # yarn / pnpm shims
    print_success "Node $(node -v 2>/dev/null) active"

    print_info "Installing global npm packages..."
    for pkg in pm2 vercel typescript ts-node nodemon eslint prettier \
               npm-check-updates serve http-server; do
        npm install -g "$pkg" >/dev/null 2>&1 && print_success "npm -g $pkg" \
            || print_warning "npm -g $pkg failed"
    done
else
    print_warning "nvm not found - is it in the Brewfile / did brew bundle run?"
fi

# ══════════════════════════════════════════════════════════════════
# 9. PYTHON  (pyenv + pip + venv + pipx tools)
# ══════════════════════════════════════════════════════════════════
print_header "Python"
if command -v pyenv &>/dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"; export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)" 2>/dev/null || true
    print_success "pyenv ready ($(pyenv --version 2>/dev/null))"
fi
# `python3 -m venv` and `pip3` ship with Homebrew's python. Make sure pip is current.
if command -v python3 &>/dev/null; then
    python3 -m pip install --upgrade pip >/dev/null 2>&1 \
        && print_success "pip upgraded ($(python3 -m pip --version 2>/dev/null | awk '{print $2}'))" || true
fi
if command -v pipx &>/dev/null; then
    pipx ensurepath >/dev/null 2>&1
    print_info "Installing pipx CLI tools..."
    for pkg in black flake8 ruff mypy ipython pytest poetry pipenv virtualenv cookiecutter; do
        pipx install "$pkg" >/dev/null 2>&1 && print_success "pipx $pkg" \
            || print_warning "pipx $pkg (already installed or failed)"
    done
fi

# ══════════════════════════════════════════════════════════════════
# 10. RUBY  (rbenv + gems)
# ══════════════════════════════════════════════════════════════════
print_header "Ruby"
if command -v rbenv &>/dev/null; then
    export RBENV_ROOT="$HOME/.rbenv"; export PATH="$RBENV_ROOT/bin:$PATH"
    eval "$(rbenv init - zsh)" 2>/dev/null || eval "$(rbenv init -)" 2>/dev/null || true
    latest_ruby="$(rbenv install -l 2>/dev/null | grep -vE '[a-zA-Z-]' | tail -1 | xargs)"
    if [[ -n "$latest_ruby" ]]; then
        if rbenv versions --bare 2>/dev/null | grep -qx "$latest_ruby"; then
            print_success "Ruby $latest_ruby already installed"
        else
            print_info "Installing Ruby $latest_ruby (this can take a while)..."
            rbenv install "$latest_ruby" && rbenv global "$latest_ruby"
        fi
        print_info "Installing gems (bundler, cocoapods, fastlane)..."
        gem install bundler cocoapods fastlane >/dev/null 2>&1 \
            && print_success "gems installed" || print_warning "gem install had issues"
    fi
else
    print_warning "rbenv not found - skipping Ruby"
fi

# ══════════════════════════════════════════════════════════════════
# 11. RUST  (rustup)
# ══════════════════════════════════════════════════════════════════
print_header "Rust"
if command -v rustup &>/dev/null || [[ -x "$HOME/.cargo/bin/rustup" ]]; then
    "$HOME/.cargo/bin/rustup" default stable 2>/dev/null || rustup default stable 2>/dev/null || true
    "$HOME/.cargo/bin/rustup" update 2>/dev/null || rustup update 2>/dev/null || true
    print_success "Rust toolchain ready"
else
    print_info "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    print_success "Rust installed"
fi

# ══════════════════════════════════════════════════════════════════
# 12. JAVA  (register Homebrew's openjdk with jenv)
# ══════════════════════════════════════════════════════════════════
print_header "Java"
if command -v jenv &>/dev/null && brew --prefix openjdk &>/dev/null; then
    export PATH="$HOME/.jenv/bin:$PATH"; eval "$(jenv init -)" 2>/dev/null || true
    jdk_path="$(brew --prefix openjdk)/libexec/openjdk.jdk/Contents/Home"
    [[ -d "$jdk_path" ]] && jenv add "$jdk_path" >/dev/null 2>&1 && print_success "openjdk registered with jenv" \
        || print_info "openjdk present; run 'jenv add <jdk>' to manage versions"
else
    print_info "jenv/openjdk not both present - skipping (installed via Brewfile if listed)"
fi

# ══════════════════════════════════════════════════════════════════
# 13. GIT IDENTITY
# ══════════════════════════════════════════════════════════════════
print_header "Git identity"
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
# 14. STANDARD DIRECTORIES
# ══════════════════════════════════════════════════════════════════
print_header "Directories"
for d in "$HOME/Repos" "$HOME/.config" "$HOME/.local/bin"; do
    mkdir -p "$d" && print_success "$d"
done

# ══════════════════════════════════════════════════════════════════
# 15. MACOS DEFAULTS
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
  4. Verify a few tools:
       node -v && python3 --version && ruby -v && go version && docker --version
       claude --version
       claude-cmd "list files changed in the last commit"

Handy shell commands from your dotfiles: menu · commands · repo · devinfo
EOF
read -rp "Restart the shell now? (y/n) " -n 1 REPLY; echo
[[ "$REPLY" =~ ^[Yy]$ ]] && exec zsh
