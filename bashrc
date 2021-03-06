# My bashrc personal configuration
# ---------------------------------------------------------------------------

# Sections
# 1. Environment Configuration
# 2. Backup history
# 3. Make Terminal Better (remapping defaults and adding functionality)
# 4. Functions
# 5. Process Management
# 6. Networking

# ---------------------------------------------------------------------------

# ============================================
# -5. BASH REMINDER
# ============================================

echo '[INFO] Bash reminders'
echo '!string : execute the last command containing string'
echo 'top : launch gtop a sexy node application'
echo ''

# ============================================
# -4. APPLICATIONS REMINDER
# ============================================
echo '[INFO] App reminders'
echo 'IMGCAT : display image in command line'
echo 'PIDOF  : get pid of your app'
echo 'TLDR   : show compact documentation of your app'

echo ''

# ============================================
# -3. CODING STYLE REMINDER
# ============================================

# [[ ... ]] is preferred over [ ... ]
# For a function, don't use the keyword "function"
# In function, use "local" variables
# If the line is long, add "\" at the end of the line

# ============================================
# -2. TEMPORARY COMMANDS
# ============================================


# Add cloud key on ssh agent
# ssh-add ~/.ssh/cloud

#################
# Usage : token prod|preprod|dev
#################
alias cur='cd /Users/alonso/Projects/staffme/staffme_v2_bp'
alias curtog='cd /Users/alonso/Projects/together/TOG-POC1'
alias python='/usr/local/bin/python3'

export PASSWORD=$password

kill-kafka() {
  kill -9 $(lsof -ti :9092)
}

# ============================================
# -2. APPLICATION COMMANDS REMINDERS
# ============================================

echo '[REMINDERS]'
echo 'kafka-reminder -> km'
kafka-reminder() {
  echo 'CONF            : /usr/local/etc/kafka'
  echo 'LOGS            : /usr/local/var/lib/kafka-logs'
  echo 'EXEC            : /usr/local/Cellar/kafka/0.10.2.0/libexec/'
  echo 'ZOOKEEPER DATA  : /usr/local/var/lib/zookeeper'
  echo 'KAFKA DATA      : /usr/local/var/lib/kafka-logs'
  echo 'CREATE          : kafka-topics --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test'
  echo 'LIST TOPICS     : kafka-topics --list --zookeeper localhost:2181'
  echo 'ON DOCKER PHENIX: /opt/kafka_2.11-0.8.2.2/bin/kafka-topics.sh --list --zookeeper kafka:2181/kafka'
  echo 'CONSUME         : kafka-console-consumer --bootstrap-server localhost:9092 --topic test --from-beginning'
}

alias km=kafka-reminder

echo 'hadoop-reminder'
hadoop-reminder() {
  echo 'CONF  : /usr/local/Cella/hadoop/2.X.X/'
}

echo 'sbt-reminder'
sbt-reminder() {
  echo 'LIST PROJECTS       : projects'
  echo 'SELECT PROJECT:     : project projectname'
  echo 'EXECUTE SINGLE IT TEST : sbt "it:testOnly -- -n tagName'
}

echo 'proxy-reminder'
proxy-reminder() {
  echo 'ACTIVATE PROXY                      : proxy_on'
  echo 'DISABLE PROXY(SBT PROXY DISABLED)   : proxy_off'
  echo 'DISABLE SBT PROXY                   : sbt_proxy false'
}

echo 'docker-reminder'
docker-reminder() {
  echo 'launch SBT command      : docker-compose exec --user $PHENIX_USER_NAME --privileged build sbt -v it:test'
  echo 'Enter in container      : docker exec -ti <docker ID> /bin/bash'
  echo 'Remove images instances : docker rm -f $(docker ps -aq)'
}

echo 'hdfs-reminder'
hdfs-reminder() {
  echo 'HDFS/Docker: docker-compose exec --privileged hdfs /bin/bash'
  echo 'HDFS/Docker/CMDS: /usr/bin'
  echo 'HDFS/Docker/List files: /usr/bin/hdfs dfs -ls -R /user'
  echo 'HDFS/Docker/rm files: HADOOP_USER_NAME=hdfs hdfs dfs -rm -r -f /user/phenix'
}

echo ''
# ============================================
# -1. GLOBAL VARIABLES
# ============================================

[[ "$OSTYPE" =~ ^darwin ]] && ECHO=gecho || ECHO=echo
[[ "$OSTYPE" =~ ^darwin ]] && LS=gls || LS=ls

RED="\e[91m"
GREEN="\e[32m"
BOLD="\e[1m"
WHITE="\e[39m"

# ============================================
# 0. EXTRA NON OPEN CONFIGURATION
# ============================================

if [ -f ~/.bash_private ]; then
   source ~/.bash_private
fi

echo '[PRIVATE REMINDERS]'
echo 'sshk NAME'
echo 'scp_remote_file'
echo 'scp_local_file'


# ex: $user, $password, proxy_ip, $proxy_port

# ============================================
# 1. ENVIRONMENT CONFIGURATION
# ============================================

DEFAULTPATH=/usr/bin:/bin:/usr/sbin:/sbin
BREWPATH=/usr/local/bin:/usr/local/sbin
LATEXPATH=/Library/TeX/texbin
#export PATH=$BREWPATH:$DEFAULTPATH:$GOPATH/bin:$LATEXPATH:$AZUREPATH
export PATH=$DEFAULTPATH:$BREWPATH

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if [ -f ~/.bash_env ]; then
   source ~/.bash_env
fi

# ============================================
# 2. BACKUP HISTORY
# ============================================

# The number of lines or commands that (a) are allowed in the history file at
# startup time of a session, and (b) are stored in the history file at the end of
# your bash session for use in future sessions.
export HISTFILESIZE=10000

# The number of lines or commands that are stored in memory in a history list
# while your bash session is ongoing.
export HISTSIZE=500

# Don't put duplicate lines in the history and do not add lines that start with
# a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth

# Bash immediately add commands to our history instead of waiting for the end
# of each session
# This command append to the history file immediately with history -a, clear the
# current history in our session with history -c, and then read the history file
# that we've appended to, back into our session history with history -r
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# To execute the 51st command from bach history you can do :
# !51

# ============================================
# 3. MAKE TERMINAL A BETTER WORLD
# ============================================

# ========= Prompt & Colors ===========

export CLICOLOR=1

PS1_DEFAULT="\[\033[31m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
PS1_GIT="(\$(git branch 2>/dev/null | grep '^*' | colrm 1 2))"
PS1_END="\$ "
export PS1=$PS1_DEFAULT$PS1_GIT$PS1_END

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

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# ================ LS =================

# To temporarily bypass an alias, preceed the command with a \
# EG: the ls command is aliased, to use the normal ls command, type \ls

# With --color=auto, ls uses LS_COLORS environment varaible
test -r ~/.dircolors && eval "$(gdircolors -b ~/.dircolors)" \
    || eval "$(gdircolors -b)"
alias ls='${LS} -lvhaF --color=auto'

# ============= Aliases ===============

alias path='echo -e ${PATH//:/\\n}'
alias tree='tree -Ch'
alias mkdir='mkdir -pv'
alias grep='grep --color=auto'
alias mv='mv -iv'
alias less='less -FSRXc'
alias diff='colordiff'
alias wget='wget -c'            # continue the download in case of problems
alias bd='cd "$OLDPWD"'         # cd into the old directory

alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'

alias v='vim'
alias sourceb='source ~/.bash_profile'
alias bashrc='vim ~/.bashrc'
alias bash_env='vim ~/.bash_env'
alias vimrc='vim ~/.vimrc'
alias vi='vim'

alias \:q='exit'

alias ..='cd ..'
alias ...='cd ../..'

# Activate the bash-completion which autocomplete argument and not
# only application names
if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi

# ============================================
#   4. FUNCTIONS
# ============================================

cd() { builtin cd "$@"; ls; }
mcd() { mkdir -p $1; cd $1; }

#               extract:  Extract most know archives with one command
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
        *)     ${ECHO} "\e[1m\e[91m'$1' cannot be extracted via extract()" ;;
         esac
     else
         ${ECHO} "\e[1m\e[91m'$1' is not a valid file"
     fi
}


# ============= Searching ===============

if [[ "$OSTYPE" =~ ^darwin ]]; then
    # ff:       Find file on OSX with spotlight metadata
    ff () { mdfind -onlyin ~/ -name "$@" ; }
else
    # ff:       Find file under the current directory
    ff () { sudo /usr/bin/find ~/ -name "$@" ; }

    # ffs:      Find file whose name starts with a given string
    ffs () { sudo /usr/bin/find ~/ -name "$@"'*' ; }

    # ffe:      Find file whose name ends with a given string
    ffe () { sudo /usr/bin/find ~/ -name '*'"$@" ; }
fi

#               killport:	Kill the application listening on this specific port
killport () {
    if kill -9 $(pidof $1) 2>/dev/null ; then
        ${ECHO} -e "${GREEN}All instances killed"
    else
        ${ECHO} -e "${RED}Application not found"
    fi
}

#               killapp : Kill all applications from the given name
killapp () {
    if kill -9 $(pidof $1) 2>/dev/null ; then
        ${ECHO} -e "${GREEN}All instances killed"
    else
        ${ECHO} -e "${RED}Application not found"
    fi
}

# ============================================
#   5. PROCESS MANAGEMENT
# ============================================

#               cpuHogs:  Find CPU hogs
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#               monitor:  Real time monitoring
alias monitor='/usr/bin/top -R -F -s 10 -o rsize -s 2'

#               gtop: https://github.com/aksakalli/gtop
# You can sort the process table by pressing
# p: Process Id
# c: CPU usage
# m: Memory usage
alias top=gtop

#               my_ps:    List processes owned by my user
my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

# ============================================
#   6. NETWORKING
# ============================================

#               myip: Public facing IP Address
alias myip='curl http://ipecho.net/plain; echo'

#               lsock: Display open TCP sockets
alias lsock='sudo /usr/sbin/lsof -nP | grep TCP'

if [[ "$OSTYPE" =~ ^darwin ]]; then
    alias wifi='networksetup -getairportpower en1 | grep "On" && networksetup -setairportpower en1 off || networksetup -setairportpower en1 on '
    alias flushdns='sudo killall -HUP mDNSResponder'
else
    alias flushdns='/etc/init.d/nscd restart'
    #/etc/init.d/named restart
fi
export PATH=$BREWPATH:$PATH
