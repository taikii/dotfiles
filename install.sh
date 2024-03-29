#!/usr/bin/env bash
readonly BASEDIR=$(readlink -f $0 | xargs dirname)

[[ -f ~/.bash_aliases ]] && mv ~/.bash_aliases ~/.bash_aliases.bak$(date +%Y%m%d)
ln -s ${BASEDIR}/bash_aliases ~/.bash_aliases

[[ -f ~/.vimrc ]] && mv ~/.vimrc ~/.vimrc.bak$(date +%Y%m%d)
ln -s ${BASEDIR}/vimrc ~/.vimrc

[[ -f ~/.gvimrc ]] && mv ~/.gvimrc ~/.gvimrc.bak$(date +%Y%m%d)
ln -s ${BASEDIR}/gvimrc ~/.gvimrc

# ~/.vim/undo がなければ作成する
[[ -d ~/.vim/undo ]] || mkdir -p ~/.vim/undo

[[ -f ~/.gitconfig ]] && mv ~/.gitconfig ~/.gitconfig.bak$(date +%Y%m%d)
ln -s ${BASEDIR}/gitconfig ~/.gitconfig
source ~/.bashrc
