#!/usr/bin/env zsh
# ╔══════════════════════════════════════════════════════════════════╗
# ║                    JORDAN'S FUNCTION LIBRARY                     ║
# ╚══════════════════════════════════════════════════════════════════╝

# ┌─────────────────────────────────────────┐
# │     YAZI (file browser with cd-on-exit) │
# └─────────────────────────────────────────┘
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ┌─────────────────────────────────────────┐
# │     REPO - Jump to any project w/ fzf  │
# └─────────────────────────────────────────┘
repo() {
  local dir
  if [[ -n "$1" ]]; then
    dir=$(find ~/Repos -maxdepth 1 -type d -name "*$1*" 2>/dev/null | head -1)
    if [[ -n "$dir" ]]; then
      cd "$dir"
      echo "\033[38;5;118m  Jumped to $(basename "$dir")\033[0m"
      ll 2>/dev/null
    else
      echo "\033[1;31m  No repo matching '$1'\033[0m"
    fi
  else
    dir=$(find ~/Repos -maxdepth 1 -type d ! -name "." | sort | \
      fzf --height 40% --reverse --border rounded \
          --header "  Select a Project" \
          --preview 'eza --icons=always --color=always -la --git {} 2>/dev/null | head -20; echo ""; cat {}/README.md 2>/dev/null | head -15 || echo "No README"' \
          --preview-window right:50% \
          --color "header:yellow,border:blue,pointer:red,hl:lime")
    if [[ -n "$dir" ]]; then
      cd "$dir"
      echo "\033[38;5;118m  Jumped to $(basename "$dir")\033[0m"
    fi
  fi
}

# ┌─────────────────────────────────────────┐
# │     MKCD - Make dir and enter it        │
# └─────────────────────────────────────────┘
mkcd() {
  mkdir -p "$1" && cd "$1"
  echo "\033[38;5;118m  Created and entered $1\033[0m"
}

# ┌─────────────────────────────────────────┐
# │     EXTRACT - Universal archive opener  │
# └─────────────────────────────────────────┘
extract() {
  if [[ -z "$1" ]]; then
    echo "Usage: extract <file>"
    return 1
  fi
  if [[ ! -f "$1" ]]; then
    echo "\033[1;31m  '$1' is not a valid file\033[0m"
    return 1
  fi
  case "$1" in
    *.tar.bz2)  tar xjf "$1"     ;;
    *.tar.gz)   tar xzf "$1"     ;;
    *.tar.xz)   tar xJf "$1"     ;;
    *.tar.zst)  tar --zstd -xf "$1" ;;
    *.bz2)      bunzip2 "$1"     ;;
    *.rar)      unrar x "$1"     ;;
    *.gz)       gunzip "$1"      ;;
    *.tar)      tar xf "$1"      ;;
    *.tbz2)     tar xjf "$1"     ;;
    *.tgz)      tar xzf "$1"     ;;
    *.zip)      unzip "$1"       ;;
    *.Z)        uncompress "$1"  ;;
    *.7z)       7z x "$1"        ;;
    *.xz)       unxz "$1"        ;;
    *.zst)      unzstd "$1"      ;;
    *.deb)      ar x "$1"        ;;
    *)          echo "\033[1;31m  Cannot extract '$1'\033[0m" ;;
  esac
}

# ┌─────────────────────────────────────────┐
# │     GCLONE - Clone to ~/Repos          │
# └─────────────────────────────────────────┘
gclone() {
  if [[ -z "$1" ]]; then
    echo "Usage: gclone <repo-url-or-user/repo>"
    return 1
  fi
  local url="$1"
  # Allow shorthand user/repo
  if [[ "$url" != http* && "$url" != git@* ]]; then
    url="https://github.com/$1.git"
  fi
  local repo_name=$(basename "$url" .git)
  cd ~/Repos
  git clone "$url"
  if [[ $? -eq 0 ]]; then
    cd "$repo_name"
    echo "\033[38;5;118m  Cloned and entered ~/Repos/$repo_name\033[0m"
    ll 2>/dev/null
  fi
}

