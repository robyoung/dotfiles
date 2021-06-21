#!/usr/bin/env bash

_has(){
  type $1 >/dev/null 2>&1
}

cat > ~/.tmux.conf <<'END'
set -g default-terminal "screen-256color"
# if run as "tmux attach", create a session if one does not already exist
new-session -n $HOST
END

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y build-essential docker.io tmux git htop
sudo usermod -a -G docker youngrob2
if ! _has rustup; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  . ~/.bashrc
fi
rustup toolchain install nightly
rustup target install thumbv6m-none-eabi thumbv7em-none-eabihf armv7-unknown-linux-gnueabihf armv7-unknown-linux-musleabihf
rustup target install thumbv6m-none-eabi thumbv7em-none-eabihf armv7-unknown-linux-gnueabihf armv7-unknown-linux-musleabihf --toolchain=nightly

cargo install bat ripgrep cross
sudo ls
