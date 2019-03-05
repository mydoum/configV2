#! /bin/bash
# ============================================================================
# CREDIT
# This setup files have been mainly inspired by
# [NathanielLandau](https://github.com/natelandau/shell-scripts)
# ============================================================================
# ============================================================================
# osx.sh
# This script is only for OSX, it installs your favorite applications through
# homebrew, hombrew cask and mas
# ============================================================================

# Import the colors function for logging
source $DOTFILE_SCRIPTS_DIR/colors.sh

# Import the confirmation dialog functions
source $DOTFILE_SCRIPTS_DIR/confirmation.sh

function mainScript() {
    function installHomebrewPackages() {
        unset LISTINSTALLED INSTALLCOMMAND RECIPES

        notice "Checking for Homebrew packages to install..."

        checkTaps

        LISTINSTALLED="brew list"
        INSTALLCOMMAND="brew install"

        source $DOTFILE_SCRIPTS_DIR/setup/recipes/10_osx_homebrew.sh
        # for item in "${RECIPES[@]}"; do
        #   info "$item"
        # done
        if doInstall; then
            success "Done installing Homebrew packages"
        else
            verbose "All homebrew packages already installed"
        fi
    }

    function installCaskApps() {
        unset LISTINSTALLED INSTALLCOMMAND RECIPES

        notice "Checking for casks to install..."

        checkTaps

        LISTINSTALLED="brew cask list"
        INSTALLCOMMAND="brew cask install --appdir=/Applications"

        source $DOTFILE_SCRIPTS_DIR/setup/recipes/20_osx_cask.sh
        # for item in "${RECIPES[@]}"; do
        #   info "$item"
        # done
        if doInstall; then
            success "Done installing cask apps"

            # Oversight needs to be installed with more rights
            if ! open -Ra "Oversight"; then
                open /usr/local/Caskroom/oversight/1.0.0/OverSight_Installer.app
            fi

        else
            verbose "All cask applications already installed"
        fi
    }

	function installAppStoreApps() {
        unset LISTINSTALLED INSTALLCOMMAND RECIPES

        notice "Checking for App Store apps to install..."

        checkTaps

        LISTINSTALLED="mas list"
        INSTALLCOMMAND="mas install"

        source $DOTFILE_SCRIPTS_DIR/setup/recipes/30_osx_app_store.sh
        # for item in "${RECIPES[@]}"; do
        #   info "$item"
        # done

        if doInstall; then
            success "Done installing app store apps"
        else
            verbose "All app store applications already installed"
        fi
    }

	function configureSSH() {
        notice "Configuring SSH"

        if [[ -f "${HOME}/.ssh/id_ecdsa_main.pub" ]]; then
           verbose "A public ecdsa key already exist"
        else
            ssh-keygen -f $HOME/.ssh/id_ecdsa_main.key -t ecdsa -b 521
            success "A SSH key generated"
        fi

        # Add SSH keys to Github
        seek_confirmation "Add SSH key to Github?"
        if is_confirmed; then
          info "Copying the key to the clipboard"
          [[ -f "${HOME}/.ssh/id_rsa.pub" ]] && cat "${HOME}/.ssh/id_rsa.pub" \
              | pbcopy

          open https://github.com/account/ssh

          success "Git SSH Configured"
        fi

        # Add SSH keys to Bitbucket
        seek_confirmation "Add SSH key to Bitbucket?"
        if is_confirmed; then
          info "Copying the key to the clipboard"
          [[ -f "${HOME}/.ssh/id_rsa.pub" ]] && cat "${HOME}/.ssh/id_rsa.pub" \
              | pbcopy

          open https://bitbucket.org/account/user/${BITBUCKET_USER}/ssh-keys/

          success "Bitbucket SSH Configured"
        fi
    }

    function installCommandLineTools() {
        notice "Checking for Command Line Tools..."

        if [[ ! "$(type -P gcc)" || ! "$(type -P make)" ]]; then
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

			success "Command Line Tools installed"
		else
			verbose "Command Line Tools already installed"
        fi

    }

	function installHomebrew () {
    	# Check for Homebrew
    	notice "Checking for Homebrew..."
    	if [ ! "$(type -P brew)" ]; then
      		notice "No Homebrew. Gots to install it..."
      		#   Ensure that we can actually, like, compile anything.
      		if [[ ! $(type -P gcc) && "$OSTYPE" =~ ^darwin ]]; then
        		notice "XCode or the Command Line Tools for XCode must be installed first."
        		installCommandLineTools
      		fi
      		# Check for Git
      		if [ ! "$(type -P git)" ]; then
        		notice "XCode or the Command Line Tools for XCode must be installed first."
        		installCommandLineTools
      		fi
      		# Install Homebrew
      		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

      		installHomebrewTaps
    		success "Homebrew installed"
		else
			verbose "Homebrew already installed"
    	fi
    }

	function checkTaps() {
    	if ! brew cask help &>/dev/null; then
    	  installHomebrewTaps
    	fi
    	if [ ! "$(type -P mas)" ]; then
    	  installHomebrewTaps
    	fi
  	}

  	function installHomebrewTaps() {
  	    brew install argon/mas/mas
  	    brew tap argon/mas
  	    brew tap caskroom/cask
    }

	function isAppInstalled() {
        # Feed this function either the bundleID (com.apple.finder) or a name (finder) for a native
        # mac app and it will determine whether it is installed or not
        #
        # usage: if isAppInstalled 'finder' &>/dev/null; then ...
        #
        # http://stackoverflow.com/questions/6682335/how-can-check-if-particular-application-software-is-installed-in-mac-os

        local appNameOrBundleId="$1" isAppName=0 bundleId
        # Determine whether an app *name* or *bundle ID* was specified.
        [[ $appNameOrBundleId =~ \.[aA][pP][pP]$ || $appNameOrBundleId =~ ^[^.]+$ ]] && isAppName=1
        if (( isAppName )); then # an application NAME was specified
            # Translate to a bundle ID first.
            bundleId=$(osascript -e "id of application \"$appNameOrBundleId\"" 2>/dev/null) ||
              { echo "$FUNCNAME: ERROR: Application with specified name not found: $appNameOrBundleId" 1>&2; return 1; }
        else # a BUNDLE ID was specified
            bundleId=$appNameOrBundleId
        fi
        # Let AppleScript determine the full bundle path.
        osascript -e "tell application \"Finder\" to POSIX path of (get application file id \"$bundleId\" as alias)" 2>/dev/null ||
          { echo "$FUNCNAME: ERROR: Application with specified bundle ID not found: $bundleId" 1>&2; return 1; }
    }

	function installXcode() {
    	notice "Checking for XCode..."
    	if ! isAppInstalled 'xcode' &>/dev/null; then
    	    unset LISTINSTALLED INSTALLCOMMAND RECIPES

    	    checkTaps

    	    LISTINSTALLED="mas list"
    	    INSTALLCOMMAND="mas install"
    	    RECIPES=(
    	      497799835 #xCode
    	    )
    	    doInstall

    	    # we also accept the license
    	    sudo xcodebuild -license accept
    	    success "XCode installed"
        else
            verbose "XCode already installed"
    	fi

	}

	function doInstall () {
    	# Reads a list of items, checks if they are installed, installs
    	# those which are needed.
    	#
    	# Variables needed are:
    	# LISTINSTALLED:  The command to list all previously installed items
    	#                 Ex: "brew list" or "gem list | awk '{print $1}'"
    	#
    	# INSTALLCOMMAND: The Install command for the desired items.
    	#                 Ex:  "brew install" or "gem install"
    	#
    	# RECIPES:      The list of packages to install.
    	#               Ex: RECIPES=(
    	#                     package1
    	#                     package2
    	#                   )
    	#
    	# Credit: https://github.com/cowboy/dotfiles

        # to_install( RECIPES[*], LISTINSTALLED) list
        # $1 : RECIPES[*] : Array -> All recipes expected to get
        # $2 : LISTINSTALLED : String -> Get all installed recipes ex : brew list
        # return : list : Array -> List which will be installed
    	function to_install() {
    	    local desired installed i desired_s installed_s remain

            # Convert args to list of elements separated by spaces
    	    read -ra desired < <(echo "$1" | tr '\n' ' ')
    	    read -ra installed < <(echo "$2" | tr '\n' ' ')

    	    # Sort desired and installed arrays.
    	    unset i; while read -r; do desired_s[i++]=$REPLY; done < <(
    	        printf "%s\n" "${desired[@]}" | sort
    	    )
    	    unset i; while read -r; do installed_s[i++]=$REPLY; done < <(
    	        printf "%s\n" "${installed[@]}" | sort
    	    )
    	    # Get the difference. comm is awesome.
    	    unset i; while read -r; do remain[i++]=$REPLY; done < <(
    	        comm -13 <(printf "%s\n" "${installed_s[@]}") <(printf "%s\n" "${desired_s[@]}")
    	    )
    	    echo "${remain[@]}"
    	}

    	function checkInstallItems() {
    	    # If we are working with 'cask' we need to dedupe lists
    	    # since apps might be installed by hand
    	    if [[ $INSTALLCOMMAND =~ cask ]]; then
    	        if isAppInstalled "${item}" &>/dev/null; then
    	            continue
    	        fi
    	    fi
    	    # If we installing from mas (mac app store), we need to
            # dedupe the list AND
    	    # sign in to the app store
    	    if [[ $INSTALLCOMMAND =~ mas ]]; then
    	        # Lookup the name of the application being installed
    	        appName="$(curl -s https://itunes.apple.com/lookup?id=$item | jq .results[].trackName)"
    	        if isAppInstalled "${appName}" &> /dev/null; then
    	            continue
    	        fi
    	        # Tell the user the name of the app
    	    	notice "$item --> $appName"
    	    fi
    	}

        list=($(to_install "${RECIPES[*]}" "$(${LISTINSTALLED})"))

    	# Log in to the Mac App Store if using mas
    	if [[ $INSTALLCOMMAND =~ mas ]] && [[ list -ne "" ]]; then
    	    mas signout
    	    input "Please enter your Mac app store username: "
    	    read macStoreUsername
    	    input "Please enter your Mac app store password: "
    	    read -s macStorePass
    	    echo ""
    	    mas signin $macStoreUsername "$macStorePass"
    	fi

    	if [ ${#list[@]} -gt 0 ]; then
    	    seek_confirmation "Confirm each package before installing?"
    	    if is_confirmed; then
    	        for item in "${list[@]}"; do
    	            checkInstallItems
    	            seek_confirmation "Install ${item}?"
    	            if is_confirmed; then
    	                notice "Installing ${item}"
    	                # FFMPEG takes additional flags
    	                if [[ "${item}" = "ffmpeg" ]]; then
    	                    installffmpeg
    	                elif [[ "${item}" = "tldr" ]]; then
    	                    brew tap tldr-pages/tldr
    	                    brew install tldr
    	                else
    	                    ${INSTALLCOMMAND} "${item}"
    	                fi
    	            fi
    	        done
    	    else
    	        for item in "${list[@]}"; do
    	            checkInstallItems
    	            notice "Installing ${item}"
    	            # FFMPEG takes additional flags
    	            if [[ "${item}" = "ffmpeg" ]]; then
    	                installffmpeg
    	            elif [[ "${item}" = "tldr" ]]; then
    	                brew tap tldr-pages/tldr
    	                brew install tldr
    	            else
    	                ${INSTALLCOMMAND} "${item}"
    	            fi
    	        done
    	    fi
        else
            return 1 # Nothing to install
    	fi
    }

	###################
  	# Run the script
  	# ###################

  	# Ask for the administrator password upfront
  	sudo -v

    installCommandLineTools
	installHomebrew
	checkTaps
    installXcode
    installHomebrewPackages
    installCaskApps
    installAppStoreApps
    configureSSH
}

# ==================================================================================
#   .Entrypoint
# ==================================================================================

mainScript
