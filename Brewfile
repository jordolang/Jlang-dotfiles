# ╔══════════════════════════════════════════════════════════════════╗
# ║  Jordan Lang — dev-core Brewfile                                   ║
# ║                                                                    ║
# ║  Curated from a live `brew bundle dump` snapshot, pruned to the    ║
# ║  development environment (languages, editors, CLI tools, DBs,      ║
# ║  containers, AI/dev tooling, fonts). Hobby / experimental / beta   ║
# ║  packages were intentionally left out — see Brewfile.full for the  ║
# ║  complete machine mirror if you ever want it.                      ║
# ║                                                                    ║
# ║  Install everything with:  brew bundle --file=Brewfile             ║
# ╚══════════════════════════════════════════════════════════════════╝

# ── Taps ────────────────────────────────────────────────────────────
tap "supabase/tap"

# ── Shell & terminal ────────────────────────────────────────────────
brew "zsh"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "zsh-completions"
brew "powerlevel10k"
brew "bash"
brew "bash-completion@2"
brew "tmux"

# ── Modern CLI replacements & utilities ─────────────────────────────
brew "eza"                 # better ls
brew "bat"                 # better cat
brew "fd"                  # better find
brew "ripgrep"             # better grep (rg)
brew "the_silver_searcher" # ag
brew "fzf"                 # fuzzy finder
brew "zoxide"              # smart cd
brew "git-delta"           # better git diff pager
brew "yazi"                # terminal file manager
brew "htop"
brew "fastfetch"
brew "tree"
brew "jq"                  # JSON processor
brew "yq"                  # YAML/JSON/XML processor
brew "tldr"                # simplified man pages
brew "cheat"               # command cheat sheets
brew "just"                # command runner
brew "trash"
brew "thefuck"             # command auto-correction
brew "terminal-notifier"
brew "multitail"
brew "pandoc"              # document conversion

# ── Downloaders / transfer ──────────────────────────────────────────
brew "wget"
brew "aria2"
brew "rclone"
brew "rsync"

# ── Editors ─────────────────────────────────────────────────────────
brew "micro"
brew "neovim"

# ── Version control ─────────────────────────────────────────────────
brew "git"
brew "git-lfs"
brew "git-flow"
brew "gh"                  # GitHub CLI
brew "gitleaks"            # secret scanning

# ── Languages & compilers ───────────────────────────────────────────
brew "python@3.11"
brew "python@3.13"
brew "python@3.14"
brew "node"
brew "go"
brew "rust"
brew "gcc"

# ── Version managers ────────────────────────────────────────────────
brew "nvm"                 # Node
brew "pyenv"               # Python
brew "rbenv"               # Ruby
brew "mise"                # polyglot (asdf clone)

# ── Package managers ────────────────────────────────────────────────
brew "pnpm"
brew "composer"            # PHP
brew "cocoapods"           # iOS
brew "pipx"                # isolated Python apps
brew "uv"                  # fast Python installer/resolver

# ── Build tooling ───────────────────────────────────────────────────
brew "cmake"
brew "make"
brew "automake"
brew "pkgconf"

# ── Containers & infrastructure ─────────────────────────────────────
brew "docker"
brew "docker-buildx"
brew "docker-compose"
brew "colima"              # container runtime without Docker Desktop
brew "lazydocker"
brew "kubernetes-cli"      # kubectl
brew "helm@3"
brew "terraform"
brew "ansible"
brew "qemu"

# ── Databases ───────────────────────────────────────────────────────
brew "postgresql@14"
brew "mysql"
brew "redis"
brew "mongodb-atlas-cli"
brew "supabase/tap/supabase"

# ── AI / dev tooling ────────────────────────────────────────────────
brew "ollama", link: false # local LLM runner
brew "openai-whisper"      # speech-to-text
brew "gemini-cli"          # Google Gemini CLI
brew "opencode"            # terminal AI coding agent
brew "semgrep"             # static analysis
brew "hf"                  # Hugging Face hub client

# ── Media / document processing ─────────────────────────────────────
brew "imagemagick"
brew "ffmpeg"
brew "ghostscript"
brew "poppler"
brew "tesseract"           # OCR

# ── Networking ──────────────────────────────────────────────────────
brew "nmap"
brew "netcat"
brew "telnet"

# ── Security / misc ─────────────────────────────────────────────────
brew "pinentry-mac"        # GPG pinentry
brew "sshpass"
brew "shadcn"              # component CLI
brew "mas"                 # Mac App Store CLI
brew "unzip"
brew "yamllint"
brew "try-rs"              # scratch workspace manager

# ════════════════════════════════════════════════════════════════════
# CASKS (GUI applications)
# ════════════════════════════════════════════════════════════════════

# ── Browsers ────────────────────────────────────────────────────────
cask "google-chrome"
cask "firefox"
cask "arc"

# ── Editors & terminals ─────────────────────────────────────────────
cask "cursor"
cask "visual-studio-code"
cask "zed"
cask "iterm2"
cask "warp"
cask "alacritty"
cask "wave"

# ── AI coding ───────────────────────────────────────────────────────
cask "codex"               # OpenAI terminal coding agent

# ── Dev infrastructure ──────────────────────────────────────────────
cask "docker-desktop"
cask "orbstack"
cask "tableplus"
cask "postman"
cask "gcloud-cli"
cask "android-platform-tools"

# ── Design & productivity ───────────────────────────────────────────
cask "figma"
cask "obsidian"
cask "notion"
cask "rectangle"           # window management
cask "maccy"               # clipboard manager
cask "slack"

# ── Utilities ───────────────────────────────────────────────────────
cask "keka"
cask "the-unarchiver"
cask "appcleaner"
cask "little-snitch@5"     # application firewall
cask "vlc"
cask "balenaetcher"

# ── Fonts (Nerd Fonts — required for Powerlevel10k glyphs) ──────────
cask "font-fira-code-nerd-font"
cask "font-jetbrains-mono-nerd-font"
cask "font-meslo-lg-nerd-font"
cask "font-hack-nerd-font"
cask "font-sauce-code-pro-nerd-font"
cask "font-roboto-mono-nerd-font"
cask "font-inconsolata-nerd-font"
cask "font-ubuntu-mono-nerd-font"

# ════════════════════════════════════════════════════════════════════
# MAC APP STORE (requires `mas` + being signed into the App Store)
# ════════════════════════════════════════════════════════════════════
mas "Xcode", id: 497799835
mas "Tailscale", id: 1475387142

# ════════════════════════════════════════════════════════════════════
# VS CODE EXTENSIONS
# ════════════════════════════════════════════════════════════════════
vscode "anthropic.claude-code"
vscode "mechatroner.rainbow-csv"
vscode "janisdd.vscode-edit-csv"
vscode "phplasma.csv-to-table"
vscode "repreng.csv"
