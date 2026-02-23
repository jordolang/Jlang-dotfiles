#!/usr/bin/env zsh
# ╔══════════════════════════════════════════════════════════════════╗
# ║                    JORDAN'S TERMINAL GREETING                    ║
# ╚══════════════════════════════════════════════════════════════════╝

_jl_greeting() {
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

  # ── Figlet Banner ──
  if command -v figlet &>/dev/null && command -v lolcat &>/dev/null; then
    echo ""
    figlet -f slant "JordanLang" 2>/dev/null | lolcat -f -S 20 2>/dev/null
  else
    echo ""
    echo "${BLUE}     ╦╔═╗╦═╗╔╦╗╔═╗╔╗╔  ${RED}╦  ╔═╗╔╗╔╔═╗${RESET}"
    echo "${BLUE}     ║║ ║╠╦╝ ║║╠═╣║║║  ${RED}║  ╠═╣║║║║ ╦${RESET}"
    echo "${BLUE}    ╚╝╚═╝╩╚══╩╝╩ ╩╝╚╝  ${RED}╩═╝╩ ╩╝╚╝╚═╝${RESET}"
  fi

  # ── System Info Line ──
  local host_name=$(hostname -s 2>/dev/null || hostname)
  local user_name=$(whoami)
  local os_version=$(sw_vers -productVersion 2>/dev/null || uname -r)
  local uptime_str=$(uptime | sed 's/.*up //' | sed 's/,.*//' | xargs)
  local shell_ver="${ZSH_VERSION}"
  local cpu_cores=$(sysctl -n hw.ncpu 2>/dev/null || nproc 2>/dev/null || echo "?")
  local mem_total=$(( $(sysctl -n hw.memsize 2>/dev/null || echo 0) / 1073741824 ))
  local disk_usage=$(df -h / 2>/dev/null | awk 'NR==2{print $5}')
  local local_ip=$(ipconfig getifaddr en0 2>/dev/null || ip -4 addr show 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1 || echo "N/A")
  local git_ver=$(git --version 2>/dev/null | awk '{print $3}')
  local node_ver=$(node --version 2>/dev/null || echo "N/A")
  local python_ver=$(python3 --version 2>/dev/null | awk '{print $2}' || echo "N/A")
  local docker_status="off"
  if docker info &>/dev/null 2>&1; then
    docker_status="${LIME}running${RESET}"
  else
    docker_status="${DIM}stopped${RESET}"
  fi

  local repo_count=$(ls -d ~/Repos/*/ 2>/dev/null | wc -l | xargs)
  local current_date=$(date "+%A, %B %d, %Y")
  local current_time=$(date "+%I:%M %p %Z")

  echo ""
  echo "${DIM}──────────────────────────────────────────────────────────────────${RESET}"
  echo ""
  echo "  ${ORANGE}  ${BOLD}${user_name}${RESET}${DIM}@${RESET}${CYAN}${host_name}${RESET}    ${DIM}│${RESET}   ${YELLOW}${current_date}${RESET}  ${DIM}${current_time}${RESET}"
  echo ""
  echo "  ${BLUE}  macOS ${os_version}${RESET}       ${DIM}│${RESET}   ${WHITE}  Uptime: ${uptime_str}${RESET}"
  echo "  ${LIME}  Zsh ${shell_ver}${RESET}           ${DIM}│${RESET}   ${WHITE}  CPU: ${cpu_cores} cores  RAM: ${mem_total}GB  Disk: ${disk_usage}${RESET}"
  echo "  ${RED}  Git ${git_ver}${RESET}        ${DIM}│${RESET}   ${WHITE}  IP: ${local_ip}${RESET}"
  echo "  ${YELLOW}  Node ${node_ver}${RESET}       ${DIM}│${RESET}   ${WHITE}  Python ${python_ver}${RESET}"
  echo "  ${ORANGE}󰡨  Docker: ${docker_status}${RESET}       ${DIM}│${RESET}   ${WHITE}  Repos: ${repo_count} projects${RESET}"
  echo ""
  echo "${DIM}──────────────────────────────────────────────────────────────────${RESET}"
  echo ""
  echo "  ${BLUE}${BOLD}Quick Actions:${RESET}  ${LIME}menu${RESET}${DIM} command center${RESET}  ${DIM}│${RESET}  ${YELLOW}repo${RESET}${DIM} jump to project${RESET}  ${DIM}│${RESET}  ${CYAN}commands${RESET}${DIM} cheatsheet${RESET}"
  echo ""
}

# Only show greeting for interactive, non-nested shells
if [[ $- == *i* ]] && [[ -z "$INSIDE_YAZI" ]] && [[ -z "$VSCODE_INJECTION" ]]; then
  _jl_greeting
fi
