# ── Prompt: Powerlevel10k + plugins, no framework ────────────────────────────
_brew_share="${HOMEBREW_PREFIX:-/opt/homebrew}/share"

source "$_brew_share/powerlevel10k/powerlevel10k.zsh-theme"
[[ -f "$ZSH_CONFIG_DIR/p10k.zsh" ]] && source "$ZSH_CONFIG_DIR/p10k.zsh"

# Color scheme override, see themes/. Empty string = p10k defaults.
typeset -g ZSH_PROMPT_THEME="headroom"   # headroom | gruvbox | catppuccin-mocha | nord
[[ -n $ZSH_PROMPT_THEME && -f "$ZSH_CONFIG_DIR/themes/$ZSH_PROMPT_THEME.zsh" ]] &&
  source "$ZSH_CONFIG_DIR/themes/$ZSH_PROMPT_THEME.zsh"

source "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# Dimmed ghost text; theme files may set their own matching grey
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="${ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE:-fg=245}"

# Syntax highlighting must be sourced last of all plugins
source "$_brew_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

unset _brew_share
