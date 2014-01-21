# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
    function command_not_found_handle {
            # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
           /usr/bin/python /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
           /usr/bin/python /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
        else
           printf "%s: command not found\n" "$1" >&2
           return 127
        fi
    }
fi

export EDITOR="vim"
export TERM="rxvt-unicode"

alias nmount="sshfs dvan@ninjabox.biz:/srv/media /media/ninja"
alias ninja='ssh dvan@ninjabox.biz'
alias dvaorg="ssh dvan@danielvanallen.org"
alias cs1="ssh djv091020@cs1.utdallas.edu"

man() {
        env \
                LESS_TERMCAP_mb=$(printf "\e[1;31m") \
                LESS_TERMCAP_md=$(printf "\e[1;31m") \
                LESS_TERMCAP_me=$(printf "\e[0m") \
                LESS_TERMCAP_se=$(printf "\e[0m") \
                LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
                LESS_TERMCAP_ue=$(printf "\e[0m") \
                LESS_TERMCAP_us=$(printf "\e[1;32m") \
                        man "$@"
}

##################################################
# Fancy PWD display function
##################################################
# The home directory (HOME) is replaced with a ~
# The last pwdmaxlen characters of the PWD are displayed
# Leading partial directory names are striped off
# /home/me/stuff          -> ~/stuff               if USER=me
# /usr/share/big_dir_name -> ../share/big_dir_name if pwdmaxlen=20
##################################################
bash_prompt_command() {
    # How many characters of the $PWD should be kept
    local pwdmaxlen=25
    # Indicate that there has been dir truncation
    local trunc_symbol=".."
    local dir=${PWD##*/}
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi
}

bash_prompt() {
#    case $TERM in
#     xterm*|rxvt*)
#         local TITLEBAR='\[\033]0;\u:${NEW_PWD}\007\]'
#          ;;
#     *)
#         local TITLEBAR=""
#          ;;
#    esac
    local NONE="\[\033[0m\]"    # unsets color to term's fg color

    # regular colors
#    local K="\[\033[0;30m\]"    # black
#    local R="\[\033[0;31m\]"    # red
#    local G="\[\033[0;32m\]"    # green
#    local Y="\[\033[0;33m\]"    # yellow
#    local B="\[\033[0;34m\]"    # blue
#    local M="\[\033[0;35m\]"    # magenta
#    local C="\[\033[0;36m\]"    # cyan
#    local W="\[\033[0;37m\]"    # white

    # emphasized (bolded) colors
    local EMK="\[\033[1;30m\]"
    local EMR="\[\033[1;31m\]"
#    local EMG="\[\033[1;32m\]"
#    local EMY="\[\033[1;33m\]"
    local EMB="\[\033[1;34m\]"
#    local EMM="\[\033[1;35m\]"
#    local EMC="\[\033[1;36m\]"
    local EMW="\[\033[1;37m\]"

    # background colors
#    local BGK="\[\033[40m\]"
#    local BGR="\[\033[41m\]"
#    local BGG="\[\033[42m\]"
#    local BGY="\[\033[43m\]"
#    local BGB="\[\033[44m\]"
#    local BGM="\[\033[45m\]"
#    local BGC="\[\033[46m\]"
#    local BGW="\[\033[47m\]"


    local UC=$EMW                 # user's color
    [ $UID -eq "0" ] && UC=$EMR   # root's color

PS1="${EMK}$(date +%H:%M) ${UC}\u${EMR}@${EMW}\h ${EMB}\${NEW_PWD}${EMW}>${NONE}"
}

PROMPT_COMMAND=bash_prompt_command
bash_prompt
unset bash_prompt

