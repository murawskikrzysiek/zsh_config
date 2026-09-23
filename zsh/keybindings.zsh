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
bindkey '^[[3;3~' kill-word          # alt+fn+delete

# Ctrl+arrows: start / end of line. Mirrors Ctrl+Backspace, which deletes the
# whole line, so Ctrl means "line" and Option means "word" on every key. Also
# the only line jump on Terminal.app, where Cmd+arrows cannot be mapped. Every
# terminal here sends the xterm form on its own; nothing to map.
bindkey '^[[1;5D' beginning-of-line  # ctrl+left
bindkey '^[[1;5C' end-of-line        # ctrl+right

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

# ── Backspace variants ────────────────────────────────────────────────────────
# Option+Backspace deletes the previous word, Ctrl+Backspace the whole line.
# Terminals disagree on what they send, so both forms of each are bound rather
# than trusting one: the profiles in this repo send the first of each pair.
#
# ESC DEL is also zsh's own default for backward-kill-word; kept explicit so
# it is visible next to the rest.
bindkey '^[^?' backward-kill-word   # Option+Backspace: ESC DEL
bindkey '^[^H' backward-kill-word   # Option+Backspace: ESC BS, some terminals
#
# Ctrl+Backspace arrives as ^H (0x08) — the old ASCII backspace, while plain
# Backspace sends DEL (0x7f). Binding it costs Ctrl+H as delete-a-character,
# which Backspace itself does anyway. Drop this line to get Ctrl+H back.
bindkey '^H' kill-whole-line

# ── Edit long commands in $EDITOR ─────────────────────────────────────────────
# Ctrl+X Ctrl+E opens the current command line in the editor; saving returns
# it to the prompt.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
