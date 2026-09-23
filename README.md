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
tmux/               tmux config + theme + generator (real panes anywhere)
iterm/              iTerm2 color presets + dynamic profile + generator
Brewfile            shell dependencies (tools, plugins, font)
install.sh          bootstrap a machine; terminals are opt-in arguments
```

## Install on a machine

Requires [Homebrew](https://brew.sh) and macOS.

```
git clone git@github.com:USER/zsh_config.git ~/dev/zsh_config
~/dev/zsh_config/install.sh
exec zsh
```

By default that installs the **shell only** — dependencies, `~/.zshrc`,
`~/.zprofile`. No terminal is touched, and none is installed, until you name
it:

```
./install.sh                        shell config only
./install.sh ghostty                + Ghostty: its cask, config and themes
./install.sh terminal-app           + import the Terminal.app profile
./install.sh iterm                  + the iTerm2 dynamic profile
./install.sh tmux                   + tmux: the binary, config and theme
./install.sh ghostty tmux           combine freely
```

Which terminal is allowed differs per machine, so nothing is assumed. Each
directory is self-contained: `ghostty/`, `iterm/`, `terminal-app/` and `tmux/`
never reference one another, and the shell config works the same under all of
them.

The shell part always: installs the Brewfile dependencies (tools, plugins,
font), backs up an existing `~/.zshrc` to `~/.zshrc.backup-<timestamp>`,
symlinks `~/.zshrc` into the repo, creates `~/.zprofile` with Homebrew
shellenv if missing, and prints the `export` / `alias` / `eval` / `source`
lines from the replaced `.zshrc` so nothing silently disappears.

Ghostty then needs nothing else. iTerm2 and Terminal.app each want their
profile set as the default once, which the installer prints.

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

Re-run it with the terminals you want on this machine; leave them out and
they stay untouched. On a machine where IT owns the software list, or for a
config-only refresh:

```
SKIP_BREW=1 ./install.sh
```

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

Three profiles ship, none of them installed unless asked for: `ghostty/`,
`terminal-app/` (Apple Terminal) and `iterm/`. Pick per machine — the shell
config is identical under all of them. Ghostty was picked as the default because it has no
plugin or scripting runtime, no built-in AI/LLM integration, and no telemetry —
a small attack surface is the easiest thing to defend in a security review.

What the per-terminal files have to provide, whatever the terminal:

- the 16 ANSI colors plus background/foreground/cursor/selection, true color
- a Nerd Font, or `p10k`'s glyphs render as boxes
- Option+arrows → `ESC b` / `ESC f`, Cmd+arrows → `^A` / `^E`,
  Ctrl+arrows → start / end of line (the xterm `ESC [1;5D` form every
  terminal sends), Cmd+Backspace → `^U`, Option+Backspace → `ESC DEL`,
  Fn+Delete → `^D`, Option+Fn+Delete → `ESC d` — this is what
  `zsh/keybindings.zsh` reacts to.
  It also binds the xterm-style forms (`ESC [1;3D` and friends), Home/End and
  both spellings of Option+Backspace, so editing survives a terminal whose
  keys cannot be remapped at all
- Ctrl+Backspace → `^H` (0x08), which deletes the whole line. Plain Backspace
  keeps sending `0x7f`, which is what makes the two distinguishable

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
profile carries the palette, JetBrains Mono NF at 12pt, the key map, and
leaves Option as a normal modifier so Option+a still types ą.

The key map is the per-key kind, not "Use Option as Meta Key": Option+Backspace
sends `ESC DEL`, fn+Delete `^D`, Option+fn+Delete `ESC d`, Ctrl+Backspace `^H`.
Option+arrows already send `ESC b` / `ESC f` out of the box, so they are not
in it. It shows up under the profile's Keyboard tab after the import; nothing
to click there.

Window groups are Terminal's saved layouts: arrange the windows, Window,
Save Windows as Group..., and it remembers each one's profile, size and
position. The installer binds `Ctrl+Shift+T` to a group named **dev**:

```
defaults write com.apple.Terminal NSUserKeyEquivalents -dict-add "dev" '^$t'
```

The shortcut is a menu key equivalent, so it needs a group of that exact name
and takes effect at Terminal's next launch. Settings, General, "On startup:
open window group" restores it without any key. A group reopens windows, not
what ran in them; with tmux auto-start each window attaches to `main` again.

What you give up, and the workaround:

- **No split panes in the iTerm2 sense.** `Cmd+D` does exist and splits the
  window, but both halves show the *same* session with independent scroll
  positions — handy for keeping earlier output in view, useless for running
  two things side by side. For that: `tmux` (see below — `./install.sh tmux`
  ships a config with the truecolor passthrough already set), or macOS window
  tiling, two Terminal windows snapped side by side with `fn+ctrl+arrows`.
- **Cmd is not remappable.** Terminal's keyboard map refuses Command entirely,
  so the Cmd+arrow / Cmd+Backspace line editing from the other profiles cannot
  be reproduced. `Ctrl+arrows` jump to the start / end of the line instead,
  `Ctrl+Backspace` deletes it, and `zsh/keybindings.zsh` binds Home/End
  (fn+arrows) as well.

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

## tmux

Real panes, in any terminal, plus sessions that outlive a closed window or a
dropped ssh. Worth it under Terminal.app in particular, whose `Cmd+D` splits
only the view of one session.

```
./install.sh tmux
```

Symlinks `~/.config/tmux/tmux.conf` and the generated theme next to it.
Regenerate the colors after a palette change with
`python3 tmux/make_tmux.py`.

| | |
|---|---|
| **shift-arrows** | move between panes — **no prefix** |
| `prefix \|` / `prefix -` | split right / down, keeping the directory |
| `prefix` + arrows | move between panes (repeatable) |
| `prefix` + ctrl-arrows | resize (repeatable) |
| `prefix c` | new window, keeping the directory |
| `prefix z` | zoom the pane to the whole window, and back |
| `prefix d` | detach; the session keeps running |
| `prefix R` | reload the config |

Shift+arrows are bound with `bind -n`, meaning no prefix at all. Keep that
list short: a key bound that way is one vim, less and everything else inside
tmux will never see. Shift+arrows are the free ones here — Ctrl+arrows and
Option+arrows already carry line and word motion from `zsh/keybindings.zsh`.

### Starting inside tmux automatically

Off by default. `ZSH_AUTO_TMUX=1` in `~/.zshrc.local` makes an interactive
shell attach to a session named `main`, creating it if needed.

Even then it only fires in **Apple Terminal**. tmux is here to supply the
panes that terminal lacks; iTerm2 and Ghostty split natively, so starting
tmux in them would put two competing mechanisms on one screen. Widen it per
machine if you disagree:

```
ZSH_AUTO_TMUX_TERMINALS="Apple_Terminal ghostty"   # space separated
ZSH_AUTO_TMUX_TERMINALS="all"                      # anywhere
```

The other guards in `zsh/tmux.zsh` keep it out of scripts, nested shells and
IDE terminals.

The reason to bother: **a shell started outside tmux cannot be moved into it
later**. tmux would have to adopt a terminal it does not own, and nothing on
macOS does that. So the choice to use tmux has to be made before the work
starts, or not at all — auto-start makes it for you.

The trade-off: every window attaching to `main` mirrors the same panes. For a
second independent window, set `ZSH_AUTO_TMUX_SESSION=side` in it.

The prefix stays the default `Ctrl+B`. The popular `Ctrl+A` swap is left
commented out on purpose: it collides with beginning-of-line, and under
Terminal.app — which cannot map Command at all — `Ctrl+A` is the only way to
reach the start of a line.

Two settings carry the weight. `terminal-features *:RGB` stops tmux
quantizing the 24-bit palette back to 256 colors, which is what makes the
headroom theme survive inside tmux. `escape-time 10` keeps ESC-prefixed
sequences intact — the same ones `zsh/keybindings.zsh` binds for word motion —
where the 500ms default swallows them.

Mouse mode is on: click to focus, drag borders to resize, scroll into the
history, and a selection goes straight to the Mac clipboard.

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
