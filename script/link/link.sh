#! /bin/bash
# ==================================================================================
#   .linking files
# ==================================================================================
# link.sh

# bash
ln -fs $DOTFILES_DIR/bashrc ~/.bashrc
ln -fs $DORFILES_DIR/bash_profile ~/.bash_profile

# vim
ln -fs $DOTFILES_DIR/vimrc ~/.vimrc
cp -r $DOTFILES_DIR/vim/ ~/.vim/

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PluginInstall +qall
success "Vim plugin installed"

# git
ln -fs $DOTFILES_DIR/gitconfig ~/.gitconfig
