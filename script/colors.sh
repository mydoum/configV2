#! /bin/bash
# ==================================================================================
#   .CREDIT
# ==================================================================================
# This setup files have been mainly inspired by
# [NathanielLandau](https://github.com/natelandau/shell-scripts)
# ==================================================================================
#   .Colored output
# ==================================================================================
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

    echo -e "$(date +"%r") ${color}$(printf "[%9s]" "${1}") ${_message}${reset}";
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
function verbose()    { debug "$@"; }
