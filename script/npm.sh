#! /bin/bash

# Import the confirmation dialog functions
source $DOTFILE_SCRIPTS_DIR/confirmation.sh

notice "Updating npm"
npm update

seek_confirmation "Install global npm dependencies?"
if is_confirmed; then
  notice "Installing npm dependencies"
  npm install nodemon -g
  npm install gulp -g
  npm install jade -g
  npm install ember-cli -g
fi

notice "Installing meteor"
if ! type meteor; then
    curl https://install.meteor.com/ | sh
    sudo chown -R $USER ~/.meteor
    ln -s ~/.meteor/meteor /usr/local/bin
    success "meteor successfully installed"
else
    debug "Meteor already installed"
fi
