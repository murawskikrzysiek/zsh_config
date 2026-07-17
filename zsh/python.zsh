# ── uv-friendly venv auto-activation ─────────────────────────────────────────
# Entering a directory (or subdirectory) that contains .venv activates it;
# leaving the tree deactivates. Works with `uv venv` defaults.

export VIRTUAL_ENV_DISABLE_PROMPT=1   # p10k's virtualenv segment shows it instead

_auto_venv() {
  local dir=$PWD found=""
  while [[ $dir != / ]]; do
    if [[ -e $dir/.venv/bin/activate ]]; then
      found=$dir/.venv
      break
    fi
    dir=${dir:h}
  done

  if [[ -n $found ]]; then
    if [[ $VIRTUAL_ENV != $found ]]; then
      [[ -n $VIRTUAL_ENV ]] && deactivate 2>/dev/null
      source "$found/bin/activate"
    fi
  elif [[ -n $VIRTUAL_ENV && -n $_AUTO_VENV_ACTIVE ]]; then
    # Only auto-deactivate venvs we auto-activated
    deactivate 2>/dev/null
    unset _AUTO_VENV_ACTIVE
  fi
  [[ -n $found ]] && _AUTO_VENV_ACTIVE=1
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _auto_venv
_auto_venv   # run once for the shell's starting directory
