# ~/.config/zsh/aliases.zsh

# ── Modern replacements ───────────────────────────────────────────────────────
alias ls="eza --icons"
alias ll="eza -lah --icons --git"        # long list with git status
alias la="eza -a --icons"                # show hidden
alias lt="eza --tree --level=2 --icons"  # tree (2 levels)
alias ltt="eza --tree --level=3 --icons" # tree (3 levels)
#alias cat="bat"
alias grep="rg"
alias find="fd"

# ── Navigation ────────────────────────────────────────────────────────────────
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -="cd -"                        # go back to last dir

# ── Git shortcuts ─────────────────────────────────────────────────────────────
alias g="git"
alias gs="git status -sb"               # compact status
alias gc="git commit"
alias gca="git commit --amend"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gp="git push"
alias gpf="git push --force-with-lease" # safer force push
alias gl="git pull"
alias glog="git log --oneline --graph --decorate -20"
alias gd="git diff"
alias gds="git diff --staged"

# ── Python / UV ──────────────────────────────────────────────────────────────
alias py="python3"
alias venv="uv venv && source .venv/bin/activate"
alias pipi="uv pip install"
alias pipu="uv pip install --upgrade"

# ── Utilities ─────────────────────────────────────────────────────────────────
alias reload="source ~/.zshrc"
alias zshrc="$EDITOR ~/.zshrc"
alias path='echo $PATH | tr ":" "\n"'   # readable PATH
alias ports="lsof -i -P -n | grep LISTEN"
alias myip="curl -s ifconfig.me"
alias copy="pbcopy"
alias paste="pbpaste"
