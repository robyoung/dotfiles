#!/bin/bash
#
# Run this script from this directory.

DIR=$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )

for file in $(ls $DIR | grep -v 'bootstrap.sh'); do
  rm ~/.$file;
  ln -s $DIR/$file ~/.$file;
done
