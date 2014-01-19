#!/bin/bash
#
# Run this script from this directory.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Link config files into place
for file in $(ls $DIR | grep -v 'bootstrap.sh'); do
  rm ~/.$file;
  ln -s $DIR/$file ~/.$file;
done

mkdir ~/.git_template

# Install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

## Install NerdTREE
git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
