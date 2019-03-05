#! /bin/bash

# Import the confirmation dialog functions
source $DOTFILE_SCRIPTS_DIR/confirmation.sh

notice "Updating npm"
npm update

seek_confirmation "Install global npm dependencies?"
if is_confirmed; then
  notice "Installing npm dependencies"
  npm install -g @angular/cli
fi