# ┌─────────────────────────────────────────┐
# │     PUSHSYNC / PULLSYNC - Server xfer  │
# └─────────────────────────────────────────┘
pushsync() {
  local src="${1:-.}"
  local dest="${2:-~/transfer/}"
  local host="${SERVER_HOST:-homeserver}"
  echo "\033[1;34m  Syncing $src -> $host:$dest\033[0m"
  rsync -avhP --stats -e "ssh" "$src" "${host}:${dest}"
  echo "\033[38;5;118m  Transfer complete\033[0m"
}

pullsync() {
  local src="${1:-~/transfer/}"
  local dest="${2:-.}"
  local host="${SERVER_HOST:-homeserver}"
  echo "\033[1;34m  Pulling $host:$src -> $dest\033[0m"
  rsync -avhP --stats -e "ssh" "${host}:${src}" "$dest"
  echo "\033[38;5;118m  Transfer complete\033[0m"
}

# ┌─────────────────────────────────────────┐
# │     VENV - Python venv helper           │
# └─────────────────────────────────────────┘
venv() {
  case "${1:-activate}" in
    create|new|init)
      python3 -m venv "${2:-.venv}"
      source "${2:-.venv}/bin/activate"
      pip install --upgrade pip
      echo "\033[38;5;118m  Created and activated ${2:-.venv}\033[0m"
      ;;
    activate|on)
      if [[ -f ".venv/bin/activate" ]]; then
        source .venv/bin/activate
      elif [[ -f "venv/bin/activate" ]]; then
        source venv/bin/activate
      else
        echo "\033[1;31m  No venv found. Use: venv create\033[0m"
        return 1
      fi
      echo "\033[38;5;118m  Activated $(which python3)\033[0m"
      ;;
    deactivate|off)
      deactivate 2>/dev/null && echo "\033[1;33m  Deactivated venv\033[0m" || echo "No active venv"
      ;;
    *)
      echo "Usage: venv [create|activate|deactivate] [name]"
      ;;
  esac
}

# ┌─────────────────────────────────────────┐
# │     DOCKER-NUKE - Clean up Docker      │
# └─────────────────────────────────────────┘
docker-nuke() {
  echo "\033[1;31m  Docker Cleanup\033[0m"
  echo "\033[1;33m  Stopping all containers...\033[0m"
  docker stop $(docker ps -aq) 2>/dev/null
  echo "\033[1;33m  Removing stopped containers...\033[0m"
  docker container prune -f
  echo "\033[1;33m  Removing unused images...\033[0m"
  docker image prune -af
  echo "\033[1;33m  Removing unused volumes...\033[0m"
  docker volume prune -f
  echo "\033[1;33m  Removing unused networks...\033[0m"
  docker network prune -f
  echo "\033[1;33m  Removing build cache...\033[0m"
  docker builder prune -af
  echo "\033[38;5;118m  Docker cleaned!\033[0m"
  docker system df
}

# ┌─────────────────────────────────────────┐
# │     CHEAT - cheat.sh integration        │
# └─────────────────────────────────────────┘
cheat() {
  if [[ -z "$1" ]]; then
    echo "Usage: cheat <command> [topic]"
    echo "  e.g.: cheat git rebase"
    return 1
  fi
  local query="${(j:/:)@}"
  curl -s "cheat.sh/${query}" | bat --paging=always --style=plain --language=bash 2>/dev/null || \
  curl -s "cheat.sh/${query}"
}

# ┌─────────────────────────────────────────┐
# │     GITIGNORE - Generate .gitignore     │
# └─────────────────────────────────────────┘
gitignore() {
  if [[ -z "$1" ]]; then
    echo "Usage: gitignore <language,framework,...>"
    echo "  e.g.: gitignore node,python,macos"
    return 1
  fi
  curl -sL "https://www.toptal.com/developers/gitignore/api/$1" -o .gitignore
  echo "\033[38;5;118m  Generated .gitignore for $1\033[0m"
}

