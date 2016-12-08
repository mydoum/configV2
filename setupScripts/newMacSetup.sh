#! /bin/bash

function mainScript() {

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
			info "Command Line Tools already installed"
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
			info "Homebrew already installed"
    	fi
    }

	function checkTaps() {
    	verbose "Confirming we have required Homebrew taps"
    	if ! brew cask help &>/dev/null; then
    	  installHomebrewTaps
    	fi
    	if [ ! "$(type -P mas)" ]; then
    	  installHomebrewTaps
    	fi
  	}

  	function installHomebrewTaps() {
  	    brew tap homebrew/dupes
  	    brew tap homebrew/versions
  	    brew install argon/mas/mas
  	    brew tap argon/mas
  	    brew tap caskroom/cask
  	    brew tap caskroom/fonts
  	    brew tap caskroom/versions
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
            info "XCode already installed"
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



    	function to_install() {
    	    local desired installed i desired_s installed_s remain
    	    # Convert args to arrays, handling both space- and newline-separated lists.
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
    	    # If we installing from mas (mac app store), we need to dedupe the list AND
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

    	# Log in to the Mac App Store if using mas
    	if [[ $INSTALLCOMMAND =~ mas ]]; then
    	    mas signout
    	    input "Please enter your Mac app store username: "
    	    read macStoreUsername
    	    input "Please enter your Mac app store password: "
    	    read -s macStorePass
    	    echo ""
    	    mas signin $macStoreUsername "$macStorePass"
    	fi

    	list=($(to_install "${RECIPES[*]}" "$(${LISTINSTALLED})"))

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
}

function seek_confirmation() {
    # Asks questions of a user and then does something with the answer.
    # y/n are the only possible answers.
    #
    # USAGE:
    # seek_confirmation "Ask a question"
    # if is_confirmed; then
    #   some action
    # else
    #   some other action
    # fi
    #
    # Credt: https://github.com/kevva/dotfiles
    # ------------------------------------------------------

    input "$@"
    if ${force}; then
        notice "Forcing confirmation with '--force' flag set"
    else
        read -p " (y/n) " -n 1
        echo ""
    fi
}


# Set Flags
# -----------------------------------
# Flags which can be overridden by user input.
# Default values are below
# -----------------------------------
quiet=false
printLog=false
verbose=false
force=false
strict=false
debug=false
args=()

# Set Temp Directory
# -----------------------------------
# Create temp directory with three random numbers and the process ID
# in the name.  This directory is removed automatically at exit.
# -----------------------------------
tmpDir="/tmp/${scriptName}.$RANDOM.$RANDOM.$RANDOM.$$"
(umask 077 && mkdir "${tmpDir}") || {
  die "Could not create temporary directory! Exiting."
}

# ==================================================================================
#   .Logging
# ==================================================================================
# Log is only used when the '-l' flag is set.
# ==================================================================================
# To never save a logfile change variable to '/dev/null'
# Save to Desktop use: $HOME/Desktop/${scriptBasename}.log
# Save to standard user log location use: $HOME/Library/Logs/${scriptBasename}.log
# -----------------------------------
logFile="${HOME}/Library/Logs/${scriptBasename}.log"


# ==================================================================================
# Options and Usage
# ==================================================================================
# Print usage
# ==================================================================================

usage() {
  echo -n "${scriptName} [OPTION]... [FILE]... This is a script template.  Edit this description to print help to users.
 ${bold}Options:${reset}
  -u, --username    Username for script
  -p, --password    User password
  --force           Skip all user interaction.  Implied 'Yes' to all actions.
  -q, --quiet       Quiet (no output)
  -l, --log         Print log to file
  -s, --strict      Exit script with null variables.  i.e 'set -o nounset'
  -v, --verbose     Output more information. (Items echoed to 'verbose')
  -d, --debug       Runs script in BASH debug mode (set -x)
  -h, --help        Display this help and exit
      --version     Output version information and exit
"
}

# Iterate over options breaking -ab into -a -b when needed and --foo=bar into
# --foo bar
optstring=h
unset options
while (($#)); do
  case $1 in
    # If option is of type -ab
    -[!-]?*)
      # Loop over each character starting with the second
      for ((i=1; i < ${#1}; i++)); do
        c=${1:i:1}

        # Add current char to options
        options+=("-$c")

        # If option takes a required argument, and it's not the last char make
        # the rest of the string its argument
        if [[ $optstring = *"$c:"* && ${1:i+1} ]]; then
          options+=("${1:i+1}")
          break
        fi
      done
      ;;

    # If option is of type --foo=bar
    --?*=*) options+=("${1%%=*}" "${1#*=}") ;;
    # add --endopts for --
    --) options+=(--endopts) ;;
    # Otherwise, nothing special
    *) options+=("$1") ;;
  esac
  shift
done
set -- "${options[@]}"
unset options

# ==================================================================================
# Print help if no arguments were passed.
# Uncomment to force arguments when invoking the script
# ==================================================================================
# [[ $# -eq 0 ]] && set -- "--help"

# Read the options and set stuff
while [[ $1 = -?* ]]; do
  case $1 in
    -h|--help) usage >&2; safeExit ;;
    --version) echo "$(basename $0) ${version}"; safeExit ;;
    -u|--username) shift; username=${1} ;;
    -p|--password) shift; echo "Enter Pass: "; stty -echo; read PASS; stty echo;
      echo ;;
    -v|--verbose) verbose=true ;;
    -l|--log) printLog=true ;;
    -q|--quiet) quiet=true ;;
    -s|--strict) strict=true;;
    -d|--debug) debug=true;;
    --force) force=true ;;
    --endopts) shift; break ;;
    *) die "invalid option: '$1'." ;;
  esac
  shift
