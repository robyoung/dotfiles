#!/usr/bin/env bash

_has(){
  type $1 >/dev/null 2>&1
}

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# pyenv
if _has pyenv; then
  export PYENV_ROOT="$HOME/.local/pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi
