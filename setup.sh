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

# ====
BITBUCKET_USER=mydoum
# ====

DOTFILES_DIR=$HOME/dotfiles
DOTFILE_SCRIPTS_DIR=$DOTFILES_DIR/script
DOTFILE_SCRIPTS_OSX_DIR=$DOTFILE_SCRIPTS_DIR/setup

# ===========================================
# Xcode
# ===========================================
function installCommandLineTools() {
    local osx_vers=$(sw_vers -productVersion | awk -F "." '{print $2}')
    local cmdLineToolsTmp="${tmpDir}/.com.apple.dt.CommandLineTools.installondemand.in-progress"

    # Create the placeholder file which is checked by the software update tool
    # before allowing the installation of the Xcode command line tools.
    touch "${cmdLineToolsTmp}"

    # Find the last listed update in the Software Update feed with "Command Line Tools" in the name
    cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | tail -1 | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)

    softwareupdate -i "${cmd_line_tools}" -v

    # Remove the temp file
    if [ -f "${cmdLineToolsTmp}" ]; then
        rm ${v} "${cmdLineToolsTmp}"
    fi
}

if [[ ! "$(type -P gcc)" || ! "$(type -P make)" ]]; then
    installCommandLineTools
fi


if [ ! -d $DOTFILES_DIR ]; then
    if hash git 2>/dev/null; then
        echo "Git is already installed. Cloning repository..."
        git clone git@github.com:mydoum/dotfiles.git $DOTFILES_DIR
    else
        echo "Git is not installed...Something is wrong, it should work
        natively on OSX..."
        return 1
    fi
fi

# Source and launch
source $DOTFILE_SCRIPTS_OSX_DIR/osx.sh

# Linking
source $DOTFILE_SCRIPTS_DIR/link/link.sh

# SSD
source $DOTFILE_SCRIPTS_OSX_DIR/ssd.sh

# OSX_DEFAULTS options
source $DOTFILE_SCRIPTS_OSX_DIR/osx_defaults.sh

# npm installation
source $DOTFILE_SCRIPTS_DIR/npm.sh

# pip installation
source $DOTFILE_SCRIPTS_DIR/pip.sh
