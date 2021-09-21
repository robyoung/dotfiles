#!/usr/bin/env bash

if [ $(uname -s) = "Linux" ]; then
  setxkbmap -option caps:swapescape
fi

# pyenv
export PYENV_ROOT="$HOME/.local/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
