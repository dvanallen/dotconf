source ~/.antigen/antigen.zsh clone/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

autoload -Uz colors && colors
autoload -Uz compinit && compinit

antigen-bundles <<EOBUNDLES

git
command-not-found
screen
rsync
extract
zsh-users/zsh-completions src
zsh-users/zsh-syntax-highlighting

EOBUNDLES

# Load the theme.
antigen-theme dvanallen/zsh_themes themes/low_key

# Tell antigen that you're done.
antigen apply

alias ls="ls -AlhF --color=auto"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"

HISTSIZE=1000000
SAVEHIST=1000000

setopt autocd autopushd pushdignoredups pushdtohome appendhistory

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

function say { mplayer -really-quiet "http://translate.google.com/translate_tts?tl=en&q=$1" &> /dev/null; }

if [ -n "$SSH_CLIENT" ]; then
    if which tmux 2>&1 >/dev/null; then
        test -z "$TMUX" && (tmux attach || tmux new-session)
    fi
fi
