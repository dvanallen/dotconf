#
# ~/.bash_profile
#
[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ "$(uname -s)" = Darwin ]; then
	export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:/usr/local/opt/coreutils/libexec/gnubin:$PATH"
	export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
else
        eval `ssh-agent`
        ssh-add
fi

export EDITOR=vim
export WINEARCH=win32
export PATH=$PATH:~/bin

