#! /bin/bash
# ==================================================================================
#   .linking files
# ==================================================================================
# link.sh

# bash
notice "Configuring Bash"
ln -fs $DOTFILES_DIR/bashrc ~/.bashrc
ln -fs $DOTFILES_DIR/bash_profile ~/.bash_profile
ln -fs $DOTFILES_DIR/dircolors ~/.dircolors

# vim
notice "Configuring Vim"
ln -fs $DOTFILES_DIR/vimrc ~/.vimrc
cp -r $DOTFILES_DIR/vim/ ~/.vim/

if ! [[ -f ~/.vim/autoload/plug.vim ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

vim +PluginInstall +qall
success "Vim plugin installed"

# git
notice "Configuring git"
ln -fs $DOTFILES_DIR/gitconfig ~/.gitconfig

