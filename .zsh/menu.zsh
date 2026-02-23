#!/usr/bin/env zsh
# ╔══════════════════════════════════════════════════════════════════╗
# ║                  JORDAN'S COMMAND CENTER                         ║
# ╚══════════════════════════════════════════════════════════════════╝

# Interactive command menu using fzf
menu() {
  local commands=(
    # ── Navigation ──
    "NAV  │  repo          │ Jump to a project in ~/Repos (fzf)"
    "NAV  │  repos         │ cd to ~/Repos"
    "NAV  │  y             │ Yazi file browser (changes dir on exit)"
    "NAV  │  yr            │ Yazi in ~/Repos"
    "NAV  │  fe            │ Fuzzy find file and open in micro"
    "NAV  │  fg <pattern>  │ Fuzzy grep and open in micro"
    "NAV  │  fh            │ Fuzzy search command history"
    # ── Git ──
    "GIT  │  gs            │ Git status (short)"
    "GIT  │  glog          │ Git log graph (last 20)"
    "GIT  │  glogp         │ Git log pretty (with author/date)"
    "GIT  │  ga / gaa      │ Git add / add all"
    "GIT  │  gcm \"msg\"     │ Git commit with message"
    "GIT  │  gpush         │ Git push"
    "GIT  │  gpuo          │ Git push -u origin HEAD"
    "GIT  │  gp            │ Git pull (rebase+autostash)"
    "GIT  │  gcob <name>   │ Git checkout new branch"
    "GIT  │  gst / gstp    │ Git stash / stash pop"
    "GIT  │  gf            │ Git fetch all + prune"
    "GIT  │  gd / gds      │ Git diff / diff staged"
    "GIT  │  gclone <url>  │ Clone repo to ~/Repos and cd into it"
    # ── GitHub ──
    "GH   │  ghpr          │ Create pull request"
    "GH   │  ghprl         │ List pull requests"
    "GH   │  ghprv         │ View PR in browser"
    "GH   │  ghi           │ Create issue"
    "GH   │  ghil          │ List issues"
    "GH   │  ghr           │ View repo in browser"
    # ── Docker ──
    "DOCK │  dps           │ Docker containers (formatted)"
    "DOCK │  di            │ Docker images (formatted)"
    "DOCK │  dcu           │ Docker compose up -d"
    "DOCK │  dcd           │ Docker compose down"
    "DOCK │  dcr           │ Docker compose restart"
    "DOCK │  dcl           │ Docker compose logs -f"
    "DOCK │  dlog <name>   │ Docker container logs -f"
    "DOCK │  dexec <name>  │ Docker exec -it (bash/sh)"
    "DOCK │  dtop          │ Docker stats (snapshot)"
    "DOCK │  lzd           │ Launch lazydocker"
    "DOCK │  docker-nuke   │ Full Docker cleanup (careful!)"
    # ── Server & SSH ──
    "SSH  │  server        │ SSH to homeserver"
    "SSH  │  server-docker │ Show remote Docker containers"
    "SSH  │  server-stats  │ Remote system stats"
    "SSH  │  server-df     │ Remote disk usage"
    "SSH  │  pushsync      │ Rsync push to server"
    "SSH  │  pullsync      │ Rsync pull from server"
    # ── Traefik ──
    "TRAF │  traefik-dash  │ Open Traefik dashboard"
    "TRAF │  traefik-logs  │ Tail Traefik logs"
    "TRAF │  traefik-routes│ Show Traefik HTTP routes"
    "TRAF │  traefik-stacks│ List deployed stacks"
    "TRAF │  traefik-restart│ Restart Traefik"
    "TRAF │  portainer-dash│ Open Portainer dashboard"
    # ── Dev Tools ──
    "DEV  │  devinfo       │ Detect project type & show info"
    "DEV  │  venv create   │ Create Python venv"
    "DEV  │  venv on/off   │ Activate/deactivate venv"
    "DEV  │  newproject    │ Scaffold new project in ~/Repos"
    "DEV  │  quickserve    │ Quick HTTP server"
    "DEV  │  envfile       │ .env file helper (show/edit/template)"
    "DEV  │  gitignore     │ Generate .gitignore"
    "DEV  │  cheat <cmd>   │ Lookup cheat.sh for command"
    # ── Kubernetes ──
    "K8S  │  k             │ kubectl"
    "K8S  │  kgp           │ Get pods"
    "K8S  │  kgs           │ Get services"
    "K8S  │  kgd           │ Get deployments"
    "K8S  │  klog <pod>    │ Pod logs -f"
    "K8S  │  kexec <pod>   │ Exec into pod"
    "K8S  │  kctx          │ Current context"
    # ── System ──
    "SYS  │  ff            │ Fastfetch system info"
    "SYS  │  myip          │ Show public IP"
    "SYS  │  localip       │ Show local IP"
    "SYS  │  ports         │ Show listening ports"
    "SYS  │  portcheck     │ Check if host:port is open"
    "SYS  │  killport      │ Kill process on port"
    "SYS  │  brewup        │ Update Homebrew + packages"
    "SYS  │  cleanup       │ Homebrew cleanup"
    "SYS  │  flushdns      │ Flush DNS cache"
    "SYS  │  topmem        │ Top memory consumers"
    "SYS  │  topcpu        │ Top CPU consumers"
    "SYS  │  diskuse       │ Disk usage overview"
    "SYS  │  speedtest     │ Quick bandwidth test"
    "SYS  │  weather       │ Current weather"
    "SYS  │  weatherfull   │ Full weather forecast"
    # ── Utilities ──
    "UTIL │  e <file>      │ Edit in micro"
    "UTIL │  extract <file>│ Extract any archive"
    "UTIL │  backup        │ Backup shell configs"
    "UTIL │  timer <sec>   │ Countdown timer w/ notification"
    "UTIL │  notify        │ macOS notification"
    "UTIL │  uuid          │ Generate UUID (copies to clipboard)"
    "UTIL │  timestamp     │ Unix timestamp (copies to clipboard)"
    "UTIL │  colors256     │ Show terminal color palette"
    "UTIL │  b64encode     │ Base64 encode string"
    "UTIL │  b64decode     │ Base64 decode string"
    "UTIL │  json          │ Pretty-print JSON (pipe)"
    "UTIL │  sizeof <path> │ Show size of file/directory"
    # ── File Listing ──
    "LIST │  ll            │ Detailed list (git, icons, times)"
    "LIST │  la            │ List all (including hidden)"
    "LIST │  lt            │ Tree view (3 levels)"
    "LIST │  lt2           │ Tree view (2 levels)"
    "LIST │  lsize         │ List sorted by size"
    "LIST │  lmod          │ List sorted by modified"
    "LIST │  lext          │ List sorted by extension"
    "LIST │  ldot          │ List dotfiles only"
    # ── Config ──
    "CONF │  zshrc         │ Edit ~/.zshrc"
    "CONF │  aliases       │ Edit aliases file"
    "CONF │  funcs         │ Edit functions file"
    "CONF │  p10kcfg       │ Edit p10k config"
    "CONF │  sshcfg        │ Edit SSH config"
    "CONF │  reload        │ Restart shell"
    "CONF │  src           │ Source .zshrc"
  )

  local selected
  selected=$(printf '%s\n' "${commands[@]}" | \
    fzf --height 80% --reverse --border rounded \
        --header "  Jordan's Command Center  ─  Type to search" \
        --header-first \
        --prompt "  " \
        --color "header:yellow:bold,border:blue,pointer:red,hl:lime,hl+:lime:bold,info:yellow" \
        --color "prompt:blue:bold,fg+:white:bold,bg+:236" \
        --preview-window hidden)

  if [[ -n "$selected" ]]; then
    local cmd=$(echo "$selected" | awk -F'│' '{print $2}' | xargs | awk '{print $1}')
    echo "\033[2m> $cmd\033[0m"
    eval "$cmd"
  fi
}

# Simple text command reference (no fzf needed)
commands() {
  local BLUE='\033[1;34m'
  local RED='\033[1;31m'
  local WHITE='\033[1;37m'
  local ORANGE='\033[38;5;208m'
  local YELLOW='\033[1;33m'
  local LIME='\033[38;5;118m'
  local CYAN='\033[1;36m'
  local DIM='\033[2m'
  local RESET='\033[0m'
  local BOLD='\033[1m'

  echo ""
  echo "${BLUE}${BOLD}══════════════════════════════════════════════════════════════${RESET}"
  echo "${BLUE}${BOLD}                   JORDAN'S COMMAND CENTER                    ${RESET}"
  echo "${BLUE}${BOLD}══════════════════════════════════════════════════════════════${RESET}"
  echo ""
  echo "${ORANGE}${BOLD}  Navigation${RESET}"
  echo "  ${LIME}repo${RESET}${DIM} ................ ${RESET}Jump to project ${DIM}(fzf)${RESET}"
  echo "  ${LIME}y${RESET}${DIM} ................... ${RESET}Yazi file browser"
  echo "  ${LIME}fe${RESET}${DIM} .................. ${RESET}Find file + open in micro"
  echo "  ${LIME}fg${RESET}${DIM} .................. ${RESET}Grep content + open in micro"
  echo "  ${LIME}fh${RESET}${DIM} .................. ${RESET}Search command history"
  echo ""
  echo "${RED}${BOLD}  Git${RESET}"
  echo "  ${LIME}gs${RESET} ${DIM}status${RESET}  ${LIME}glog${RESET} ${DIM}graph${RESET}  ${LIME}ga${RESET}/${LIME}gaa${RESET} ${DIM}add${RESET}  ${LIME}gcm${RESET} ${DIM}commit${RESET}"
  echo "  ${LIME}gpush${RESET} ${DIM}push${RESET}  ${LIME}gp${RESET} ${DIM}pull${RESET}  ${LIME}gst${RESET}/${LIME}gstp${RESET} ${DIM}stash${RESET}  ${LIME}gd${RESET}/${LIME}gds${RESET} ${DIM}diff${RESET}"
  echo "  ${LIME}gclone${RESET} ${DIM}clone to ~/Repos${RESET}  ${LIME}gcob${RESET} ${DIM}new branch${RESET}"
  echo ""
  echo "${YELLOW}${BOLD}  GitHub${RESET}"
  echo "  ${LIME}ghpr${RESET} ${DIM}create PR${RESET}  ${LIME}ghprl${RESET} ${DIM}list PRs${RESET}  ${LIME}ghi${RESET} ${DIM}new issue${RESET}  ${LIME}ghr${RESET} ${DIM}view repo${RESET}"
  echo ""
  echo "${CYAN}${BOLD}  Docker${RESET}"
  echo "  ${LIME}dps${RESET} ${DIM}containers${RESET}  ${LIME}di${RESET} ${DIM}images${RESET}  ${LIME}dcu${RESET}/${LIME}dcd${RESET} ${DIM}compose up/down${RESET}"
  echo "  ${LIME}dcl${RESET} ${DIM}logs${RESET}  ${LIME}dexec${RESET} ${DIM}exec into${RESET}  ${LIME}lzd${RESET} ${DIM}lazydocker${RESET}  ${LIME}dtop${RESET} ${DIM}stats${RESET}"
  echo ""
  echo "${ORANGE}${BOLD}  Server & Traefik${RESET}"
  echo "  ${LIME}server${RESET} ${DIM}ssh${RESET}  ${LIME}server-docker${RESET} ${DIM}remote ps${RESET}  ${LIME}server-stats${RESET} ${DIM}htop${RESET}"
  echo "  ${LIME}pushsync${RESET}/${LIME}pullsync${RESET} ${DIM}rsync files${RESET}"
  echo "  ${LIME}traefik-dash${RESET} ${DIM}dashboard${RESET}  ${LIME}traefik-logs${RESET}  ${LIME}traefik-stacks${RESET}"
  echo "  ${LIME}portainer-dash${RESET} ${DIM}portainer UI${RESET}"
  echo ""
  echo "${WHITE}${BOLD}  Dev Tools${RESET}"
  echo "  ${LIME}devinfo${RESET} ${DIM}project detection${RESET}  ${LIME}venv${RESET} ${DIM}python env${RESET}  ${LIME}newproject${RESET} ${DIM}scaffold${RESET}"
  echo "  ${LIME}cheat${RESET} ${DIM}cheatsheet${RESET}  ${LIME}gitignore${RESET} ${DIM}generate${RESET}  ${LIME}envfile${RESET} ${DIM}.env helper${RESET}"
  echo ""
  echo "${BLUE}${BOLD}  System${RESET}"
  echo "  ${LIME}ff${RESET} ${DIM}fastfetch${RESET}  ${LIME}myip${RESET}/${LIME}localip${RESET}  ${LIME}ports${RESET} ${DIM}listening${RESET}  ${LIME}killport${RESET}"
  echo "  ${LIME}brewup${RESET} ${DIM}update all${RESET}  ${LIME}flushdns${RESET}  ${LIME}speedtest${RESET}  ${LIME}weather${RESET}"
  echo ""
  echo "${YELLOW}${BOLD}  Files${RESET}"
  echo "  ${LIME}ll${RESET} ${DIM}detailed${RESET}  ${LIME}lt${RESET} ${DIM}tree${RESET}  ${LIME}lsize${RESET} ${DIM}by size${RESET}  ${LIME}lmod${RESET} ${DIM}by date${RESET}  ${LIME}ldot${RESET} ${DIM}dotfiles${RESET}"
  echo ""
  echo "${RED}${BOLD}  Quick Edit${RESET}"
  echo "  ${LIME}zshrc${RESET}  ${LIME}aliases${RESET}  ${LIME}funcs${RESET}  ${LIME}p10kcfg${RESET}  ${LIME}sshcfg${RESET}  ${LIME}hosts${RESET}"
  echo ""
  echo "${DIM}  Tip: Type ${RESET}${LIME}menu${RESET}${DIM} for interactive search  │  ${RESET}${LIME}reload${RESET}${DIM} to restart shell${RESET}"
  echo ""
}
