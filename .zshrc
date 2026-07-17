# Powerlevel10k instant prompt. Must stay at the very top of .zshrc.
# Anything that prints to the console during startup must go below this block.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Locate this config dir. Works whether ~/.zshrc is a symlink to this file
# or the repo is used directly via ZDOTDIR.
ZSH_CONFIG_DIR="${${(%):-%x}:A:h}"

source "$ZSH_CONFIG_DIR/zsh/env.zsh"
source "$ZSH_CONFIG_DIR/zsh/tools.zsh"
source "$ZSH_CONFIG_DIR/zsh/aliases.zsh"
source "$ZSH_CONFIG_DIR/zsh/functions.zsh"
source "$ZSH_CONFIG_DIR/zsh/python.zsh"
source "$ZSH_CONFIG_DIR/zsh/prompt.zsh"   # keep last: syntax highlighting must load after everything else
