export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
#-------------------------------------------------------------
# Some settings
#-------------------------------------------------------------
alias debug="set -o nounset; set -o xtrace"
set -o notify
set -o noclobber
set -o ignoreeof
#-------------------------------------------------------------
# TMUX
#-------------------------------------------------------------
#alias tmux="/usr2/c_yongxz/tmux"
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr2/c_yongxz/local/lib
# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
#-------------------------------------------------------------
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White
# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White
# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White
NC="\e[m"               # Color Reset
function _exit()              # Function to run upon exit of shell.
{
    echo -e "leaving shell"
}
trap _exit EXIT
#    so it's available to all shells (using 'history -a').
# Returns a color according to free disk space in $PWD.s
function disk_color()
{
    if [ ! -w "${PWD}" ] ; then
        echo -en ${Red}
        # No 'write' privilege in the current directory.
    elif [ -s "${PWD}" ] ; then
        local used=$(command df -P "$PWD" |
                   awk 'END {print $5} {sub(/%/,"")}')
        if [ ${used} -gt 95 ]; then
            echo -en ${ALERT}           # Disk almost full (>95%).
        elif [ ${used} -gt 90 ]; then
            echo -en ${BRed}            # Free disk space almost gone.
        else
            echo -en ${Green}           # Free disk space is ok.
        fi
    else
        echo -en ${Cyan}
        # Current directory is size '0' (like /proc, /sys etc).
    fi
}
# Returns a color according to running/suspended jobs.
# Adds some text in the terminal frame (if applicable).

