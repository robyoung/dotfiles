#!/bin/bash

${DEVELOPMENT_DIR:=Dev}

# Functions
function check_bin() {
  hash $1 2>/dev/null
}

function dot() {
  [ -f ~/.$1 -a ! -h ~/.$1 ] && { echo >&2 "~/.$1 exists and is a regular file"; }
  [ -h ~/.$1 ] || { ln -s ~/${DEVELOPMENT_DIR}/personal/dotfiles/$1 ~/.$1; }
}

# Package manager
if check_bin yum; then
function inst() {
  sudo yum install -y $1
}

elif check_bin brew; then
function inst() {
  brew install $1
}

elif check_bin apt; then
function inst() {
  sudo apt install $1
}
else
  echo >&2 "No package manager"
  exit 1
fi



# Repos
mkdir -p ~/${DEVELOPMENT_DIR}/{personal,playground}
mkdir -p ~/bin

# Vim
echo "Installing vim"
check_bin vim || { inst vim; }
dot vimrc
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p ~/.vim/{bundle,autoload}

# Tmux
echo "Installing tmux"
check_bin tmux || inst tmux
dot tmux.conf

# Zsh
echo "Installing zsh"
check_bin zsh || inst zsh
dot zshrc
dot profile
[ -d ~/.oh-my-zsh ] || git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# Password store
echo "Installing password store"
[ -d ~/${DEVELOPMENT_DIR}/personal/password-store ] || git clone git@github.com:robyoung/password-store.git ~/${DEVELOPMENT_DIR}/personal/password-store
[ -e ~/bin/pass ] || ln -s ~/${DEVELOPMENT_DIR}/personal/password-store/src/password-store.sh ~/bin/pass

# Python
echo "Installing python"
check_bin python || inst python
check_bin pip || inst pip
check_bin virtualenvwrapper.sh || sudo pip install virtualenv virtualenvwrapper

# Dotfiles
# TODO: fixme, this is not right
exit 1
for name in $(ls ~/${DEVELOPMENT_DIR}/personal/dotfiles | grep -v bootstrap); do
  ln -s ~/${DEVELOPMENT_DIR}/personal/dotfiles/$name ~/.$name
done
