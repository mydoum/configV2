#! /bin/bash
# ============================================================================
# CREDIT
# This setup files have been mainly inspired by
# [Stratus3D](https://github.com/Stratus3D/dotfiles/blob/master/scripts/setup.sh)
# ============================================================================
# ============================================================================
# setup.sh
# This is the entrypoint of the configuration
# ============================================================================

# It currently only works with OSX
[[ "$OSTYPE" =~ ^darwin ]] || return 1

DOTFILES_DIR=$HOME/dotfiles
DOTFILE_SCRIPTS_DIR=$DOTFILES_DIR/scripts

# ===========================================
# Git
# ===========================================
if [ ! -d $DOTFILES_DIR ]; then
  if hash git 2>/dev/null; then
    echo "Git is already installed. Cloning repository..."
    git clone git@github.com:mydoum/dotfiles.git $DOTFILES_DIR
  else
    echo "Git is not installed. Installing it..."
    #Since macport is by default installed, we use it
    port selfupdate
    port install git
    git clone git@github.com:mydoum/dotfiles.git $DOTFILES_DIR
    # TODO: Uninstall macport when homebrew is installed
  fi
else
  cd $DOTFILES_DIR
  # We could have modifications in the repository, so we stash them
  git stash
  git pull origin master
  git stash pop
fi

# Source and launch
source DOTFILE_SCRIPTS_DIR/setup/osx.sh

