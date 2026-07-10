# ╔══════════════════════════════════════════════════════════════════╗
# ║  Jordan Lang — comprehensive macOS dev Brewfile                    ║
# ║                                                                    ║
# ║  A broad development toolchain: every major language + its version ║
# ║  manager, build tooling, databases, containers, DevOps/cloud CLIs, ║
# ║  and modern terminal utilities. Hobby/experimental/beta apps are   ║
# ║  left out — see Brewfile.full for the complete source-machine      ║
# ║  mirror.                                                            ║
# ║                                                                    ║
# ║  Install:  brew bundle --file=Brewfile                             ║
# ╚══════════════════════════════════════════════════════════════════╝

# ── Taps ────────────────────────────────────────────────────────────
# Homebrew 6+ refuses formulae from untrusted third-party taps; setup-mac.sh
# runs `brew trust` on each of these before `brew bundle`.
tap "supabase/tap"
tap "hashicorp/tap"   # terraform/vault/packer (moved out of core after relicensing)

# ════════════════════════════════════════════════════════════════════
# SHELL & TERMINAL
# ════════════════════════════════════════════════════════════════════
brew "zsh"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "zsh-completions"
brew "powerlevel10k"
brew "bash"
brew "bash-completion@2"
brew "tmux"
brew "tmuxinator"

# ════════════════════════════════════════════════════════════════════
# CORE BUILD TOOLCHAIN  (make, compilers, autotools, etc.)
# ════════════════════════════════════════════════════════════════════
brew "make"
brew "cmake"
brew "ninja"
brew "meson"
brew "automake"
brew "autoconf"
brew "libtool"
brew "pkgconf"
brew "gcc"
brew "llvm"
brew "ccache"
brew "bison"
brew "gettext"
brew "openssl@3"
brew "readline"
brew "zlib"
brew "ncurses"
brew "coreutils"     # GNU core utils
brew "findutils"     # gfind, gxargs
brew "gnu-sed"       # gsed
brew "gawk"

# ════════════════════════════════════════════════════════════════════
# LANGUAGES & RUNTIMES
# ════════════════════════════════════════════════════════════════════
# Python
brew "python@3.11"
brew "python@3.13"
brew "python@3.14"
brew "pyenv"
brew "pyenv-virtualenv"
brew "pipx"          # isolated Python CLI apps
brew "uv"            # fast installer/resolver
# Node / JS / TS
brew "node"
brew "nvm"           # Node version manager
brew "pnpm"
brew "deno"
brew "bun"
# Ruby
brew "ruby"
brew "rbenv"
# Go
brew "go"
# Rust (rustup manages toolchains; installed by setup-mac.sh)
brew "rustup"
# Java / JVM
brew "openjdk"
brew "jenv"          # Java version manager
brew "maven"
brew "gradle"
brew "kotlin"
brew "scala"
brew "sbt"
brew "groovy"
# PHP
brew "php"
brew "composer"
# Elixir / Erlang
brew "elixir"
# Lua
brew "lua"
brew "luarocks"
# Others
brew "perl"
brew "r"
brew "crystal"
brew "zig"
# Polyglot version manager (asdf-compatible)
brew "mise"
# iOS/macOS
brew "cocoapods"

# ════════════════════════════════════════════════════════════════════
# VERSION CONTROL & GIT TOOLING
# ════════════════════════════════════════════════════════════════════
brew "git"
brew "git-lfs"
brew "git-flow"
brew "git-delta"     # nicer diffs
brew "difftastic"    # structural diffs
brew "lazygit"
brew "gitui"
brew "tig"
brew "git-extras"
brew "gh"            # GitHub CLI
brew "gitleaks"      # secret scanning

# ════════════════════════════════════════════════════════════════════
# CONTAINERS, KUBERNETES & INFRASTRUCTURE
# ════════════════════════════════════════════════════════════════════
brew "docker"
brew "docker-compose"
brew "docker-buildx"
brew "colima"        # Docker/K8s runtime without Docker Desktop
brew "podman"
brew "lazydocker"
brew "dive"          # inspect docker image layers
brew "kubernetes-cli"  # kubectl
brew "kubectx"       # kubectx / kubens
brew "k9s"           # cluster TUI
brew "helm@3"
brew "minikube"
brew "kind"
brew "kustomize"
brew "skaffold"
brew "hashicorp/tap/terraform"
brew "terragrunt"
brew "hashicorp/tap/packer"
brew "hashicorp/tap/vault"
brew "ansible"
brew "qemu"

