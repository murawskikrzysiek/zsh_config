# ── Homebrew ──────────────────────────────────────────────────────────────────
# Must come first: everything else depends on it
eval "$(/opt/homebrew/bin/brew shellenv)"

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ── Editor ────────────────────────────────────────────────────────────────────
export EDITOR="${EDITOR:-nano}"

# ── History ───────────────────────────────────────────────────────────────────
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

setopt HIST_IGNORE_ALL_DUPS   # deduplicate history entries
setopt HIST_IGNORE_SPACE      # don't save commands prefixed with space
setopt SHARE_HISTORY          # share history across sessions
setopt HIST_VERIFY            # confirm before running history expansion

# ── Navigation ────────────────────────────────────────────────────────────────
setopt AUTO_CD                # type a dir name to cd into it
setopt EXTENDED_GLOB          # extended glob patterns
setopt GLOB_DOTS              # include dotfiles in globs
setopt NO_CASE_GLOB           # case-insensitive globbing

# ── Input ─────────────────────────────────────────────────────────────────────
setopt INTERACTIVE_COMMENTS   # allow # comments in interactive shell
