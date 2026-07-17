# ── Completions ───────────────────────────────────────────────────────────────
# Dump file lives in the cache dir so neither $HOME nor the repo collects it.
autoload -Uz compinit
_zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
mkdir -p "${_zcompdump:h}"
# Full (security-checked) rebuild at most once per day, fast -C otherwise
if [[ -n $_zcompdump(#qN.mh+24) || ! -e $_zcompdump ]]; then
  compinit -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump

# Case-insensitive completion, partial-word matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── zoxide (smart cd) ─────────────────────────────────────────────────────────
eval "$(zoxide init zsh)"   # replaces cd directly — type `cd foo` or just `foo`

# ── fzf (fuzzy finder) ────────────────────────────────────────────────────────
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

# ── atuin (shell history) ─────────────────────────────────────────────────────
# After fzf on purpose: atuin owns Ctrl-R, fzf keeps Ctrl-T / Alt-C
eval "$(atuin init zsh)"

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