done

# Store the remaining part as arguments.
args+=("$@")

# ==================================================================================
#   .Logging and Colors
# ==================================================================================
# Here we set the colors for our script feedback.
# Example usage: success "sometext"
# ==================================================================================

# Set Colors
bold=$(tput bold)
reset=$(tput sgr0)
purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)
underline=$(tput sgr 0 1)

# Color the logs
function _alert() {
  if [ "${1}" = "emergency" ]; then local color="${bold}${red}"; fi
  if [ "${1}" = "error" ]; then local color="${bold}${red}"; fi
  if [ "${1}" = "warning" ]; then local color="${red}"; fi
  if [ "${1}" = "success" ]; then local color="${green}"; fi
  if [ "${1}" = "debug" ]; then local color="${purple}"; fi
  if [ "${1}" = "header" ]; then local color="${bold}""${tan}"; fi
  if [ "${1}" = "input" ]; then local color="${bold}"; printLog="false"; fi
  if [ "${1}" = "info" ] || [ "${1}" = "notice" ]; then local color=""; fi
  # Don't use colors on pipes or non-recognized terminals
  if [[ "${TERM}" != "xterm"* ]] || [ -t 1 ]; then color=""; reset=""; fi

  # Print to $logFile
  if ${printLog}; then
    echo -e "$(date +"%m-%d-%Y %r") $(printf "[%9s]" "${1}") ${_message}" >> "${logFile}";
  fi

  # Print to console when script is not 'quiet'
  if ${quiet}; then
   return
  else
   echo -e "$(date +"%r") ${color}$(printf "[%9s]" "${1}") ${_message}${reset}";
  fi
}

function die ()       { local _message="${*} Exiting."; echo "$(_alert emergency)"; safeExit;}
function error ()     { local _message="${*}"; echo "$(_alert error)"; }
function warning ()   { local _message="${*}"; echo "$(_alert warning)"; }
function notice ()    { local _message="${*}"; echo "$(_alert notice)"; }
function info ()      { local _message="${*}"; echo "$(_alert info)"; }
function debug ()     { local _message="${*}"; echo "$(_alert debug)"; }
function success ()   { local _message="${*}"; echo "$(_alert success)"; }
function input()      { local _message="${*}"; echo -n "$(_alert input)"; }
function header()     { local _message="${*}"; echo "$(_alert header)"; }

# Log messages when verbose is set to "true"
verbose() { if ${verbose}; then debug "$@"; fi }

# ==================================================================================
#   .Entrypoint
# ==================================================================================

mainScript
