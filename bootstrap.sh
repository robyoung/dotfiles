#!/bin/bash

# Functions
function check_bin() {
  hash $1 2>/dev/null
}

function dot() {
  [ -f ~/.$1 -a ! -h ~/.$1 ] && { echo >&2 "~/.$1 exists and is a regular file"; }
  [ -h ~/.$1 ] || { ln -s ~/Projects/personal/dotfiles/$1 ~/.$1; }
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
else
  echo >&2 "No package manager"
  exit 1
fi



# Repos
mkdir -p ~/Projects/{personal,playground}
mkdir -p ~/bin

# Vim
check_bin vim || { inst vim; }
dot vimrc
mkdir -p ~/.vim/{bundle,autoload}
[ -f ~/.vim/autoload/pathogen.vim ] || { curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim; }
[ -d ~/.vim/bundle/nerdtree ] || { git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree; }
[ -d ~/.vim/bundle/syntastic ] || { git clone https://github.com/scrooloose/syntastic.git ~/.vim/bundle/syntastic; }
[ -d ~/.vim/bundle/Vundle.vim ] || { git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim; }
[ -d ~/.vim/bundle/vim-colors-solarized ] || { git clone https://github.com/altercation/vim-colors-solarized.git ~/.vim/bundle/vim-colors-solarized; }

# Tmux
check_bin tmux || inst tmux
dot tmux.conf

# Zsh
check_bin zsh || inst zsh
dot zshrc
dot profile
[ -d ~/.oh-my-zsh ] || git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# Password store
[ -e ~/bin/pass ] || ln -s ~/Projects/personal/password-store/src/password-store.sh ~/bin/pass

# Python
check_bin python || inst python
check_bin pip || inst pip
check_bin virtualenvwrapper.sh || sudo pip install virtualenv virtualenvwrapper

# Dotfiles
# TODO: fixme, this is not right
exit 1
for name in $(ls ~/Projects/personal/dotfiles | grep -v bootstrap); do
  ln -s ~/Projects/personal/dotfiles/$name ~/.$name
done
