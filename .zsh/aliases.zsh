#!/usr/bin/env zsh
# ╔══════════════════════════════════════════════════════════════════╗
# ║                     JORDAN'S ALIAS ARSENAL                       ║
# ╚══════════════════════════════════════════════════════════════════╝

# ┌─────────────────────────────────────────┐
# │         FILE LISTING (eza)              │
# └─────────────────────────────────────────┘
alias ls="eza --icons=always --color=always --group-directories-first"
alias ll="eza --icons=always --color=always -la --group-directories-first --git --header --time-style=relative"
alias la="eza --icons=always --color=always -a --group-directories-first"
alias lt="eza --icons=always --color=always -la --tree --level=3 --group-directories-first --git-ignore"
alias lt2="eza --icons=always --color=always -la --tree --level=2 --group-directories-first"
alias lt1="eza --icons=always --color=always -la --tree --level=1 --group-directories-first"
alias lsize="eza --icons=always --color=always -la --sort=size --reverse"
alias lmod="eza --icons=always --color=always -la --sort=modified"
alias lext="eza --icons=always --color=always -la --sort=extension"
alias ldot="eza --icons=always --color=always -lad .*"

# ┌─────────────────────────────────────────┐
# │              NAVIGATION                 │
# └─────────────────────────────────────────┘
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"
alias repos="cd ~/Repos"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias docs="cd ~/Documents"
alias cfg="cd ~/.config"

# ┌─────────────────────────────────────────┐
# │           EDITOR (micro)                │
# └─────────────────────────────────────────┘
alias e="micro"
alias edit="micro"
alias sedit="sudo micro"
alias zshrc="micro ~/.zshrc"
alias aliases="micro ~/.zsh/aliases.zsh"
alias funcs="micro ~/.zsh/functions.zsh"
alias p10kcfg="micro ~/.p10k.zsh"
alias sshcfg="micro ~/.ssh/config"
alias hosts="sudo micro /etc/hosts"

# ┌─────────────────────────────────────────┐
# │           FILE BROWSER (yazi)           │
# └─────────────────────────────────────────┘
# 'y' function is in functions.zsh (changes dir on exit)
alias yy="yazi"
alias yr="yazi ~/Repos"
alias ydl="yazi ~/Downloads"
alias ydt="yazi ~/Desktop"

# ┌─────────────────────────────────────────┐
# │           GIT (comprehensive)           │
# └─────────────────────────────────────────┘
# Status & Info
alias gs="git status -sb"
alias gss="git status"
alias glog="git log --oneline --decorate --graph -20"
alias glogall="git log --oneline --decorate --graph --all"
alias glog5="git log --oneline --decorate --graph -5"
alias glogp="git log --oneline --decorate --graph --pretty=format:'%C(yellow)%h%C(red)%d %C(white)%s %C(blue)(%cr) %C(cyan)<%an>%C(reset)' -20"
alias gd="git diff"
alias gds="git diff --staged"
alias gdw="git diff --word-diff"
alias gdt="git difftool"
alias gshow="git show"
alias gstats="git shortlog -sn --all --no-merges"
alias gwho="git log --format='%aN <%aE>' | sort -u"
alias gcount="git rev-list --count HEAD"
alias gbranches="git branch -a --sort=-committerdate"

# Add & Commit
alias ga="git add"
alias gaa="git add --all"
alias gap="git add -p"
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gcan="git commit --amend --no-edit"
alias gcf="git commit --fixup"

# Branch & Checkout
alias gb="git branch"
alias gbd="git branch -d"
alias gbD="git branch -D"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gsw="git switch"
alias gswc="git switch -c"
alias gmain="git checkout main 2>/dev/null || git checkout master"

# Push & Pull
alias gp="git pull --rebase --autostash"
alias gpush="git push"
alias gpf="git push --force-with-lease"
alias gpuo="git push -u origin HEAD"

# Stash
alias gst="git stash"
alias gstp="git stash pop"
alias gstl="git stash list"
alias gstd="git stash drop"
alias gsta="git stash apply"
alias gsts="git stash show -p"

# Merge & Rebase
alias gm="git merge"
alias grb="git rebase"
alias grbc="git rebase --continue"
alias grba="git rebase --abort"

# Reset & Clean
alias grh="git reset HEAD"
alias grhh="git reset HEAD --hard"
alias gclean="git clean -fd"
alias gnuke="git reset --hard HEAD && git clean -fd"

# Remote
alias gf="git fetch --all --prune"
alias grem="git remote -v"

# Tags
alias gtag="git tag"
alias gtagl="git tag -l --sort=-version:refname | head -20"

# Worktree
alias gwt="git worktree"
alias gwtl="git worktree list"

# Misc
alias gblame="git blame"
alias gcp="git cherry-pick"
alias gbisect="git bisect"