# ┌─────────────────────────────────────────┐
# │     NEWPROJECT - Scaffold a project     │
# └─────────────────────────────────────────┘
newproject() {
  if [[ -z "$1" ]]; then
    echo "Usage: newproject <name> [type]"
    echo "  Types: node, python, go, rust, astro, next, basic"
    return 1
  fi
  local name="$1"
  local type="${2:-basic}"
  local dir="$HOME/Repos/$name"

  if [[ -d "$dir" ]]; then
    echo "\033[1;31m  $dir already exists\033[0m"
    return 1
  fi

  mkdir -p "$dir" && cd "$dir"

  case "$type" in
    node)
      npm init -y && gitignore node,macos
      echo "\033[38;5;118m  Node project created\033[0m"
      ;;
    python|py)
      python3 -m venv .venv && source .venv/bin/activate
      gitignore python,macos && touch main.py requirements.txt
      echo "\033[38;5;118m  Python project created (venv activated)\033[0m"
      ;;
    next)
      cd ~/Repos && npx create-next-app@latest "$name"
      cd "$dir" 2>/dev/null
      echo "\033[38;5;118m  Next.js project created\033[0m"
      ;;
    astro)
      cd ~/Repos && npm create astro@latest "$name"
      cd "$dir" 2>/dev/null
      echo "\033[38;5;118m  Astro project created\033[0m"
      ;;
    go)
      go mod init "$name" && gitignore go,macos
      touch main.go
      echo "\033[38;5;118m  Go project created\033[0m"
      ;;
    rust)
      cd ~/Repos && cargo init "$name"
      cd "$dir" && gitignore rust,macos
      echo "\033[38;5;118m  Rust project created\033[0m"
      ;;
    basic|*)
      git init && gitignore macos,linux,windows
      touch README.md
      echo "\033[38;5;118m  Basic project created\033[0m"
      ;;
  esac

  git init 2>/dev/null
}

# ┌─────────────────────────────────────────┐
# │     BACKUP - Backup configs             │
# └─────────────────────────────────────────┘
backup() {
  local backup_dir="$HOME/.config-backups/$(date +%Y%m%d_%H%M%S)"
  mkdir -p "$backup_dir"

  local files=(
    ~/.zshrc
    ~/.p10k.zsh
    ~/.zsh
    ~/.ssh/config
    ~/.gitconfig
    ~/.config/micro
    ~/.config/yazi
  )

  for f in "${files[@]}"; do
    if [[ -e "$f" ]]; then
      cp -r "$f" "$backup_dir/" 2>/dev/null
    fi
  done

  echo "\033[38;5;118m  Configs backed up to $backup_dir\033[0m"
  ls "$backup_dir"
}

# ┌─────────────────────────────────────────┐
# │     QUICKSERVE - HTTP server w/ options │
# └─────────────────────────────────────────┘
quickserve() {
  local port="${1:-8080}"
  local dir="${2:-.}"
  echo "\033[1;34m  Serving $dir on http://localhost:$port\033[0m"
  echo "\033[2m  Press Ctrl+C to stop\033[0m"
  python3 -m http.server "$port" --directory "$dir"
}

# ┌─────────────────────────────────────────┐
# │     ENVFILE - .env helper               │
# └─────────────────────────────────────────┘
envfile() {
  case "${1:-show}" in
    show)
      if [[ -f .env ]]; then
        bat --style=plain .env 2>/dev/null || cat .env
      else
        echo "\033[1;31m  No .env file found\033[0m"
      fi
      ;;
    edit)
      micro .env
      ;;
    template)
      if [[ -f .env.example ]]; then
        cp .env.example .env
        echo "\033[38;5;118m  Created .env from .env.example\033[0m"
      else
        echo "\033[1;31m  No .env.example found\033[0m"
      fi
      ;;
    *)
      echo "Usage: envfile [show|edit|template]"
      ;;
  esac
}

# ┌─────────────────────────────────────────┐
# │     TRAEFIK HELPERS                     │
# └─────────────────────────────────────────┘
traefik-stacks() {
  local host="${SERVER_HOST:-homeserver}"
  echo "\033[1;34m  Traefik Stack Services on $host\033[0m"
  ssh "$host" 'cd ~/homeserver-traefik-portainer 2>/dev/null && ls stacks/ 2>/dev/null || echo "Stacks dir not found"'
}

traefik-restart() {
  local host="${SERVER_HOST:-homeserver}"
  echo "\033[1;33m  Restarting Traefik on $host...\033[0m"
  ssh "$host" 'cd ~/homeserver-traefik-portainer 2>/dev/null && docker compose restart traefik 2>/dev/null || docker restart traefik 2>/dev/null'
  echo "\033[38;5;118m  Traefik restarted\033[0m"
}

# ┌─────────────────────────────────────────┐
# │     SEARCH HELPERS                      │
# └─────────────────────────────────────────┘
# Fuzzy find files and open in micro
fe() {
  local file
  file=$(fzf --height 40% --reverse --border rounded \
    --preview 'bat --style=numbers --color=always {} 2>/dev/null | head -50' \
    --preview-window right:60% \
    --color "header:yellow,border:blue,pointer:red,hl:lime")
  [[ -n "$file" ]] && micro "$file"
}

# Fuzzy grep content and open in micro
fg() {
  local result
  result=$(rg --line-number --color=always "${1:-.}" 2>/dev/null | \
    fzf --ansi --height 40% --reverse --border rounded \
    --color "header:yellow,border:blue,pointer:red,hl:lime")
  if [[ -n "$result" ]]; then
    local file=$(echo "$result" | cut -d: -f1)
    local line=$(echo "$result" | cut -d: -f2)
    micro "$file" "+${line}"
  fi
}

# Fuzzy search history and execute
fh() {
  local cmd
  cmd=$(history 1 | fzf --tac --height 40% --reverse --border rounded \
    --color "header:yellow,border:blue,pointer:red,hl:lime" | \
    sed 's/^[ ]*[0-9]*[ ]*//')
  if [[ -n "$cmd" ]]; then
    echo "\033[2m> $cmd\033[0m"
    eval "$cmd"
  fi
}

# ┌─────────────────────────────────────────┐
# │     DEVINFO - Project detection         │
# └─────────────────────────────────────────┘
devinfo() {
  echo "\033[1;34m  Project Info\033[0m"
  echo ""

  # Git
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    local branch=$(git branch --show-current 2>/dev/null)
    local remote=$(git remote get-url origin 2>/dev/null)
    local commits=$(git rev-list --count HEAD 2>/dev/null)
    local modified=$(git status --porcelain 2>/dev/null | wc -l | xargs)
    echo "  \033[1;31m  Git:\033[0m branch=$branch  commits=$commits  modified=$modified"
    [[ -n "$remote" ]] && echo "    \033[2m$remote\033[0m"
  fi

  # Node.js
  if [[ -f package.json ]]; then
    local name=$(jq -r '.name // "unnamed"' package.json 2>/dev/null)
    local version=$(jq -r '.version // "?"' package.json 2>/dev/null)
    local pm="npm"
    [[ -f bun.lockb ]] && pm="bun"
    [[ -f pnpm-lock.yaml ]] && pm="pnpm"
    [[ -f yarn.lock ]] && pm="yarn"
    echo "  \033[1;32m  Node:\033[0m ${name}@${version}  (${pm})"
  fi

  # Python
  if [[ -f requirements.txt ]] || [[ -f setup.py ]] || [[ -f pyproject.toml ]]; then
    local pyver=$(python3 --version 2>/dev/null | awk '{print $2}')
    local venv_status="none"
    [[ -d .venv ]] && venv_status=".venv"
    [[ -d venv ]] && venv_status="venv"
    [[ -n "$VIRTUAL_ENV" ]] && venv_status="active ($(basename $VIRTUAL_ENV))"
    echo "  \033[1;33m  Python:\033[0m ${pyver}  venv=${venv_status}"
  fi

  # Go
  [[ -f go.mod ]] && echo "  \033[1;36m  Go:\033[0m $(head -1 go.mod | awk '{print $2}') $(go version 2>/dev/null | awk '{print $3}')"

  # Rust
  [[ -f Cargo.toml ]] && echo "  \033[38;5;208m  Rust:\033[0m $(grep '^name' Cargo.toml 2>/dev/null | head -1 | cut -d'"' -f2) $(rustc --version 2>/dev/null | awk '{print $2}')"

  # Docker
  [[ -f docker-compose.yml ]] || [[ -f docker-compose.yaml ]] || [[ -f compose.yml ]] && \
    echo "  \033[1;34m󰡨  Docker:\033[0m compose file detected"
  [[ -f Dockerfile ]] && echo "  \033[1;34m  Dockerfile:\033[0m present"

  # Terraform
  [[ -d .terraform ]] && echo "  \033[38;5;141m󱁢  Terraform:\033[0m workspace=$(terraform workspace show 2>/dev/null || echo 'default')"

  # Vercel
  [[ -f vercel.json ]] || [[ -d .vercel ]] && echo "  \033[1;37m▲  Vercel:\033[0m project detected"

  # Astro
  [[ -f astro.config.mjs ]] || [[ -f astro.config.ts ]] && echo "  \033[38;5;208m  Astro:\033[0m project detected"

  # Next.js
  [[ -f next.config.js ]] || [[ -f next.config.mjs ]] || [[ -f next.config.ts ]] && echo "  \033[1;37m▲  Next.js:\033[0m project detected"

  # Env files
  local env_count=$(ls -1 .env* 2>/dev/null | wc -l | xargs)
  [[ "$env_count" -gt 0 ]] && echo "  \033[1;33m  Env:\033[0m ${env_count} env file(s)"

  echo ""
}

# ┌─────────────────────────────────────────┐
# │     COLORS - Show terminal palette      │
# └─────────────────────────────────────────┘
colors256() {
  for i in {0..255}; do
    printf "\e[38;5;%dm%4d\e[0m" "$i" "$i"
    (( (i + 1) % 16 == 0 )) && echo
  done
}

# ┌─────────────────────────────────────────┐
# │     NOTIFY - macOS notification         │
# └─────────────────────────────────────────┘
notify() {
  local title="${1:-Terminal}"
  local message="${2:-Task complete}"
  osascript -e "display notification \"$message\" with title \"$title\" sound name \"Glass\""
}

# ┌─────────────────────────────────────────┐
# │     TIMER - Simple countdown timer      │
# └─────────────────────────────────────────┘
timer() {
  local seconds="${1:-60}"
  echo "\033[1;34m  Timer: ${seconds}s\033[0m"
  while [[ $seconds -gt 0 ]]; do
    printf "\r\033[1;33m  %02d:%02d remaining\033[0m" $((seconds/60)) $((seconds%60))
    sleep 1
    ((seconds--))
  done
  echo "\r\033[38;5;118m  Time's up!                \033[0m"
  notify "Timer" "Your ${1:-60}s timer is done!"
}

# ┌─────────────────────────────────────────┐
# │     PORTCHECK - Check if port is open   │
# └─────────────────────────────────────────┘
portcheck() {
  if [[ -z "$1" ]]; then
    echo "Usage: portcheck <host> [port]"
    return 1
  fi
  local host="$1"
  local port="${2:-80}"
  if nc -z -w 3 "$host" "$port" 2>/dev/null; then
    echo "\033[38;5;118m  $host:$port is OPEN\033[0m"
  else
    echo "\033[1;31m  $host:$port is CLOSED\033[0m"
  fi
}

# ┌─────────────────────────────────────────┐
# │     BANDWIDTH - Quick speed test        │
# └─────────────────────────────────────────┘
speedtest() {
  echo "\033[1;34m  Testing download speed...\033[0m"
  curl -s -o /dev/null -w "  Download: %{speed_download} bytes/sec (%{size_download} bytes total)\n  Time: %{time_total}s\n" \
    "https://speed.cloudflare.com/__down?bytes=25000000"
}
