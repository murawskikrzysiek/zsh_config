# zsh_config

Frameworkless zsh setup: Powerlevel10k prompt, autosuggestions, syntax
highlighting, zoxide, atuin, fzf, uv-aware venv auto-activation, and a
versioned iTerm2 profile. No Oh My Zsh, no Starship; every line is in this
repo.

## Layout

```
.zshrc              entry point (symlinked from ~/.zshrc)
p10k.zsh            Powerlevel10k prompt configuration
zsh/env.zsh         history, setopts, PATH
zsh/tools.zsh       compinit, zoxide, fzf, atuin, bat/eza/uv/ripgrep
zsh/aliases.zsh     aliases
zsh/functions.zsh   custom one-command workflows
zsh/keybindings.zsh word granularity, Ctrl+Z toggle, line editing
zsh/python.zsh      .venv auto-activate/deactivate on cd
zsh/prompt.zsh      p10k + plugins + theme switch (keep last)
themes/             prompt color schemes (headroom, gruvbox, ...)
iterm/              iTerm2 color presets + dynamic profile + generator
Brewfile            all dependencies
install.sh          bootstrap a machine
```

## Install on a machine

Requires [Homebrew](https://brew.sh) and macOS.

```
git clone git@github.com:USER/zsh_config.git ~/dev/zsh_config
~/dev/zsh_config/install.sh
exec zsh
```

The installer:

- installs every dependency from the Brewfile (tools, plugins, font)
- backs up any existing `~/.zshrc` to `~/.zshrc.backup-<timestamp>` and
  symlinks `~/.zshrc` into the repo
- creates `~/.zprofile` with Homebrew shellenv if missing
- installs the "Headroom" iTerm2 dynamic profile (colors, JetBrains Mono NF,
  option/cmd key mappings)
- prints the `export` / `alias` / `eval` / `source` lines found in the
  replaced `.zshrc` so nothing silently disappears

Then in iTerm2: Settings, Profiles, select **Headroom**, Other Actions,
**Set as Default Profile**.

### Migrating the old config

Machine-specific state never goes in the repo. Copy anything relevant from
the installer's migration printout into `~/.zshrc.local`: secrets and
tokens, proxy settings, company tool hooks (nvm, pyenv, SDK setups), extra
PATH entries, host-specific aliases. Check the machine's old `~/.zprofile`
and `~/.config/zsh/` too; the installer leaves those untouched.
`~/.zshrc.local` is sourced last, so it can override anything.

Optional: `atuin register` / `atuin login` on each machine syncs encrypted
shell history between them.

## Publishing your own copy

```
gh repo create zsh_config --private --source ~/dev/zsh_config --push
```

Public works too; nothing sensitive is tracked, and the `~/.zshrc.local`
convention keeps it that way. Commits expose your git author email; if that
matters, set a GitHub noreply address first:

```
git config user.email "USERNAME@users.noreply.github.com"
```

## Prompt themes

`ZSH_PROMPT_THEME` in `zsh/prompt.zsh` selects a file from `themes/`
(currently `headroom`; also `gruvbox`, `catppuccin-mocha`, `nord`; empty
string = p10k defaults). Themes also restyle eza and the autosuggestion
ghost text where it matters.

Each theme pairs with an iTerm2 palette. The headroom one ships as the
dynamic profile; the others as `.itermcolors` presets:
`open iterm/<name>.itermcolors`, then select it under Settings, Profiles,
Colors, Color Presets. Palettes live in `iterm/make_itermcolors.py`; rerun
it after editing (it also regenerates the dynamic profile, which embeds the
key mappings from `iterm/keyboard-map.json`). Keep Minimum Contrast at 0 or
iTerm2 distorts the tuned colors.

## Try without touching the live shell

```
ZDOTDIR=~/dev/zsh_config zsh
```

## Notes

- Prompt look beyond colors is tuned with `p10k configure` (writes
  `~/.p10k.zsh`; copy it over `p10k.zsh` here to persist).
- atuin owns Ctrl+R; fzf owns Ctrl+T (files) and Alt+C (cd).
- `cd` into a project with `.venv` activates it; leaving deactivates.
- Ctrl+Z on an empty line resumes the last suspended job; on a non-empty
  line it stashes the input and restores it after the next command.
- Option+arrows move per path component (bash-style words); Ctrl+X Ctrl+E
  edits the command line in `$EDITOR`.
- The right prompt shows exit code and time, plus execution time (>3s),
  background jobs, and user@host (SSH/root) only when relevant.