# ┌─────────────────────────────────────────┐
# │           GITHUB CLI (gh)               │
# └─────────────────────────────────────────┘
alias ghpr="gh pr create"
alias ghprl="gh pr list"
alias ghprv="gh pr view --web"
alias ghprc="gh pr checkout"
alias ghprm="gh pr merge"
alias ghi="gh issue create"
alias ghil="gh issue list"
alias ghiv="gh issue view --web"
alias ghr="gh repo view --web"
alias ghrc="gh repo clone"
alias ghdash="gh dash 2>/dev/null || gh pr status"

# ┌─────────────────────────────────────────┐
# │           DOCKER & COMPOSE              │
# └─────────────────────────────────────────┘
alias d="docker"
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dpsa="docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}'"
alias di="docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}'"
alias dlog="docker logs -f"
alias dexec="docker exec -it"
alias dstop="docker stop"
alias dstart="docker start"
alias drm="docker rm"
alias drmi="docker rmi"
alias dvol="docker volume ls"
alias dnet="docker network ls"
alias dinspect="docker inspect"
alias dtop="docker stats --no-stream"

# Docker Compose
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcr="docker compose restart"
alias dcl="docker compose logs -f"
alias dcps="docker compose ps"
alias dcb="docker compose build"
alias dcpull="docker compose pull"
alias dce="docker compose exec"

# Lazydocker
alias lzd="lazydocker"

# ┌─────────────────────────────────────────┐
# │         KUBERNETES (kubectl)            │
# └─────────────────────────────────────────┘
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kgd="kubectl get deployments"
alias kgn="kubectl get nodes"
alias kga="kubectl get all"
alias kgns="kubectl get namespaces"
alias kdp="kubectl describe pod"
alias kds="kubectl describe service"
alias kdd="kubectl describe deployment"
alias klog="kubectl logs -f"
alias kexec="kubectl exec -it"
alias kctx="kubectl config current-context"
alias kns="kubectl config set-context --current --namespace"
alias kapply="kubectl apply -f"
alias kdel="kubectl delete -f"

# ┌─────────────────────────────────────────┐
# │       SSH & REMOTE (server)             │
# └─────────────────────────────────────────┘
# Customize SERVER_HOST in ~/.zsh/local.zsh
alias server="ssh \${SERVER_HOST:-homeserver}"
alias server-root="ssh root@\${SERVER_HOST:-homeserver}"
alias server-docker="ssh \${SERVER_HOST:-homeserver} 'docker ps --format \"table {{.Names}}\t{{.Status}}\t{{.Ports}}\"'"
alias server-logs="ssh \${SERVER_HOST:-homeserver} 'docker compose logs -f'"
alias server-stats="ssh \${SERVER_HOST:-homeserver} 'htop || top'"
alias server-df="ssh \${SERVER_HOST:-homeserver} 'df -h'"
alias server-uptime="ssh \${SERVER_HOST:-homeserver} 'uptime && echo && free -h 2>/dev/null || vm_stat'"

# ┌─────────────────────────────────────────┐
# │         RSYNC (file transfer)           │
# └─────────────────────────────────────────┘
alias rsync-copy="rsync -avhP --stats"
alias rsync-move="rsync -avhP --stats --remove-source-files"
alias rsync-sync="rsync -avhP --stats --delete"
alias rsync-update="rsync -avhPu --stats"

# ┌─────────────────────────────────────────┐
# │            SYSTEM UTILS                 │
# └─────────────────────────────────────────┘
alias reload="exec zsh"
alias src="source ~/.zshrc && echo '  .zshrc reloaded'"
alias path='echo $PATH | tr ":" "\n" | nl'
alias myip="curl -s ifconfig.me && echo ''"
alias localip="ipconfig getifaddr en0 2>/dev/null || ip -4 addr show 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1"
alias flushdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder && echo '  DNS flushed'"
alias ports="lsof -iTCP -sTCP:LISTEN -n -P | awk 'NR==1 || !/com.doc/' | head -30"
alias listening="lsof -iTCP -sTCP:LISTEN -P -n"
alias cpu="top -l 1 -n 0 -s 0 | grep 'CPU usage'"
alias mem="top -l 1 -n 0 -s 0 | grep PhysMem"
alias topmem="ps aux | sort -nrk 4 | head -10"
alias topcpu="ps aux | sort -nrk 3 | head -10"
alias cleanup="brew cleanup && brew autoremove && echo '  Homebrew cleaned'"
alias brewup="brew update && brew upgrade && brew cleanup && echo '  Brew updated'"
alias ff="fastfetch"
alias clr="clear"
alias c="clear"
alias h="history"
alias hg="history | grep"
alias psg="ps aux | grep -v grep | grep"
alias sizeof="du -sh"
alias diskuse="df -h | grep -v tmpfs"
alias weather="curl -s 'wttr.in?format=3'"
alias weatherfull="curl -s 'wttr.in'"
alias j="jobs -l"
alias mkdir="mkdir -pv"
alias cp="cp -iv"
alias mv="mv -iv"
alias ln="ln -iv"
alias chmod="chmod -v"
alias chown="chown -v"
alias killport='f() { lsof -ti:$1 | xargs kill -9 2>/dev/null && echo "  Killed port $1" || echo "  Nothing on port $1" }; f'

# ┌─────────────────────────────────────────┐
# │          DEV TOOLS                      │
# └─────────────────────────────────────────┘
alias py="python3"
alias pip="pip3"
alias vact="source .venv/bin/activate 2>/dev/null || source venv/bin/activate 2>/dev/null || echo 'No venv found'"
alias npmls="npm list --depth=0"
alias npmlsg="npm list -g --depth=0"
alias bunx="bunx --bun"
alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfa="terraform apply"

# ┌─────────────────────────────────────────┐
# │          QUICK OPENS                    │
# └─────────────────────────────────────────┘
alias chrome="open -a 'Google Chrome'"
alias finder="open ."
alias code.="cursor . 2>/dev/null || code ."
alias claude.app='open -a "Claude"'
alias obs="open -a Obsidian"

# ┌─────────────────────────────────────────┐
# │          BAT (better cat)               │
# └─────────────────────────────────────────┘
if command -v bat &>/dev/null; then
  alias cat="bat --paging=never --style=plain"
  alias catn="bat --paging=never"
  alias catl="bat --paging=always"
  alias batdiff="bat --diff"
fi

# ┌─────────────────────────────────────────┐
# │      CLIPBOARD & MISC                   │
# └─────────────────────────────────────────┘
alias pbp="pbpaste"
alias pbc="pbcopy"
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]' | tee >(pbcopy) && echo '  (copied)'"
alias timestamp="date +%s | tee >(pbcopy) && echo '  (copied)'"
alias sha256="shasum -a 256"
alias urlencode='python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1]))"'
alias urldecode='python3 -c "import sys, urllib.parse; print(urllib.parse.unquote(sys.argv[1]))"'
alias json="python3 -m json.tool"
alias serve="python3 -m http.server 8080"
alias b64encode='python3 -c "import sys,base64;print(base64.b64encode(sys.argv[1].encode()).decode())"'
alias b64decode='python3 -c "import sys,base64;print(base64.b64decode(sys.argv[1]).decode())"'

# ┌─────────────────────────────────────────┐
# │     TRAEFIK (remote management)         │
# └─────────────────────────────────────────┘
alias traefik-dash="echo '  Opening Traefik dashboard...' && open http://\${SERVER_HOST:-homeserver}:8080"
alias traefik-logs="ssh \${SERVER_HOST:-homeserver} 'docker logs -f traefik 2>&1 | tail -50'"
alias traefik-routes="ssh \${SERVER_HOST:-homeserver} 'docker exec traefik traefik healthcheck 2>/dev/null; curl -s http://localhost:8080/api/http/routers 2>/dev/null | python3 -m json.tool 2>/dev/null || echo \"Use traefik-dash to view routes in browser\"'"
alias traefik-certs="ssh \${SERVER_HOST:-homeserver} 'docker exec traefik cat /letsencrypt/acme.json 2>/dev/null | python3 -c \"import sys,json; certs=json.load(sys.stdin); [print(c.get(\\\"domain\\\",{}).get(\\\"main\\\",\\\"?\\\")) for r in certs.values() if isinstance(r,dict) for c in r.get(\\\"Certificates\\\",[])]\" 2>/dev/null || echo \"Check traefik dashboard for cert info\"'"
alias portainer-dash="echo '  Opening Portainer...' && open https://\${SERVER_HOST:-homeserver}:9443"

# ┌─────────────────────────────────────────┐
# │            SUFFIX ALIASES               │
# └─────────────────────────────────────────┘
alias -s md=micro
alias -s txt=micro
alias -s json=micro
alias -s yml=micro
alias -s yaml=micro
alias -s toml=micro
alias -s conf=micro
alias -s log="bat --paging=always"
alias -s py=python3
alias -s js=node
alias -s ts="npx ts-node"
alias -s html="open"

# ┌─────────────────────────────────────────┐
# │          GLOBAL ALIASES                 │
# └─────────────────────────────────────────┘
alias -g G="| grep -i"
alias -g L="| less"
alias -g H="| head"
alias -g T="| tail"
alias -g W="| wc -l"
alias -g J="| python3 -m json.tool"
alias -g C="| pbcopy"
alias -g S="| sort"
alias -g U="| sort -u"
alias -g NE="2>/dev/null"
