# zsh_config

Frameworkless zsh setup: Powerlevel10k prompt, autosuggestions, syntax
highlighting, zoxide, atuin, fzf, uv-aware venv auto-activation. No Oh My Zsh,
no Starship; every line is in this repo.

## Layout

```
.zshrc            entry point (symlinked from ~/.zshrc)
p10k.zsh          Powerlevel10k prompt configuration
zsh/env.zsh       history, setopts, PATH
zsh/tools.zsh     compinit, zoxide, fzf, atuin, bat/eza/uv/ripgrep
zsh/aliases.zsh   aliases
zsh/functions.zsh custom one-command workflows (ex-OMZ custom plugins)
zsh/python.zsh    .venv auto-activate/deactivate on cd
zsh/prompt.zsh    p10k + plugins (keep last)
Brewfile          all dependencies
install.sh        bootstrap a machine
```

## New machine

```
git clone <this-repo> ~/dev/zsh_config
~/dev/zsh_config/install.sh
```

Then in iTerm2: Settings, Profiles, Text, set the font to MesloLGS NF (or
MesloLGS Nerd Font from the Brewfile cask).

## Try without touching the live shell

```
ZDOTDIR=~/dev/zsh_config zsh
```

## Notes

- Prompt look is tuned with `p10k configure` (rewrites `~/.p10k.zsh`; copy it
  over `p10k.zsh` here to persist).
- atuin owns Ctrl-R; fzf owns Ctrl-T (files) and Alt-C (cd).
- `cd` into a project with `.venv` activates it; leaving deactivates.
