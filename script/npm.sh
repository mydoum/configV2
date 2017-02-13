#! /bin/bash

notice "Updating npm"
npm update

notice "Installing npm dependencies"
npm install nodemon -g
npm install gulp -g
npm install jade -g
npm install bower -g
npm install ember-cli -g

notice "Installing meteor"
if ! type meteor; then
    curl https://install.meteor.com/ | sh
    sudo chown -R $USER ~/.meteor
    ln -s ~/.meteor/meteor /usr/local/bin
    success "meteor successfully installed"
else
    debug "Meteor already installed"
fi
