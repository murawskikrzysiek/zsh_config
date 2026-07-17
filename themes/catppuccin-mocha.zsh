# Catppuccin Mocha prompt colors. Sourced after p10k.zsh; overrides its colors.
# Palette: https://catppuccin.com/palette
# Pairs best with an iTerm2 background of #1e1e2e.

typeset -g POWERLEVEL9K_BACKGROUND='#313244'
typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='%F{#6c7086}'
typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='%F{#6c7086}'

typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='#cdd6f4'
typeset -g POWERLEVEL9K_DIR_FOREGROUND='#89b4fa'

typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#a6e3a1'
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#a6e3a1'
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#f9e2af'
typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR='#a6e3a1'
typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR='#9399b2'

# Colors inside the git segment text (consumed by my_git_formatter)
typeset -g P10K_GIT_META_COLOR='#7f849c'
typeset -g P10K_GIT_CLEAN_COLOR='#a6e3a1'
typeset -g P10K_GIT_MODIFIED_COLOR='#f9e2af'
typeset -g P10K_GIT_UNTRACKED_COLOR='#89dceb'
typeset -g P10K_GIT_CONFLICTED_COLOR='#f38ba8'

typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#f9e2af'
typeset -g POWERLEVEL9K_STATUS_{OK,OK_PIPE}_FOREGROUND='#a6e3a1'
typeset -g POWERLEVEL9K_STATUS_{ERROR,ERROR_SIGNAL,ERROR_PIPE}_FOREGROUND='#f38ba8'
typeset -g POWERLEVEL9K_TIME_FOREGROUND='#9399b2'

typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#585b70'