# ════════════════════════════════════════════════════════════════════
# CLOUD CLIs
# ════════════════════════════════════════════════════════════════════
brew "awscli"
brew "azure-cli"
brew "doctl"         # DigitalOcean
brew "flyctl"        # Fly.io
brew "supabase/tap/supabase"
brew "mongodb-atlas-cli"

# ════════════════════════════════════════════════════════════════════
# DATABASES & DATA
# ════════════════════════════════════════════════════════════════════
brew "postgresql@14"
brew "libpq"         # psql client tools
brew "mysql"
brew "redis"
brew "sqlite"
brew "duckdb"
brew "pgcli"         # nicer psql
brew "mycli"         # nicer mysql
brew "sqlite-utils"

# ════════════════════════════════════════════════════════════════════
# API / HTTP / NETWORKING / RPC
# ════════════════════════════════════════════════════════════════════
brew "httpie"
brew "curlie"
brew "wget"
brew "aria2"
brew "grpcurl"
brew "protobuf"
brew "buf"           # protobuf tooling
brew "websocat"
brew "mkcert"        # local TLS certs
brew "nmap"
brew "netcat"
brew "telnet"
brew "mtr"
brew "rclone"
brew "rsync"

# ════════════════════════════════════════════════════════════════════
# CI / QUALITY / SECURITY
# ════════════════════════════════════════════════════════════════════
brew "act"           # run GitHub Actions locally
brew "shellcheck"
brew "shfmt"
brew "hadolint"      # Dockerfile linter
brew "actionlint"    # GitHub Actions linter
brew "yamllint"
brew "semgrep"
brew "trivy"         # vuln scanner

# ════════════════════════════════════════════════════════════════════
# MODERN CLI UTILITIES
# ════════════════════════════════════════════════════════════════════
brew "eza"           # better ls
brew "bat"           # better cat
brew "fd"            # better find
brew "ripgrep"       # better grep (rg)
brew "the_silver_searcher"  # ag
brew "fzf"           # fuzzy finder
brew "zoxide"        # smart cd
brew "yazi"          # file manager
brew "broot"         # tree navigator
brew "tree"
brew "htop"
brew "bottom"        # system monitor (btm)
brew "procs"         # better ps
brew "dust"          # better du
brew "duf"           # better df
brew "fastfetch"
brew "hyperfine"     # benchmarking
brew "tokei"         # code stats
brew "entr"          # run on file change
brew "watch"
brew "direnv"        # per-dir env
brew "watchman"      # file watching (RN, etc.)
brew "chezmoi"       # dotfile manager
brew "just"          # command runner
brew "cheat"
brew "tldr"
brew "thefuck"
brew "trash"
brew "terminal-notifier"
brew "multitail"
brew "gnupg"         # GPG
brew "pinentry-mac"

# ── Data wrangling / serialization ─────────────────────────────────
brew "jq"
brew "yq"
brew "dasel"         # jq for many formats
brew "gron"          # greppable JSON
brew "jless"         # JSON viewer
brew "miller"        # mlr — CSV/JSON processing
brew "glow"          # markdown renderer
brew "pandoc"

# ── Media / documents ──────────────────────────────────────────────
brew "imagemagick"
brew "ffmpeg"
brew "ghostscript"
brew "poppler"
brew "tesseract"     # OCR
brew "yt-dlp"

# ── Editors & misc ─────────────────────────────────────────────────
brew "micro"
brew "neovim"
brew "shadcn"
brew "mas"           # Mac App Store CLI
brew "unzip"
brew "sshpass"
brew "try-rs"

# ── AI / dev agents ────────────────────────────────────────────────
brew "ollama", link: false
brew "openai-whisper"
brew "gemini-cli"
brew "opencode"
brew "hf"            # Hugging Face hub client

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
cask "codex"

# ── Dev infrastructure ──────────────────────────────────────────────
cask "docker-desktop"
cask "orbstack"
cask "tableplus"
cask "dbeaver-community"
cask "postman"
cask "ngrok"
cask "gcloud-cli"
cask "dotnet-sdk"
cask "android-platform-tools"

# ── Design & productivity ───────────────────────────────────────────
cask "figma"
cask "obsidian"
cask "notion"
cask "rectangle"
cask "maccy"
cask "slack"

# ── Utilities ───────────────────────────────────────────────────────
cask "keka"
cask "the-unarchiver"
cask "appcleaner"
cask "little-snitch@5"
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
