# Headroom Studio prompt colors. Sourced after p10k.zsh; overrides its colors.
# Derived from headroom/DESIGN-SYSTEM.md: card surfaces as layered segment
# blocks, periwinkle #7c84f6 as the single accent, text tiers for structure,
# color only where it carries meaning (modified files, errors).
# Pairs with the headroom-dark iTerm2 preset (background #0b0b0f).

typeset -g POWERLEVEL9K_BACKGROUND='#15151f'
typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='%F{#28283a}'
typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='%F{#28283a}'

typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND='#15151f'
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='#eeeef6'

typeset -g POWERLEVEL9K_DIR_BACKGROUND='#1c1c28'
typeset -g POWERLEVEL9K_DIR_FOREGROUND='#7c84f6'

typeset -g POWERLEVEL9K_VCS_{CLEAN,MODIFIED,UNTRACKED,LOADING}_BACKGROUND='#15151f'
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#a8a8c0'
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#a8a8c0'
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#a0aaff'
typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR='#7c84f6'
typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR='#6e6e90'

# Colors inside the git segment text (consumed by my_git_formatter)
typeset -g P10K_GIT_META_COLOR='#6e6e90'
typeset -g P10K_GIT_CLEAN_COLOR='#a8a8c0'
typeset -g P10K_GIT_MODIFIED_COLOR='#a0aaff'
typeset -g P10K_GIT_UNTRACKED_COLOR='#5aabee'
typeset -g P10K_GIT_CONFLICTED_COLOR='#e8718a'

typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='#1c1c28'
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#a0aaff'

typeset -g POWERLEVEL9K_STATUS_{OK,OK_PIPE,ERROR,ERROR_SIGNAL,ERROR_PIPE}_BACKGROUND='#1c1c28'
typeset -g POWERLEVEL9K_STATUS_{OK,OK_PIPE}_FOREGROUND='#6e6e90'
typeset -g POWERLEVEL9K_STATUS_{ERROR,ERROR_SIGNAL,ERROR_PIPE}_FOREGROUND='#e8718a'

typeset -g POWERLEVEL9K_TIME_BACKGROUND='#15151f'
typeset -g POWERLEVEL9K_TIME_FOREGROUND='#6e6e90'

typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#3a3a52'
