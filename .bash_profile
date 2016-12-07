# add to path the gopath
export PATH=/usr/local/bin:/usr/local/sbin:/opt/gccgo/bin:$PATH:$GOPATH/bin:/usr/local/share/npm/bin:/opt/local/bin:/opt/local/sbin:/usr/sbin

# command aliases
alias server='ssh user@***.***.***.***'
alias path='echo -e ${PATH//:/\\n}'
alias l='ls -GFh'
alias la='ls -a'
alias ll='ls -lv'
alias tree='tree -C'
alias untar='tar -zxvf'
alias mkdir='mkdir -p'

# ============================================
# ================ Bash conf =================
# ============================================

alias sourceb='source ~/.bash_profile'
alias vimbash='vim ~/.bash_profile'

# ============================================
# ================ NodeJS conf ================
# ============================================

# export NODE_PATH=/usr/local/lib/node
# export NODE_PATH=/usr/local/Cellar/node/7.0.0/bin/node

# ============================================
# ================ Go conf ================
# ============================================

alias godebug='go build -gcflags "-N -l"'
export GOPATH=$HOME/Documents/tmp/6.824
export GOROOT=/usr/local/go

# ============================================
# ================ Java conf ================
# ============================================

export JBOSS_HOME=/usr/local/opt/wildfly-as/libexec
export PATH=${PATH}:${JBOSS_HOME}/bin

function tomcat(){
    /usr/local/Cellar/tomcat/8.0.27/bin/catalina run
}

# ============================================
# ================ Python conf ================
# ============================================

#alias python='/usr/bin/python2.7'
#export PYTHONPATH=/usr/local/lib/python2.7/site-packages

# added by Anaconda3 4.1.1 installer
export PYTHONPATH=/Users/alonso/anaconda3/bin/python3.5
export PATH="/Users/alonso/anaconda3/bin:$PATH"

# ============================================
# ================ Extra conf ================
# ============================================

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# ============================================
# ================ POSTGRESQL ================
# ============================================

export PGDATA=$HOME/Documents/data/postgresql_9-4
alias pg='postgres -D $PGDATA'
alias pgfile='cd ~/Documents/Study/Projects/postgresql/sujet_bdd/girald_a-rattrapage-bdd'

# ============================================
# ================ PHP conf ==================
# ============================================

# shortcuts php
alias php-start='launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php55.plist'
alias php-stop='launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.php55.plist'
alias php-restart='php-stop && php-start'

# start needed services to work
function start(){
    mysql.server start
    sudo nginx
    php-start
}

function stop(){
    mysql.server stop
    sudo nginx -s stop
    php-stop
}

# ============================================
# =================== Ruby ===================
# ============================================

eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/shims:$PATH"

# ============================================
# ================ FUNCTIONS =================
# ============================================

# functions
function mkcd(){
    mkdir $1
    cd $1
}

function man(){
    man $1 | less
}

# function to replace $CURR if you do often more than one command
function curr(){
    cd /Users/alonso/Documents/study/All/java/2015
}

# ============================================
# ================ Prompt & Shell ============
# ============================================

# prompt & colors
export PS1="\[\033[31m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1

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

##
# Your previous /Users/alonso/.bash_profile file was backed up as /Users/alonso/.bash_profile.macports-saved_2014-11-04_at_18:19:13
##

# MacPorts Installer addition on 2014-11-04_at_18:19:13: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


