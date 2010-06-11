#!/bin/bash
# ------------------------------------------------------------------------------
# Author    : Hugo Henriques Maia Vieira <hugomaiavieira@gmail.com>
# Licence   : Creative-commons by (http://creativecommons.org/licenses/by/3.0/)
# ------------------------------------------------------------------------------

# Black magic to get the folder where the script is running
FOLDER=$(cd $(dirname $0); pwd -P)

[ ! -e $HOME/.refactoring-scripts ] && mkdir $HOME/.refactoring-scripts
cp -rf $FOLDER/bin $HOME/.refactoring-scripts
sudo ln -sf $HOME/.refactoring-scripts/* /usr/bin

