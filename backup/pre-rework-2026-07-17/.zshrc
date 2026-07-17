# Load environment
source ~/.config/zsh/env.zsh

# Load tools
source ~/.config/zsh/tools.zsh

# Load aliases
source ~/.config/zsh/aliases.zsh

# Prompt
eval "$(starship init zsh)"
export PATH="$HOME/.local/bin:$PATH"
