#!/usr/bin/env bash

: ${DEVELOPMENT_DIR:=Dev}
: ${DOTFILES_DIR:=~/${DEVELOPMENT_DIR}/personal/dotfiles}

cp ${DOTFILES_DIR}/bootstrap/ssh_config ${DOTFILES_DIR}/ssh_config

if [ -f ~/.ssh/config.local ]; then
  cat ${DOTFILES_DIR}/ssh_config ~/.ssh/config.local > /tmp/ssh_config.$$
  mv /tmp/ssh_config.$$ ${DOTFILES_DIR}/ssh_config
fi
