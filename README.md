# zsh_config

Frameworkless zsh setup: Powerlevel10k prompt, autosuggestions, syntax
highlighting, zoxide, atuin, fzf, uv-aware venv auto-activation, and versioned
terminal profiles for Ghostty and iTerm2. No Oh My Zsh, no Starship; every line
is in this repo.

The shell config is terminal-agnostic — only colors, font and the key
sequences behind Option/Cmd editing are per terminal, and those live in
`ghostty/` and `iterm/`, generated from one palette file.

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
palettes.py         terminal color palettes, shared by both generators
ghostty/            Ghostty config + themes + generator (default terminal)
terminal-app/       Apple Terminal.app profile + generator
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
- symlinks `~/.config/ghostty/config` and the themes into the repo
- installs the "Headroom" iTerm2 dynamic profile, but only if iTerm2 is
  actually installed on the machine
- prints the `export` / `alias` / `eval` / `source` lines found in the
  replaced `.zshrc` so nothing silently disappears

Ghostty needs nothing else: colors, font and key bindings come from the
config file. In iTerm2 one manual step remains — Settings, Profiles, select
**Headroom**, Other Actions, **Set as Default Profile**.

### Updating a machine that already has it

```
cd ~/dev/zsh_config
git pull
./install.sh
```

`install.sh` is idempotent: an already-symlinked `~/.zshrc` is left alone, only
a real file gets backed up. The rerun is what installs Ghostty, links
`~/.config/ghostty/`, and (unlike before) touches the iTerm2 profile only if
iTerm2 is on the machine. Then quit and reopen the terminal.

An existing hand-written `~/.config/ghostty/config` is moved aside to
`config.backup-<timestamp>` in the same directory — copy anything you want to
keep into `ghostty/config` here, or into `~/.config/ghostty/config.local`
referenced from it, so the next pull keeps it.

If Homebrew must not run — locked-down machine, casks installed by IT, or you
just want the config files relinked:

```
SKIP_BREW=1 ./install.sh
```

Ghostty then has to be installed separately; everything else is already there
from the previous run.

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

Each prompt theme pairs with a terminal palette. Both sets are generated
from `palettes.py`:

```
python3 ghostty/make_ghostty.py      # -> ghostty/themes/<name>
python3 iterm/make_itermcolors.py    # -> iterm/<name>.itermcolors + profile
```

In Ghostty, switch with `theme = <name>` in `ghostty/config`; `catppuccin-mocha`
and `nord` are built in (`ghostty +list-themes`), so only headroom and gruvbox
need generating. In iTerm2, `open iterm/<name>.itermcolors`, then select it
under Settings, Profiles, Colors, Color Presets — and keep Minimum Contrast at
0 or iTerm2 distorts the tuned colors. The iTerm2 generator also rebuilds the
dynamic profile, which embeds the key mappings from `iterm/keyboard-map.json`.

## Terminals

`ghostty/config` is the supported setup; `iterm/` is kept for machines where
iTerm2 is still in use. Ghostty was picked as the default because it has no
plugin or scripting runtime, no built-in AI/LLM integration, and no telemetry —
a small attack surface is the easiest thing to defend in a security review.

What the per-terminal files have to provide, whatever the terminal:

- the 16 ANSI colors plus background/foreground/cursor/selection, true color
- a Nerd Font, or `p10k`'s glyphs render as boxes
- Option+arrows → `ESC b` / `ESC f`, Cmd+arrows → `^A` / `^E`,
  Cmd+Backspace → `^U`, Option+Backspace → `ESC DEL`, Fn+Delete → `^D`,
  Option+Fn+Delete → `ESC d` — this is what `zsh/keybindings.zsh` reacts to.
  It also binds the xterm-style forms (`ESC [1;3D` and friends) and Home/End,
  so word motion survives a terminal whose keys cannot be remapped at all

Ghostty specifics worth knowing:

- it advertises `TERM=xterm-ghostty`, which servers don't know; `clear`, tmux
  and TUIs then break over ssh. Fix with `shell-integration-features =
  ssh-env,ssh-terminfo` (Ghostty 1.1+) or `term = xterm-256color`. Both are in
  the config, commented.
- `macos-option-as-alt` is deliberately left off: it would turn Option into
  Meta everywhere and kill Option+a / Option+l for ą, ł and friends. The
  explicit `keybind` lines cover the editing keys instead.
- `Cmd+§` (the key left of "1") from any app raises the existing Ghostty windows as they
  were and hides them again on the next press, focus returning to the app
  underneath. The binding needs the `global:` prefix, and macOS may ask for
  Accessibility permission before a global hotkey fires outside Ghostty.
  `toggle_quick_terminal` is the alternative: a separate dropdown surface
  rather than your real windows.
- reload after an edit with Cmd+Shift+, ; validate with `ghostty +validate-config`

### Apple Terminal.app

The fallback that needs no approval. Until macOS 26 (Tahoe) it was a poor one:
256 colors and broken Powerline glyphs. Tahoe added 24-bit color and Powerline
font rendering, so `themes/headroom.zsh` and the p10k prompt render as intended
— no separate low-color theme needed.

```
python3 terminal-app/make_terminal.py   # regenerate after a palette change
open terminal-app/headroom.terminal     # imports the profile
```

Then Terminal, Settings, Profiles, select **Headroom**, **Default**. The
profile carries the palette, JetBrains Mono NF at 12pt, and leaves Option as a
normal modifier so Option+a still types ą.

What you give up, and the workaround:

- **No split panes.** Terminal.app has tabs and windows only. `tmux` is the
  answer; inside it, set the terminal-overrides for RGB or tmux strips the
  24-bit colors back to 256 and the theme looks wrong again.
- **Cmd is not remappable.** Terminal's keyboard map refuses Command entirely,
  so the Cmd+arrow / Cmd+Backspace line editing from the other profiles cannot
  be reproduced. `Ctrl+A` / `Ctrl+E` / `Ctrl+U` do the same jobs, and
  `zsh/keybindings.zsh` binds Home/End (fn+arrows) as well.
- Option+arrow word motion works through the sequences `zsh/keybindings.zsh`
  binds directly, so nothing has to be mapped in the profile.

### If Ghostty is not approved either

The shell config runs unchanged on any of these; only the profile files differ.

| Terminal | Notes for a security review |
|---|---|
| **Apple Terminal.app** | Preinstalled and approved everywhere, and since macOS 26 (Tahoe) it does 24-bit color and Powerline glyphs, so this config looks right in it. No split panes — that is what you give up. See below. |
| **WezTerm** | Rust, cross-platform, actively maintained. Config is a Lua program, which is itself a scripting surface some reviews object to. |
| **Alacritty** | Rust, minimal, YAML/TOML config, no tabs or splits — pair it with tmux. Smallest feature surface of the lot. |
| **kitty** | Fast and featureful, but "kittens" are Python scripts, so it carries a scripting runtime. |
| **VS Code / JetBrains terminal** | If the IDE is already approved, its terminal usually is too. Set the font and paste this repo's ANSI palette into its settings. |

Whatever gets approved: keep `zsh/`, `themes/` and `p10k.zsh`, add one
directory for the new terminal's profile, generate its palette from
`palettes.py`.

## Try without touching the live shell

```
ZDOTDIR=~/dev/zsh_config zsh
```

## Notes

- Prompt look beyond colors is tuned with `p10k configure` (writes
  `~/.p10k.zsh`; copy it over `p10k.zsh` here to persist).
- atuin owns Ctrl+R; fzf owns Ctrl+T (files) and Alt+C (cd). Alt+C needs the
  terminal to send Meta on Option — in Ghostty that means
  `macos-option-as-alt`, at the cost of Option+letter diacritics; Esc then C
  works without it.
- `cd` into a project with `.venv` activates it; leaving deactivates.
- Ctrl+Z on an empty line resumes the last suspended job; on a non-empty
  line it stashes the input and restores it after the next command.
- Option+arrows move per path component (bash-style words); Ctrl+X Ctrl+E
  edits the command line in `$EDITOR`.
- The right prompt shows exit code and time, plus execution time (>3s),
  background jobs, and user@host (SSH/root) only when relevant.
