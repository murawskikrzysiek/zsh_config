# ── Start inside tmux, optionally ────────────────────────────────────────────
# Off unless you ask for it: put ZSH_AUTO_TMUX=1 in ~/.zshrc.local, which is
# sourced just before this file.
#
# Even then it only fires in terminals that have no panes of their own. tmux
# is there to supply what Apple's Terminal.app lacks; iTerm2 and Ghostty split
# natively, and starting tmux in them would just be a second, competing
# mechanism on the same screen.
#
#   ZSH_AUTO_TMUX_TERMINALS="Apple_Terminal"          the default
#   ZSH_AUTO_TMUX_TERMINALS="Apple_Terminal ghostty"  add more, space separated
#   ZSH_AUTO_TMUX_TERMINALS="all"                     every terminal
#
# $TERM_PROGRAM is what the terminal calls itself: Apple_Terminal, iTerm.app,
# ghostty, WezTerm, vscode.
#
# The real payoff is that you are always already inside tmux: a shell started
# outside it cannot be moved in afterwards, so the "I should have run this in
# tmux" moment stops happening.
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

# Terminal allow-list. Written without a helper variable: this file is sourced
# into the interactive shell, where `local` is global and would leave the name
# behind. Unset TERM_PROGRAM (plain tty, some ssh clients) matches nothing, so
# nothing starts by surprise.
if [[ ${ZSH_AUTO_TMUX_TERMINALS:-Apple_Terminal} != all ]]; then
  [[ " ${ZSH_AUTO_TMUX_TERMINALS:-Apple_Terminal} " == *" ${TERM_PROGRAM:-none} "* ]] \
    || return 0
fi

tmux new-session -A -s "${ZSH_AUTO_TMUX_SESSION:-main}"
