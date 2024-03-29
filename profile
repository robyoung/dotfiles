#!/usr/bin/env bash

[ -f ~/.bashrc ] && . ~/.bashrc

function log() {
  echo "$(date --utc +%Y-%m-%dT%H:%M:%S) $@" >> /var/log/robyoung-startup.log
}

log "start of profile"

if [ $(uname -s) = "Linux" -a which setxkbmap > /dev/null 2>&1 ]; then
  log "cap swap"
  setxkbmap -option caps:swapescape
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

. "$HOME/.cargo/env"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
