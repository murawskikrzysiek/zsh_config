# Line-editor keybindings. The byte sequences these react to are produced by
# the terminal: `keybind` lines in ghostty/config, or the iTerm2 key mappings
# in iterm/headroom.profile.json. Both send the same readline-style sequences
# for option/cmd + arrows and delete, so this file is terminal-agnostic.

# ── Word granularity ──────────────────────────────────────────────────────────
# bash-style words: only alphanumerics. Option+arrow / option+delete stop at
# every / . - _ etc., so paths are traversed one component at a time.
autoload -Uz select-word-style
select-word-style bash

# ── Sequences terminals send on their own ─────────────────────────────────────
# Ghostty and iTerm2 are configured to send ESC b / ESC f, which the emacs
# keymap already maps to backward-word / forward-word. Terminals that cannot be
# remapped send their own thing instead — Apple's Terminal.app refuses Cmd in
# its keyboard map entirely, and ssh sessions land on whatever the far end
# sends. Binding all the common forms costs nothing and makes word motion work
# everywhere.
bindkey '^[[1;3D' backward-word      # alt+left  (xterm style)
bindkey '^[[1;3C' forward-word       # alt+right
bindkey '^[^[[D'  backward-word      # alt+left  (ESC-prefixed, Option-as-Meta)
bindkey '^[^[[C'  forward-word
bindkey '^[[1;5D' backward-word      # ctrl+left, the habit from Linux
bindkey '^[[1;5C' forward-word
bindkey '^[[3;3~' kill-word          # alt+fn+delete

# Home / End, including the fn+arrow form. On Terminal.app these replace the
# Cmd+arrow bindings that cannot be mapped there.
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

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
