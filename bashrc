if hash keychain 2>/dev/null; then
    eval "$(keychain --eval --agents ssh id_rsa)"
    clear
fi

export WORKON_HOME=/home/giovanni/Projets/python_envs
if [ -f /home/giovanni/.local/bin/virtualenvwrapper.sh ]; then
    source /home/giovanni/.local/bin/virtualenvwrapper.sh
fi
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
elif [ -f /etc/bash.bashrc ]; then
    source /etc/bash.bashrc
fi
# source /home/giovanni/.bash_completion.d/python-argcomplete.sh
shopt -s histappend
# Enable "**" matching for recursive directory use
shopt -s globstar
export HISTSIZE=10000
PROMPT_COMMAND='history -a; history -n'
export VIRTUAL_ENV_DISABLE_PROMPT=1

export LANG=en_US.UTF-8

if [ "$TERM" != "dumb" ]; then
    [ -e "$HOME/.dir_colors" ] &&
    DIR_COLORS="$HOME/.dir_colors" [ -e "$DIR_COLORS" ] ||
    DIR_COLORS=""
    eval "$(dircolors -b $DIR_COLORS)"
    alias ls='ls --color=auto'
fi

alias la='ls -Fa'
alias ll='ls -Flsh'
alias cdve='cd $VIRTUAL_ENV'
alias cdpr='cd $PROJECT_PATH'
alias ag="LESS='FSRX' ag --pager less"
# Apply latest patch in ~/tmp/
alias hgpl="ls -d -t ~/tmp/* | grep .*diff | head -n 1;ls -d -t ~/tmp/* | grep .*diff | head -n 1 | xargs cat | hg patch --no-commit -"
# Clean up everything
alias hgdel="hg revert --all;hg purge;hg review --clean"
alias mrg_bas="git merge-base HEAD origin/master"
alias gitcm="git checkout master"
alias htop="TERM=screen htop"
alias pg_activity="TERM=screen pg_activity"
alias grp="grep -I --line-buffered"

viewdiff() {
    git diff "$*" > /tmp/viewdiff.diff;nvim /tmp/viewdiff.diff
}

source ~/.colors

DEFAULT="[0m"
BLINK="[5m"
BLINKRESET="[25m"

WHITE="[97;49m"
PINK="[30;45m"
PINKLIGHTBLUE="[35;104m"
LIGHTBLUE="[30;104m"
LIGHTBLUEDARKGREEN="[94;42m"
DARKGREEN="[30;42m"
DARKGREENRED="[32;101m"
RED="[30;101m"
REDGREEN="[91;102m"
GREEN="[30;102m"
GREENYELLOW="[92;103m"
YELLOW="[30;103m"
YELLOWBLUE="[93;106m"
BLUE="[30;106m"
BLUEBLACK="[96;49m"
DARKGREY="[37;100m"
DARKGREYBLACK="[90;49m"

ps_k() {
    pgrep "$1" | xargs kill -9
}
ps_chk() {
    ps ax | grep "$1"
}
hg_ps1_1() {
    BRANCH=$(hg prompt "{branch}" 2> /dev/null)
    if [ "$BRANCH" != "" ]; then
        echo " $BRANCH"
    else
        echo ""
    fi
}
hg_ps1_2() {
    STATUS=$(hg prompt "{status}" 2> /dev/null)
    if [ "$STATUS" != "" ]; then
        echo " $STATUS"
    else
        echo ""
    fi
}
hg_ps1_3() {
    REVIEW=$(hg review --id 2> /dev/null)
    if [ "$REVIEW" != "" ]; then
        echo " $REVIEW "
    else
        echo ""
    fi
}
git_ps1_1() {
    BRANCH=$(git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\*\ \(.+\)$/\\\1\ /)
    if [ "$BRANCH" != "" ]; then
        echo " $BRANCH"
    else
        echo ""
    fi
}
git_ps1_2() {
    status=$(git status -sb 2> /dev/null | tail -n +2 2> /dev/null)
    if [ "${status}" != "" ]; then
        modified=$(echo "${status}" | grep "??")
        if [ "${modified}" != "" ]; then
            echo " ? "
        else
            echo " ! "
        fi
    else
        echo ""
    fi
}
git_ps1_3() {
    cur_branch=$(git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\*\ \(.+\)$/\\\1\ /)
    if [ "$cur_branch" != "" ]; then
        clean_branch=${cur_branch::-1}
        rietveld=$(git config --get branch."${clean_branch}".rietveldissue 2> /dev/null)
        if [ "${rietveld}" != "" ]; then
            echo " $rietveld "
            return
        fi
    fi
}

virtual_env_ps1() {
    if [ ! -z "$VIRTUAL_ENV" ]; then
        echo " $(basename "$VIRTUAL_ENV") "
    else
        echo ""
    fi
}

