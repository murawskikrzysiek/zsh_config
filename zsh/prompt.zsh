# ── Prompt: Powerlevel10k + plugins, no framework ────────────────────────────
_brew_share="${HOMEBREW_PREFIX:-/opt/homebrew}/share"

source "$_brew_share/powerlevel10k/powerlevel10k.zsh-theme"
[[ -f "$ZSH_CONFIG_DIR/p10k.zsh" ]] && source "$ZSH_CONFIG_DIR/p10k.zsh"

source "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=245"   # dimmed ghost text

# Syntax highlighting must be sourced last of all plugins
source "$_brew_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

unset _brew_share
