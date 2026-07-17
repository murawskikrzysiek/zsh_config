# Custom one-command workflows. This file replaces OMZ custom plugins:
# any function defined here is available in every shell.

# Universal extractor: `extract archive.tar.gz [target-dir]`
extract() {
  local archive=$1 target=${2:-.}
  [[ -f $archive ]] || { echo "extract: no such file: $archive" >&2; return 1 }
  mkdir -p "$target"
  case $archive in
    *.tar.gz|*.tgz)   tar -xzf "$archive" -C "$target" ;;
    *.tar.bz2|*.tbz2) tar -xjf "$archive" -C "$target" ;;
    *.tar.xz)         tar -xJf "$archive" -C "$target" ;;
    *.tar)            tar -xf  "$archive" -C "$target" ;;
    *.zip)            unzip -o "$archive" -d "$target" ;;
    *.gz)             gunzip -k "$archive" ;;
    *.7z)             7z x "$archive" -o"$target" ;;
    *)                echo "extract: unknown archive type: $archive" >&2; return 1 ;;
  esac
}

# mkdir + cd in one step
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Template for download/unpack/license-style workflows (the old OMZ custom
# plugin pattern). Copy, rename, and fill in real URLs/paths:
#
# install-thing() {
#   local tmp
#   tmp=$(mktemp -d)
#   curl -fsSL "https://example.com/thing.zip" -o "$tmp/thing.zip"
#   extract "$tmp/thing.zip" "$HOME/Applications/Thing"
#   cp "$HOME/licenses/thing.key" "$HOME/Applications/Thing/"
#   rm -rf "$tmp"
# }
