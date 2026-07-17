# Headroom Studio prompt colors. Sourced after p10k.zsh; overrides its colors.
# Derived from headroom/DESIGN-SYSTEM.md: card surfaces as layered segment
# blocks, periwinkle #7c84f6 as the single accent, text tiers for structure,
# color only where it carries meaning (modified files, errors).
# Pairs with the headroom-dark iTerm2 preset (background #0b0b0f).

# Segment surfaces: border tones, one step brighter than the card tones so
# the bar reads as a bar against the #0b0b0f terminal background.
typeset -g POWERLEVEL9K_BACKGROUND='#1c1c28'
typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='%F{#3a3a52}'
typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='%F{#3a3a52}'

typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND='#1c1c28'
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='#eeeef6'

# Uniform periwinkle path: kill the base config's bold bright-cyan anchor
typeset -g POWERLEVEL9K_DIR_BACKGROUND='#28283a'
typeset -g POWERLEVEL9K_DIR_FOREGROUND='#7c84f6'
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='#7c84f6'
typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=false
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#6e6e90'

typeset -g POWERLEVEL9K_VCS_{CLEAN,MODIFIED,UNTRACKED,LOADING}_BACKGROUND='#1c1c28'
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

typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='#28283a'
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#a0aaff'

typeset -g POWERLEVEL9K_STATUS_{OK,OK_PIPE,ERROR,ERROR_SIGNAL,ERROR_PIPE}_BACKGROUND='#28283a'
typeset -g POWERLEVEL9K_STATUS_{OK,OK_PIPE}_FOREGROUND='#6e6e90'
typeset -g POWERLEVEL9K_STATUS_{ERROR,ERROR_SIGNAL,ERROR_PIPE}_FOREGROUND='#e8718a'

typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#1c1c28'
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#a8a8c0'

typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND='#1c1c28'
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='#a0aaff'

typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND='#28283a'
typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND='#a8a8c0'
typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='#e8718a'

typeset -g POWERLEVEL9K_TIME_BACKGROUND='#1c1c28'
typeset -g POWERLEVEL9K_TIME_FOREGROUND='#6e6e90'

# Transient prompt ❯: brand accent instead of green (green stays reserved)
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#7c84f6'
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#e8718a'

typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#3a3a52'

# eza listing on the same tiers: quiet grey metadata, accent-soft sizes,
# functional color only in the git column. Overrides tools.zsh's default.
export EZA_COLORS="uu=38;2;168;168;192:gu=38;2;110;110;144:un=38;2;232;113;138:sn=38;2;160;170;255:sb=38;2;110;110;144:da=38;2;110;110;144:ur=38;2;110;110;144:uw=38;2;110;110;144:ux=38;2;168;168;192:ue=38;2;168;168;192:gr=38;2;110;110;144:gw=38;2;110;110;144:gx=38;2;168;168;192:tr=38;2;110;110;144:tw=38;2;110;110;144:tx=38;2;168;168;192:xx=38;2;58;58;82:xa=38;2;58;58;82:im=4;38;2;160;170;255"
