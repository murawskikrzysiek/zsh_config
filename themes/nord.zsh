# Nord prompt colors. Sourced after p10k.zsh; overrides its colors.
# Palette: https://www.nordtheme.com/docs/colors-and-palettes
# Pairs best with an iTerm2 background of #2e3440.

typeset -g POWERLEVEL9K_BACKGROUND='#3b4252'
typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='%F{#616e88}'
typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='%F{#616e88}'

typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='#eceff4'
typeset -g POWERLEVEL9K_DIR_FOREGROUND='#88c0d0'

typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#a3be8c'
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#a3be8c'
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#ebcb8b'
typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR='#a3be8c'
typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR='#616e88'

# Colors inside the git segment text (consumed by my_git_formatter)
typeset -g P10K_GIT_META_COLOR='#616e88'
typeset -g P10K_GIT_CLEAN_COLOR='#a3be8c'
typeset -g P10K_GIT_MODIFIED_COLOR='#ebcb8b'
typeset -g P10K_GIT_UNTRACKED_COLOR='#81a1c1'
typeset -g P10K_GIT_CONFLICTED_COLOR='#bf616a'

typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#b48ead'
typeset -g POWERLEVEL9K_STATUS_{OK,OK_PIPE}_FOREGROUND='#a3be8c'
typeset -g POWERLEVEL9K_STATUS_{ERROR,ERROR_SIGNAL,ERROR_PIPE}_FOREGROUND='#bf616a'
typeset -g POWERLEVEL9K_TIME_FOREGROUND='#81a1c1'
