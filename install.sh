#!/usr/bin/env bash
# Sets up this zsh config on a machine: installs dependencies via Homebrew
# and symlinks ~/.zshrc to the repo. Safe to re-run.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y-%m-%d-%H%M%S)"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required. Install it first: https://brew.sh" >&2
  exit 1
fi

echo "==> Installing dependencies from Brewfile"
brew bundle --file="$REPO_DIR/Brewfile"

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

# iTerm2 reads this directory on launch, so installing before its first run
# is fine.
DP_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
echo "==> Installing iTerm2 'Headroom' dynamic profile"
mkdir -p "$DP_DIR"
cp "$REPO_DIR/iterm/headroom.profile.json" "$DP_DIR/"

echo "==> Done. Remaining manual steps:"
echo "    1. Restart iTerm2 (or open a new tab) and run: exec zsh"
echo "    2. iTerm2 Settings > Profiles > Headroom > Other Actions >"
echo "       Set as Default Profile — this applies the Nerd Font and colors."
echo "       Without it, prompt glyphs render as boxes."
