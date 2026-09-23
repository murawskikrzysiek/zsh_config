#!/usr/bin/env bash
# Sets up this zsh config on a machine. Safe to re-run.
#
# By default it installs the shell only: dependencies, ~/.zshrc, ~/.zprofile.
# Nothing terminal-specific happens unless you ask for it by name, because
# which terminal is allowed differs per machine.
#
#   ./install.sh                        shell config only
#   ./install.sh ghostty                + Ghostty: its cask, config and themes
#   ./install.sh terminal-app           + import the Apple Terminal.app profile
#   ./install.sh iterm                  + the iTerm2 dynamic profile
#   ./install.sh ghostty terminal-app   combine freely
#
# SKIP_BREW=1 skips Homebrew entirely — for locked-down machines where IT owns
# the software list, or for a config-only refresh.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y-%m-%d-%H%M%S)"

usage() {
  # The comment block at the top of this file, minus the shebang, is the help
  # text; printing it keeps the two from drifting apart.
  awk 'NR == 1 { next } /^#/ { sub(/^# ?/, ""); print; next } { exit }' \
    "${BASH_SOURCE[0]}"
}

WANT_GHOSTTY=0
WANT_ITERM=0
WANT_TERMINAL_APP=0
for arg in "$@"; do
  case "$arg" in
    ghostty)                 WANT_GHOSTTY=1 ;;
    iterm|iterm2)            WANT_ITERM=1 ;;
    terminal-app|terminal)   WANT_TERMINAL_APP=1 ;;
    -h|--help)               usage; exit 0 ;;
    *)
      echo "install.sh: unknown argument '$arg'" >&2
      echo >&2
      usage >&2
      exit 2 ;;
  esac
done

# ── Dependencies ─────────────────────────────────────────────────────────────
if [[ "${SKIP_BREW:-0}" == 1 ]]; then
  echo "==> SKIP_BREW=1: skipping Homebrew, assuming dependencies are present"
elif ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required. Install it first: https://brew.sh" >&2
  echo "Or re-run with SKIP_BREW=1 to only link the config files." >&2
  exit 1
else
  echo "==> Installing dependencies from Brewfile"
  brew bundle --file="$REPO_DIR/Brewfile"
  if [[ "$WANT_GHOSTTY" == 1 ]]; then
    echo "==> Installing Ghostty (ghostty/Brewfile)"
    brew bundle --file="$REPO_DIR/ghostty/Brewfile"
  fi
fi

# ── Shell ────────────────────────────────────────────────────────────────────
if [[ -e "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
  echo "==> Backing up existing ~/.zshrc to ~/.zshrc.backup-$TS"
  mv "$HOME/.zshrc" "$HOME/.zshrc.backup-$TS"
  echo
  echo "==> Review these lines from the old config; anything machine-specific"
  echo "    (secrets, proxies, PATH entries, tool hooks) goes in ~/.zshrc.local:"
  grep -nE '^[[:space:]]*(export|alias|eval|source|\.)[[:space:]]' \
    "$HOME/.zshrc.backup-$TS" || echo "    (nothing found)"
  echo
fi

echo "==> Linking ~/.zshrc -> $REPO_DIR/.zshrc"
ln -sfn "$REPO_DIR/.zshrc" "$HOME/.zshrc"

if [[ ! -e "$HOME/.zprofile" ]]; then
  echo "==> Creating ~/.zprofile with Homebrew shellenv"
  printf '\neval "$(/opt/homebrew/bin/brew shellenv)"\n' > "$HOME/.zprofile"
fi

# ── Terminals, each only when named ──────────────────────────────────────────
if [[ "$WANT_GHOSTTY" == 1 ]]; then
  # Ghostty reads ~/.config/ghostty/config on launch and on reload. Symlinked,
  # so a git pull updates the live config.
  GHOSTTY_DIR="$HOME/.config/ghostty"
  echo "==> Installing Ghostty config -> $GHOSTTY_DIR"
  mkdir -p "$GHOSTTY_DIR/themes"
  if [[ -e "$GHOSTTY_DIR/config" && ! -L "$GHOSTTY_DIR/config" ]]; then
    echo "    Backing up existing config to config.backup-$TS"
    mv "$GHOSTTY_DIR/config" "$GHOSTTY_DIR/config.backup-$TS"
  fi
  ln -sfn "$REPO_DIR/ghostty/config" "$GHOSTTY_DIR/config"
  for theme in "$REPO_DIR"/ghostty/themes/*; do
    ln -sfn "$theme" "$GHOSTTY_DIR/themes/$(basename "$theme")"
  done
fi

if [[ "$WANT_ITERM" == 1 ]]; then
  # iTerm2 reads this directory on launch, so installing before its first run
  # is fine.
  DP_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  echo "==> Installing iTerm2 'Headroom' dynamic profile"
  mkdir -p "$DP_DIR"
  cp "$REPO_DIR/iterm/headroom.profile.json" "$DP_DIR/"
fi

if [[ "$WANT_TERMINAL_APP" == 1 ]]; then
  PROFILE="$REPO_DIR/terminal-app/headroom.terminal"
  echo "==> Importing the Terminal.app 'Headroom' profile"
  if command -v open >/dev/null 2>&1; then
    open "$PROFILE"
  else
    echo "    No 'open' here; import it by hand: $PROFILE"
  fi
fi

# ── What is left to do by hand ───────────────────────────────────────────────
echo "==> Done. Remaining manual steps:"
echo "    Restart the terminal (or open a new tab) and run: exec zsh"
if [[ "$WANT_GHOSTTY" == 1 ]]; then
  echo "    Ghostty: nothing to click — colors, font and keys come from the"
  echo "      config that was just linked."
fi
if [[ "$WANT_ITERM" == 1 ]]; then
  echo "    iTerm2: Settings > Profiles > Headroom > Other Actions >"
  echo "      Set as Default Profile. Without it, glyphs render as boxes."
fi
if [[ "$WANT_TERMINAL_APP" == 1 ]]; then
  echo "    Terminal.app: Settings > Profiles > Headroom > Default."
fi
if (( WANT_GHOSTTY + WANT_ITERM + WANT_TERMINAL_APP == 0 )); then
  echo "    No terminal profile was installed. Add one whenever you want:"
  echo "      ./install.sh ghostty | terminal-app | iterm"
fi
