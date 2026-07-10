# claude-cmd — ask Claude for a single terminal command and nothing else.
#
# Usage:
#   claude-cmd "switch this repo to branch fix/foo for this session only"
#
# Prints ONE shell command to stdout, then the instance exits and you are
# returned to your prompt. Nothing else is printed, so the output is safe to
# copy/paste (or pipe) directly.
#
# Add `-c` / `--copy` to also copy the command to the macOS clipboard.

claude-cmd() {
  local copy=0
  if [[ "$1" == "-c" || "$1" == "--copy" ]]; then
    copy=1
    shift
  fi

  if [[ -z "$1" ]]; then
    print -u2 "usage: claude-cmd [-c|--copy] \"<what you want a command for>\""
    return 2
  fi

  local sys='You are a terminal command generator. Output EXACTLY ONE shell command that accomplishes the user'\''s request, and NOTHING else. Rules: no explanations, no commentary, no questions, no markdown, no code fences, no backticks, no leading/trailing prose. Output only the raw command on a single line (use && or ; to chain if truly needed). Assume macOS + zsh and the current working directory as context. If the request is ambiguous, choose the single most likely intended command rather than asking.'

  # Resolve the real claude binary (it may be exposed only as a shell alias).
  local bin="${CLAUDE_BIN:-}"
  if [[ -z "$bin" ]]; then
    if command -v claude >/dev/null 2>&1 && [[ -x "$(command -v claude)" ]]; then
      bin="$(command -v claude)"
    elif [[ -x "$HOME/.local/bin/claude" ]]; then
      bin="$HOME/.local/bin/claude"
    else
      print -u2 "claude-cmd: could not find the claude binary (set CLAUDE_BIN)"
      return 127
    fi
  fi

  # --system-prompt fully REPLACES the default prompt (so global output styles /
  # CLAUDE.md can't inject prose), --setting-sources "" skips user settings
  # (output style, OMC), and DISABLE_OMC=1 disables OMC hooks for this instance.
  local out
  out="$(DISABLE_OMC=1 "$bin" -p "$*" \
    --system-prompt "$sys" \
    --setting-sources "" \
    --exclude-dynamic-system-prompt-sections 2>/dev/null)"

  # Strip accidental code fences / backticks / whitespace, just in case.
  out="${out//\`\`\`sh/}"
  out="${out//\`\`\`bash/}"
  out="${out//\`\`\`zsh/}"
  out="${out//\`\`\`/}"
  out="${out//\`/}"
  out="${out##[[:space:]]#}"
  out="${out%%[[:space:]]#}"

  if [[ -z "$out" ]]; then
    print -u2 "claude-cmd: no command returned"
    return 1
  fi

  if (( copy )) && command -v pbcopy >/dev/null 2>&1; then
    printf '%s' "$out" | pbcopy
  fi

  print -r -- "$out"
}
