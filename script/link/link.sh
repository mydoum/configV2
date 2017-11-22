#! /bin/bash
# ==================================================================================
#   .linking files
# ==================================================================================
# link.sh
FILES_TO_LINK=("bashrc"
"bash_archive"
"screenrc"
"bash_profile"
"bash_env"
"dircolors")

notice "Configuring Bash"
for ((i = 0; i < ${#FILES_TO_LINK[@]}; i++))
do
    info "${FILES_TO_LINK[$i]} linked to HOME directory"
    ln -fs $DOTFILES_DIR/${FILES_TO_LINK[$i]} ~/.${FILES_TO_LINK[$i]}
done

notice "Configuring the readline"
ln -fs $DOTFILES_DIR/inputrc ~/.inputrc

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
if ! [[ -f ~/.hushlogin ]]; then
    cp $DOTFILES_DIR/hushlogin ~/.hushlogin
fi
