#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# save path on cd
function cd {
    builtin cd $@
    pwd > /tmp/last_dir
}

# restore last saved path
if [ -f /tmp/last_dir ]
    then cd `cat /tmp/last_dir`
fi

alias ls='ls --color=auto'
PS1="  \[\e[00;32m\]λ \W \[\e[0m\]"

export PATH=/usr/local/bin:$PATH:/home/user/.dotnet/tools:/usr/local/racket/bin

# needed for sudoedit
export EDITOR=vim

export XKB_DEFAULT_LAYOUT=us
