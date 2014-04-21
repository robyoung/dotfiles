#!/bin/bash
#
# Run this script from this directory.

function fail {
  echo $1
  exit 1
}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Link config files into place
for file in $(ls $DIR | grep -v 'bootstrap.sh'); do
  rm ~/.$file;
  ln -s $DIR/$file ~/.$file;
done

mkdir -p ~/.git_template

# Setup VIM
## Install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle

## Install pathogen
curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

## Install NerdTREE
git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree

## Install vim-puppet
git clone https://github.com/rodjek/vim-puppet.git ~/.vim/bundle/vim-puppet

# Set up zsh
[ $(which zsh) ] || fail "zsh not installed"

## Set zsh as default shell
chsh -s $(which zsh)

## Install oh my zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