# Now we construct the prompt.
PROMPT_COMMAND="history -a"
PS1="\[${BYellow}\][\A|\[${BCyan}\]\h]|\[${BWhite}\]\[${NC}\]"
#dir color
LS_COLORS=$LS_COLORS:'di=0;33:';export LS_COLORS
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTIGNORE="&:bg:fg:ll:h"
export HISTTIMEFORMAT="$(echo -e ${BCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "
export HISTCONTROL=ignoredups
export HOSTFILE=$HOME/.hosts    # Put a list of remote hosts in ~/.hosts
#============================================================
#  ALIASES AND FUNCTIONS
#============================================================
alias grep='grep --colo=auto'
alias notes='vim /usr2/c_yongxz/.notes'
alias cnotes='cat /usr2/c_yongxz/.notes'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ../'
alias ...='cd ../../'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../../'
alias ......='cd ../../../../../../'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias du='du -kh'    # Makes a more readable output.
alias df='df -kTh'
#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls).
#-------------------------------------------------------------
#alias ls='ls -h --color'
alias ls='ls -h '
alias c='clear'
alias rcsdiffy="rcsdiff -u 5"
#-------------------------------------------------------------
# File & strings related functions:
#-------------------------------------------------------------
function ff() { find . -type f -iname '*'"$*"'*' -ls ; }
# Find a file with pattern $1 in name and Execute $2 on it:
function fe() { find . -type f -iname '*'"${1:-}"'*' \
-exec ${2:-file} {} \;  ; }
#  Find a pattern in a set of files and highlight them:
#+ (needs a recent version of egrep).
function extract()      # Handy Extract Program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}
# Creates an archive (*.tar.gz) from given directory.
function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
# Create a ZIP archive of a file or folder.
function makezip() { zip -r "${1%%/}.zip" "$1" ; }
# Make your directories and files access rights sane.
function sanitize() { chmod -R u=rwX,g=rX,o= "$@" ;}
#-------------------------------------------------------------
# Process/system related functions:
#-------------------------------------------------------------
function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }
function killps()   # kill by process name
{
    local pid pname sig="-TERM"   # default signal
    if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
        echo "Usage: killps [-SIGNAL] pattern"
        return;
    fi
    if [ $# = 2 ]; then sig=$1 ; fi
    for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} )
    do
        pname=$(my_ps | awk '$1~var { print $5 }' var=$pid )
        if ask "Kill process $pid <$pname> with signal $sig?"
            then kill $sig $pid
        fi
    done
}
function mydf()         # Pretty-print of 'df' output.
{                       # Inspired by 'dfc' utility.
    for fs ; do

        if [ ! -d $fs ]
        then
          echo -e $fs" :No such file or directory" ; continue
        fi
        local info=( $(command df -P $fs | awk 'END{ print $2,$3,$5 }') )
        local free=( $(command df -Pkh $fs | awk 'END{ print $4 }') )
        local nbstars=$(( 20 * ${info[1]} / ${info[0]} ))
        local out="["
        for ((j=0;j<20;j++)); do
            if [ ${j} -lt ${nbstars} ]; then
               out=$out"*"
            else
               out=$out"-"
            fi
        done
        out=${info[2]}" "$out"] ("$free" free on "$fs")"
        echo -e $out
    done
}
function my_ip() # Get IP adress on ethernet.
{
    MY_IP=$(/sbin/ifconfig eth0 | awk '/inet/ { print $2 } ' |
      sed -e s/addr://)
    echo ${MY_IP:-"Not connected"}
}
function ii()   # Get current host related info.
{
    echo -e "\nYou are logged on ${BRed}$HOST"
    echo -e "\n${BRed}Additionnal information:$NC " ; uname -a
    echo -e "\n${BRed}Users logged on:$NC " ; w -hs |
             cut -d " " -f1 | sort | uniq
    echo -e "\n${BRed}Current date :$NC " ; date
    echo -e "\n${BRed}Machine stats :$NC " ; uptime
    echo -e "\n${BRed}Memory stats :$NC " ; free
    echo -e "\n${BRed}Diskspace :$NC " ; mydf / $HOME
    echo -e "\n${BRed}Local IP Address :$NC" ; my_ip
    echo -e "\n${BRed}Open connections :$NC "; netstat -pan --inet;
    echo
}
#-------------------------------------------------------------
# Misc utilities:
#-------------------------------------------------------------
function repeat()       # Repeat n times command.
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}
function ask()          # See 'killps' for example of use.
{
    echo -n "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}
function corename()   # Get name of app that created a corefile.
{
    for file ; do
        echo -n $file : ; gdb --core=$file --batch | head -1
    done
}
shopt -s extglob        # Necessary.
complete -A hostname   rsh rcp telnet rlogin ftp ping disk
complete -A export     printenv
complete -A variable   export local readonly unset
complete -A enabled    builtin
complete -A alias      alias unalias
complete -A function   function
complete -A user       su mail finger
complete -A helptopic  help     # Currently same as builtins.
complete -A shopt      shopt
complete -A stopped -P '%' bg
complete -A job -P '%'     fg jobs disown
complete -A directory  mkdir rmdir
complete -A directory   -o default cd
# Compression
complete -f -o default -X '*.+(zip|ZIP)'  zip
complete -f -o default -X '!*.+(zip|ZIP)' unzip
complete -f -o default -X '*.+(z|Z)'      compress
complete -f -o default -X '!*.+(z|Z)'     uncompress
complete -f -o default -X '*.+(gz|GZ)'    gzip
complete -f -o default -X '!*.+(gz|GZ)'   gunzip
complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2
complete -f -o default -X '!*.+(zip|ZIP|z|Z|gz|GZ|bz2|BZ2)' extract
#-------------------
#LSF 
#-------------------
: ' 
alias wlsload='watch "lsload | grep unavail |wc -l "'
alias rw='cd `pwd | sed "s/^\/\.*/\/\./"`' 
alias ro='cd `pwd | sed "s/^\/\./\//"`' 
function releaseV {
fs lq | grep -v "Volume" | awk '{print $1}' | xargs release
    }
    function ckout()  {
    for file ; do
	local cmd="co -l"
	echo "command is:" $cmd $file; echo""; ll $file; $cmd $file; ll $file
    done
}
function ckin()   {
for file ; do
    local cmd="ci -u"
    echo "command is:" $cmd $file; echo "" ; ll $file; $cmd $file; ll $file 
done
}
lsf_top="lsf"
#function low2up() {echo $1| tr '[:lower:]' '[:upper:]'}
function lsid2master(){echo $(lsid | grep master | awk '{print $5}');}
function g2c (){}
function g2b () {}
function g2work () {cd `grep  WORK $LSF_ENVDIR/lsf.conf  | awk -F "=" '{print $2}'`}
function g2log () {cd /var/log/lsf/}
function src (){ profile=$(low2up $1)/conf/profile.lsf}
function l2b () {$* | awk '{print $1}' | grep -v "HOST_NAME" | xargs bhosts}
function b2lsload () {$* | awk '{print $1}' | grep -v "HOST_NAME" | xargs lsload -w}
function b2lshosts () {$* | awk '{print $1}' | grep -v "HOST_NAME" | xargs lshosts}
function b2lshosts () {$* | awk '{print $1}' | grep -v "HOST_NAME" | xargs lshosts}
function g2m () {	ssh $(lsid | grep master | awk '{print $5}') ; }
function lsid2cluster() { if [ ! -z "$LSF_ENVDIR" ]; then echo $(lsid | grep cluster | awk '{print $5}'); fi }
p2h () { cmd="/usr2/c_yongxz/.bashrc* c_yongxz@$1:/usr2/c_yongxz"; scp $cmd; }
v2h () { cmd="/usr2/c_yongxz/.vimrc c_yongxz@$1:/usr2/c_yongxz"; scp $cmd; }
syncp () { cmd="c_yongxz@:/usr2/c_yongxz/.bashrc* /usr2/c_yongxz"; scp $cmd; }
alias lslaod="lsload"
alias rtmhb="mysql cacti -u root -e \"select * from grid_processes where taskname='LSFPOLLERD'\""
alias blstat="/bin/blstat"
alias getschdmodversion="for i in 'ls schmod*.so'; do strings -f $i | grep Platform ; done"
'
#-------------------------------------------------------------
#END OF LSF 2016
#-------------------------------------------------------------

#-------------------------------------------------------------
# Vim setting 
#-------------------------------------------------------------
#vim backspace sends ^?
stty erase '^?'
#END:
