# ~/.config/zsh/tools.zsh

# ── Completions ───────────────────────────────────────────────────────────────
autoload -Uz compinit
# Only rebuild completion cache once per day
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Case-insensitive completion, partial-word matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── zoxide (smart cd) ─────────────────────────────────────────────────────────
eval "$(zoxide init zsh)"   # replaces cd directly — type `cd foo` or just `foo`

# ── atuin (shell history) ─────────────────────────────────────────────────────
eval "$(atuin init zsh)"

# ── fzf (fuzzy finder) ────────────────────────────────────────────────────────
# Install: brew install fzf
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
  # Use fd for fzf file listing (respects .gitignore)
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  # Preview files with bat, directories with eza
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}' --preview-window=right:50%"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {}'"
fi

# ── bat configuration ─────────────────────────────────────────────────────────
export BAT_THEME="Catppuccin Mocha"   # or: TwoDark, Dracula, base16
export BAT_STYLE="numbers,changes,header"

# ── eza configuration ─────────────────────────────────────────────────────────
export EZA_COLORS="da=36"             # date in cyan

# ── uv completions ────────────────────────────────────────────────────────────
if command -v uv &>/dev/null; then
  eval "$(uv generate-shell-completion zsh)"
fi

# ── ripgrep config ────────────────────────────────────────────────────────────
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"
