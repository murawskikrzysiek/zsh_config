# Line-editor keybindings. The byte sequences these react to are produced by
# the iTerm2 key mappings in iterm/headroom.profile.json (option/cmd + arrows
# and delete send readline-style sequences).

# ── Word granularity ──────────────────────────────────────────────────────────
# bash-style words: only alphanumerics. Option+arrow / option+delete stop at
# every / . - _ etc., so paths are traversed one component at a time.
autoload -Uz select-word-style
select-word-style bash

# ── Ctrl+Z toggle ─────────────────────────────────────────────────────────────
# Empty command line: resume the last suspended job (Ctrl+Z out, Ctrl+Z back).
# Non-empty: stash the half-typed line, restore it after the next command.
_fancy-ctrl-z() {
  if [[ -z $BUFFER ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
  fi
}
zle -N _fancy-ctrl-z
bindkey '^Z' _fancy-ctrl-z

# ── macOS-style line deletion ─────────────────────────────────────────────────
# Cmd+Delete sends ^U; on a Mac that means "delete to start of line",
# not zsh's default "delete the whole line".
bindkey '^U' backward-kill-line

# ── Edit long commands in $EDITOR ─────────────────────────────────────────────
# Ctrl+X Ctrl+E opens the current command line in the editor; saving returns
# it to the prompt.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
