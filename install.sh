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
fi

echo "==> Linking ~/.zshrc -> $REPO_DIR/.zshrc"
ln -sfn "$REPO_DIR/.zshrc" "$HOME/.zshrc"

if [[ ! -e "$HOME/.zprofile" ]]; then
  echo "==> Creating ~/.zprofile with Homebrew shellenv"
  printf '\neval "$(/opt/homebrew/bin/brew shellenv)"\n' > "$HOME/.zprofile"
fi

echo "==> Done. Restart the terminal or run: exec zsh"
