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
# If the folder is present and not a symlink then erase it and replace it with
# ours
if [[ -d ~/.vim ]]; then
    if ! [[ -L ~/.vim ]]; then
        rm -r ~/.vim
        ln -fs $DOTFILES_DIR/vim ~/.vim
    fi
else
    ln -fs $DOTFILES_DIR/vim ~/.vim
fi

# vimrc needs solarized to not be buggy so it's linked after
ln -fs $DOTFILES_DIR/vimrc ~/.vimrc

if ! [[ -f ~/.vim/autoload/plug.vim ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

vim +PluginInstall +qall
success "Vim plugin installed"

# git
notice "Configuring git"
ln -fs $DOTFILES_DIR/gitconfig ~/.gitconfig

# hush login
if ! [[ -f ~/.vim/autoload/plug.vim ]]; then
    cp $DOTFILES_DIR/hushlogin ~/.hushlogin
fi
