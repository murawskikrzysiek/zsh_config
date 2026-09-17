#!/usr/bin/env bash
# Sets up this zsh config on a machine: installs dependencies via Homebrew
# and symlinks ~/.zshrc to the repo. Safe to re-run.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y-%m-%d-%H%M%S)"

# SKIP_BREW=1 leaves Homebrew alone — for locked-down machines where casks
# (Ghostty, the font) are installed by IT, or for a config-only refresh.
if [[ "${SKIP_BREW:-0}" == 1 ]]; then
  echo "==> SKIP_BREW=1: skipping Homebrew, assuming dependencies are present"
elif ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required. Install it first: https://brew.sh" >&2
  echo "Or re-run with SKIP_BREW=1 to only link the config files." >&2
  exit 1
else
  echo "==> Installing dependencies from Brewfile"
  brew bundle --file="$REPO_DIR/Brewfile"
fi

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

# ── Ghostty ──────────────────────────────────────────────────────────────────
# Ghostty reads ~/.config/ghostty/config on launch and on reload. Symlinked, so
# a git pull updates the live config.
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

# ── iTerm2 (only if it is actually installed) ────────────────────────────────
# iTerm2 reads this directory on launch, so installing before its first run
# is fine.
ITERM_INSTALLED=false
if [[ -d "/Applications/iTerm.app" || -d "$HOME/Applications/iTerm.app" ]]; then
  ITERM_INSTALLED=true
  DP_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  echo "==> Installing iTerm2 'Headroom' dynamic profile"
  mkdir -p "$DP_DIR"
  cp "$REPO_DIR/iterm/headroom.profile.json" "$DP_DIR/"
else
  echo "==> iTerm2 not installed, skipping its profile"
fi

echo "==> Done. Remaining manual steps:"
echo "    1. Restart the terminal (or open a new tab) and run: exec zsh"
echo "       Ghostty picks up colors, font and key bindings from the config"
echo "       above; nothing to click."
if [[ "$ITERM_INSTALLED" == true ]]; then
  echo "    2. iTerm2 only: Settings > Profiles > Headroom > Other Actions >"
  echo "       Set as Default Profile — this applies the Nerd Font and colors."
  echo "       Without it, prompt glyphs render as boxes."
fi
