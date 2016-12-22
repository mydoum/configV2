# ---------------------------------------------------------------------------

# Sections:
# 1. Environment Configuration
# 2. Make Terminal Better (remapping defaults and adding functionality)
# 3. Functions
# 4. Process Management
# 5. Networking

# ---------------------------------------------------------------------------

# ============================================
# -1. TEMPORARY COMMANDS
# ============================================


# ============================================
# 0. EXTRA NON OPEN CONFIGURATION
# ============================================

if [ -f ~/.bash_private ]; then
   source ~/.bash_private
fi

# ============================================
# 1. ENVIRONMENT CONFIGURATION
# ============================================

DEFAULTPATH=/usr/bin:/bin:/usr/sbin:/sbin
BREWPATH=/usr/local/bin:/usr/local/sbin
LATEXPATH=/Library/TeX/texbin
export PATH=$DEFAULTPATH:$BREWPATH:$GOPATH/bin:$LATEXPATH

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# ================ Go conf ===================
alias godebug='go build -gcflags "-N -l"'
export GOPATH=$HOME
export GOROOT=/usr/local/go

# ============================================
# 2. MAKE TERMINAL A BETTER WORLD
# ============================================

# prompt & colors
export CLICOLOR=1
export PS1="\[\033[31m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export PS2="continue-> "
export PS4='\[\e[35m\]$0-l.$LINENO:\[\e[m\]  '


# LESS man page colors (makes Man pages more readable).
# from tldp.org
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# fix tmux
[ -n "$TMUX" ] && export TERM=screen-256color

# ================ LS =================
# With --color=auto, ls uses LS_COLORS environment varaible
test -r ~/.dircolors && eval "$(gdircolors -b ~/.dircolors)" \
    || eval "$(gdircolors -b)"
# "gls" comes from coreutils, it is used because "ls" from OSX doesn't uses
# --color=auto
alias ls='gls -F --color=auto'
alias l='ls -Fh'
alias la='ls -a'
alias ll='ls -lvh'

# ============= Aliases ===============
alias path='echo -e ${PATH//:/\\n}'
alias tree='tree -C'
alias untar='tar -zxvf'
alias mkdir='mkdir -pv'
alias grep='grep --color=auto'
alias mv='mv -iv'
alias less='less -FSRXc'
alias diff='colordiff'

alias sourceb='source ~/.bash_profile'
alias vimbash='vim ~/.bashrc'
alias \:q='exit'

# Activate the bash-completion which autocomplete argument and not
# only application names
if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi

# ============================================
#   3. FUNCTIONS
# ============================================

cd() { builtin cd "$@"; ll; }
mkcd() { mkdir -p $1; cd $1; }
# Man should be replaced by man on linux
man() { Man $1 | less; }

# extract:  Extract most know archives with one command
extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}
# Searching
ff () { sudo /usr/bin/find ~/ -name "$@" ; }      # ff:       Find file under the current directory
ffs () { sudo /usr/bin/find ~/ -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { sudo /usr/bin/find ~/ -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

killport () { kill -9 $(lsof -ti :$1) ;}	# killport:	Kill the application listening on this specific port

# ============================================
#   4. PROCESS MANAGEMENT
# ============================================

# cpuHogs:  Find CPU hogs
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

# Real time monitoring
alias monitor='top -R -F -s 10 -o rsize -s 2'

# List processes owned by my user
my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

# ============================================
#   5. NETWORKING
# ============================================

# Public facing IP Address
alias myip='curl ip.appspot.com'

# Display open TCP sockets
alias lsock='sudo /usr/sbin/lsof -nP | grep TCP'

# Useful information
ii() {
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Current network location :$NC " ; scselect
    echo -e "\n${RED}Public facing IP Address :$NC " ;myip
    #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
    echo
}

# TODO: change then alias depending on the distrib
if [[ "$OSTYPE" =~ ^darwin ]]; then
    alias wifi='networksetup -getairportpower en1 | grep "On" && networksetup -setairportpower en1 off || networksetup -setairportpower en1 on '
fi