_get_project_path() {
    local PROJECT_PATH
    PROJECT_PATH=$(cat "$VIRTUAL_ENV"/.project 2> /dev/null)
    if [ "$PROJECT_PATH" = "" ] || [ ! -d "$PROJECT_PATH" ]; then
        if [ -z "$VIRTUAL_ENV" ]; then
            PROJECT_PATH=
        else
            PROJECT_PATH=$VIRTUAL_ENV
        fi
    fi
    echo $PROJECT_PATH
}

current_path_ps1() {
    local PROJECT_PATH
    PROJECT_PATH=$(_get_project_path)
    if [ ! "$PROJECT_PATH" = "" ] && [ -d "$PROJECT_PATH" ]; then
        value=$(echo "${PWD#"$PROJECT_PATH"}")
    else
        value="$(pwd)"
    fi
    if [ "$value" != "" ]; then
        value=${value/#$HOME/\~}
        value=$(echo "$value" | sed 's:\([^/][^/]\?\)[^/]*/:\1/:g')
        echo " $value "
    else
        echo ""
    fi
}

tryton_db_ps1() {
    local PROJECT_PATH
    PROJECT_PATH=$(_get_project_path)
    if [ ! "$PROJECT_PATH" = "" ] && [ -f "$PROJECT_PATH"/conf/trytond.conf ]; then
        if [ "$DB_NAME" = "" ]; then
            DB_NAME=$(grep "^uri = postgres" "$PROJECT_PATH"/conf/trytond.conf | sed -e "s/.*@[^:]\+:[0-9]\+\/\?//")
        fi
        PORT=$(grep "^listen = " "$PROJECT_PATH"/conf/trytond.conf | sed -e "s/.*://")
        if [ ! "$PORT" = "" ]; then
            PORT=:"$PORT"
        fi
        if [ ! "$DB_NAME" = "" ] && [ ! "$DB_NAME" == "uri = *" ]; then
            echo " $DB_NAME$PORT "
        fi
    fi
}

# Init
PS1='\n\[\033[G\]\[\e[1m\]\[\e${WHITE}\]  ┌─\[\e${DEFAULT}\]'

# User
PS1+='\[\e${PINK}\] \u '
PS1+='\[\e${PINKLIGHTBLUE}\]'

# Host
PS1+='\[\e${LIGHTBLUE}\] \h '
PS1+='\[\e${LIGHTBLUEDARKGREEN}\]'

# Virtual Env
PS1+='\[\e${DARKGREEN}\]$(virtual_env_ps1)'
PS1+='\[\e${DARKGREENRED}\]'

# Filepath
PS1+='\[\e${RED}\]$(current_path_ps1)'
PS1+='\[\e${REDGREEN}\]'

# Branch
PS1+='\[\e${GREEN}\]$(hg_ps1_1)$(git_ps1_1)'
PS1+='\[\e${GREENYELLOW}\]'

# Rietveld
PS1+='\[\e${YELLOW}\]$(tryton_db_ps1)'
PS1+='\[\e${YELLOW}\]'
PS1+='\[\e${YELLOWBLUE}\]'

# Status
PS1+='\[\e${BLUE}\]\[\e${BLINK}\]$(hg_ps1_2)$(git_ps1_2)\[\e${BLINKRESET}\]'
PS1+='\[\e${BLUEBLACK}\]'

# New line
PS1+='\[\e${DEFAULT}\]\n\[\e${WHITE}\]\[\e[1m\]\[\e${WHITE}\]└─\[\e${DEFAULT}\]'

# Time
PS1+='\[\e${DARKGREY}\] $(date +%H:%M:%S) '
PS1+='\[\e${DARKGREYBLACK}\]'

# End
PS1+='\[\e${DEFAULT}\]  '

export PS1

export EDITOR=nvim
if [ -z "$FBTERM" ]; then
    export TERM=xterm-256color
else
    export TERM=fbterm
fi

if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
fi

export PATH=$PATH:/home/giovanni/bin:/home/giovanni/.local/bin

# Local customized path and environment settings, etc.
if [ -f ~/.bash_local ]; then
    . ~/.bash_local
fi
if [ -f ~/.bash_final ]; then
    . ~/.bash_final
fi

_git_store ()
{
  __gitcomp_nl "$(__git_heads)"
}

set -o vi
source ~/.fzf.bash

if [ -e "/home/giovanni/.nvm" ]; then
    export NVM_DIR="/home/giovanni/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
fi

if [ -s "$(which direnv)" ]; then
    eval "$(direnv hook bash)"
fi

if [ -s "$(which pyenv)" ]; then
    export PATH="/home/giovanni/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# vim:set ft=sh:
