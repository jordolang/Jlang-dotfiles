#!/usr/bin/env zsh
# ╔══════════════════════════════════════════════════════════════════╗
# ║           JORDAN LANG'S ULTIMATE ZSH COMMAND CENTER              ║
# ║                                                                  ║
# ║   Powered by: Powerlevel10k + Zsh Plugins + Custom Scripts       ║
# ║   Edit modular configs in ~/.zsh/                                ║
# ║   Type 'commands' for a cheatsheet │ 'menu' for interactive fzf  ║
# ╚══════════════════════════════════════════════════════════════════╝

# ══════════════════════════════════════════════════════════════════
# INSTANT PROMPT (must stay at top)
# ══════════════════════════════════════════════════════════════════
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ══════════════════════════════════════════════════════════════════
# HOMEBREW
# ══════════════════════════════════════════════════════════════════
# Locate Homebrew on either architecture (Apple Silicon first, then Intel)
# even if it is not yet on PATH, then load its environment.
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [[ -x "$_brew" ]]; then
    eval "$("$_brew" shellenv)"
    break
  fi
done
unset _brew
if command -v brew >/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:$(brew --prefix)/share/zsh-completions:${FPATH}"
fi

# ══════════════════════════════════════════════════════════════════
# ZSH OPTIONS
# ══════════════════════════════════════════════════════════════════
setopt AUTO_CD                 # cd by just typing directory name
setopt AUTO_PUSHD              # push dirs to stack automatically
setopt PUSHD_IGNORE_DUPS       # no duplicate dirs in stack
setopt PUSHD_SILENT            # don't print dir stack
setopt CORRECT                 # command auto-correction
setopt CDABLE_VARS             # cd to named dirs
setopt EXTENDED_GLOB           # advanced globbing
setopt NO_CASE_GLOB            # case-insensitive globbing
setopt NUMERIC_GLOB_SORT       # sort numerically
setopt NO_BEEP                 # no beeping
setopt INTERACTIVE_COMMENTS    # allow comments in interactive shell
setopt MULTIOS                 # allow multiple redirections
setopt LONG_LIST_JOBS          # show job PID on suspend
setopt NOTIFY                  # report bg job status immediately

# ══════════════════════════════════════════════════════════════════
# HISTORY (supercharged)
# ══════════════════════════════════════════════════════════════════
HISTFILE="$HOME/.zhistory"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY           # share across sessions
setopt HIST_EXPIRE_DUPS_FIRST  # expire dupes first
setopt HIST_IGNORE_DUPS        # don't record dupes
setopt HIST_IGNORE_ALL_DUPS    # remove older dupes
setopt HIST_FIND_NO_DUPS       # don't show dupes in search
setopt HIST_IGNORE_SPACE       # ignore space-prefixed commands
setopt HIST_SAVE_NO_DUPS       # don't save dupes
setopt HIST_VERIFY             # verify before executing from history
setopt INC_APPEND_HISTORY      # append incrementally
setopt HIST_REDUCE_BLANKS      # remove extra blanks

# ══════════════════════════════════════════════════════════════════
# COMPLETION SYSTEM
# ══════════════════════════════════════════════════════════════════
autoload -Uz compinit
# Speed up compinit - only check cache once a day
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}── %d ──%f'
zstyle ':completion:*:warnings' format '%F{red}  No matches found%f'
zstyle ':completion:*:corrections' format '%F{green}  %d (errors: %e)%f'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zsh/.zcompcache"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:ssh:*' hosts off
zstyle ':completion:*:scp:*' hosts off

# ══════════════════════════════════════════════════════════════════
# PATH CONFIGURATION
# ══════════════════════════════════════════════════════════════════
typeset -U path  # deduplicate PATH

# Homebrew prefix — Intel: /usr/local, Apple Silicon: /opt/homebrew.
# Resolved once so the rest of this file is architecture-portable.
export BREW_PREFIX="$(brew --prefix 2>/dev/null || echo /opt/homebrew)"

# Cargo (Rust)
export PATH="$HOME/.cargo/bin:$PATH"

# Helm
export PATH="${BREW_PREFIX}/opt/helm@3/bin:$PATH"

# Android SDK
export ANDROID_HOME="${BREW_PREFIX}/share/android-commandlinetools"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH"

# Composer (PHP)
export PATH="$HOME/.composer/vendor/bin:$HOME/.config/composer/vendor/bin:$PATH"

# pipx / local bin
export PATH="$HOME/.local/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# OpenCode
export PATH="$HOME/.opencode/bin:$PATH"

# Local node_modules bin
export PATH="./node_modules/.bin:$PATH"

# Prefer modern curl from Homebrew
if command -v brew >/dev/null; then
  export PATH="$(brew --prefix)/opt/curl/bin:$PATH"
fi

# ══════════════════════════════════════════════════════════════════
# ENVIRONMENT VARIABLES
# ══════════════════════════════════════════════════════════════════
export EDITOR="micro"
export VISUAL="micro"
export PAGER="less"
export LESS="-R -F -X --mouse --wheel-lines=3"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# fzf theming (blue/red/lime/orange)
export FZF_DEFAULT_OPTS="
  --height 40%
  --reverse
  --border rounded
  --color=fg:#c0c0c0,bg:#1a1a2e,hl:#e94560
  --color=fg+:#ffffff,bg+:#16213e,hl+:#0f3460
  --color=info:#e2b714,prompt:#0f3460,pointer:#e94560
  --color=marker:#00ff41,spinner:#e94560,header:#e2b714
  --color=border:#0f3460
  --prompt='  '
  --pointer='▶'
  --marker='✓'
"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# bat theming
export BAT_THEME="Dracula"
export BAT_STYLE="numbers,changes,header"

# ══════════════════════════════════════════════════════════════════
# VERSION MANAGERS
# ══════════════════════════════════════════════════════════════════

# nvm (Node Version Manager) - lazy load for faster startup
export NVM_DIR="$HOME/.nvm"
nvm() {
  unfunction nvm node npm npx 2>/dev/null
  [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"
  [ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"
  nvm "$@"
}
node() { nvm --version >/dev/null 2>&1; unfunction node 2>/dev/null; command node "$@"; }
npm() { nvm --version >/dev/null 2>&1; unfunction npm 2>/dev/null; command npm "$@"; }
npx() { nvm --version >/dev/null 2>&1; unfunction npx 2>/dev/null; command npx "$@"; }
# Auto-load nvm if .nvmrc exists
if [[ -f .nvmrc ]] && [[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ]]; then
  . "$(brew --prefix)/opt/nvm/nvm.sh"
fi

# pyenv (Python)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null; then eval "$(pyenv init -)"; fi

# rbenv (Ruby)
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"
if command -v rbenv >/dev/null; then eval "$(rbenv init - zsh)"; fi

# ══════════════════════════════════════════════════════════════════
# TOOL COMPLETIONS
# ══════════════════════════════════════════════════════════════════

# GitHub CLI
if command -v gh >/dev/null; then
  eval "$(gh completion -s zsh)"
fi

# Google Cloud SDK
if [ -f "$HOME/Repos/josemadridsalsa/gcloud/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/Repos/josemadridsalsa/gcloud/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/Repos/josemadridsalsa/gcloud/google-cloud-sdk/completion.zsh.inc" ]; then
  source "$HOME/Repos/josemadridsalsa/gcloud/google-cloud-sdk/completion.zsh.inc"
fi

# Docker completions
fpath=($HOME/.docker/completions $fpath)

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# OpenClaw completions
if command -v openclaw >/dev/null 2>&1; then
fi

# Claude Code CLI
alias claude="$HOME/.local/bin/claude"
alias claude.app='open -a "Claude"'

# Claude, permissions bypassed (YOLO mode)
alias claude-go="$HOME/.local/bin/claude --dangerously-skip-permissions"

# Ask Claude for a single terminal command — prints only the command, nothing else
claude-cmd() {
  if [[ $# -eq 0 ]]; then
    echo "usage: claude-cmd <what you want the command to do>" >&2
    return 1
  fi
  "$HOME/.local/bin/claude" -p "Output ONLY the single shell command that accomplishes the request below. No explanation, no markdown, no code fences, no backticks — just the raw command on one line. Request: $*"
}

# ══════════════════════════════════════════════════════════════════
# FZF
# ══════════════════════════════════════════════════════════════════
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ══════════════════════════════════════════════════════════════════
# ZOXIDE (smart cd)
# ══════════════════════════════════════════════════════════════════
eval "$(zoxide init zsh)"
alias cd="z"

# ══════════════════════════════════════════════════════════════════
# KEY BINDINGS
# ══════════════════════════════════════════════════════════════════
bindkey '^[[A' history-search-backward    # Up arrow
bindkey '^[[B' history-search-forward     # Down arrow
bindkey '^[[1;5C' forward-word            # Ctrl+Right
bindkey '^[[1;5D' backward-word           # Ctrl+Left
bindkey '^[[H' beginning-of-line          # Home
bindkey '^[[F' end-of-line                # End
bindkey '^[[3~' delete-char               # Delete
bindkey '^U' backward-kill-line           # Ctrl+U
bindkey '^[.' insert-last-word            # Alt+. (last arg)
bindkey ' ' magic-space                   # history expansion on space

# ══════════════════════════════════════════════════════════════════
# POWERLEVEL10K THEME
# ══════════════════════════════════════════════════════════════════
source ${BREW_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ══════════════════════════════════════════════════════════════════
# ZSH PLUGINS
# ══════════════════════════════════════════════════════════════════
source ${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autosuggestion styling
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#555555,underline"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Syntax highlighting custom colors
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[path]='fg=yellow,underline'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=green'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=green'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=green'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#555555'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
# Highlight patterns
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('sudo *' 'fg=white,bold,bg=yellow')

# ══════════════════════════════════════════════════════════════════
# LOAD MODULAR CONFIGS
# ══════════════════════════════════════════════════════════════════
[[ -f ~/.zsh/local.zsh ]]    && source ~/.zsh/local.zsh
[[ -f ~/.zsh/aliases.zsh ]]  && source ~/.zsh/aliases.zsh
[[ -f ~/.zsh/functions.zsh ]] && source ~/.zsh/functions.zsh
[[ -f ~/.zsh/menu.zsh ]]     && source ~/.zsh/menu.zsh
[[ -f ~/.zsh/greeting.zsh ]] && source ~/.zsh/greeting.zsh

# ══════════════════════════════════════════════════════════════════
# AUTO-ACTIONS
# ══════════════════════════════════════════════════════════════════

# Auto-activate Python venv when entering a directory
_auto_venv() {
  if [[ -z "$VIRTUAL_ENV" ]]; then
    if [[ -f ".venv/bin/activate" ]]; then
      source .venv/bin/activate
    elif [[ -f "venv/bin/activate" ]]; then
      source venv/bin/activate
    fi
  elif [[ -n "$VIRTUAL_ENV" ]]; then
    local parent_dir="$(dirname "$VIRTUAL_ENV")"
    if [[ "$PWD" != "$parent_dir"* ]]; then
      deactivate 2>/dev/null
    fi
  fi
}
autoload -U add-zsh-hook
add-zsh-hook chpwd _auto_venv

# ══════════════════════════════════════════════════════════════════
# FINAL
# ══════════════════════════════════════════════════════════════════
# Deduplicate PATH one final time
typeset -U path

# try-rs integration
[[ -f '/Users/jordanlang/Library/Application Support/try-rs/try-rs.zsh' ]] && source '/Users/jordanlang/Library/Application Support/try-rs/try-rs.zsh'

# OpenClaw Completion
source "/Users/jordanlang/.openclaw/completions/openclaw.zsh"
