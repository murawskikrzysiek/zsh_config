# ── Start inside tmux, optionally ────────────────────────────────────────────
# Off unless you ask for it: put ZSH_AUTO_TMUX=1 in ~/.zshrc.local, which is
# sourced just before this file.
#
# Worth turning on when the terminal has no panes of its own (Apple's
# Terminal.app) or when work should survive a closed window. The real payoff
# is that you are always already inside tmux: a shell started outside it
# cannot be moved in afterwards, so the "I should have run this in tmux"
# moment stops happening.
#
# One consequence: every window attaching to the same session sees the same
# panes, mirrored. For a second, independent window, name its session:
#   ZSH_AUTO_TMUX_SESSION=side
#
# Leaving tmux drops you back to this shell rather than closing the window.

[[ ${ZSH_AUTO_TMUX:-0} == 1 ]] || return 0
[[ -o interactive ]] || return 0      # never in scripts or tool-spawned shells
[[ -z $TMUX ]] || return 0            # already inside; do not nest
[[ $TERM_PROGRAM != vscode ]] || return 0   # IDE terminals run their own panes
command -v tmux >/dev/null || return 0

tmux new-session -A -s "${ZSH_AUTO_TMUX_SESSION:-main}"
