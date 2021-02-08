if hash keychain 2>/dev/null; then
    eval "$(keychain --eval --agents ssh id_rsa)"
    clear
fi

export WORKON_HOME=$HOME/Projets/python_envs
if [ -f "$HOME/.local/bin/virtualenvwrapper.sh" ]; then
    source "$HOME/.local/bin/virtualenvwrapper.sh"
fi
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
elif [ -f /etc/bash.bashrc ]; then
    source /etc/bash.bashrc
fi
# source $HOME/.bash_completion.d/python-argcomplete.sh
shopt -s histappend
# Enable "**" matching for recursive directory use
shopt -s globstar
export HISTSIZE=10000
PROMPT_COMMAND='history -a; history -n'
export VIRTUAL_ENV_DISABLE_PROMPT=1

export LANG=en_US.UTF-8

function paged_ripgrep() {
    rg -p "$@" | less -RFX
}

alias la='exa -Fa'
alias ll='exa -Flh -s name'
alias ls=exa
alias cdve='cd $VIRTUAL_ENV'
alias cdpr='cd $PROJECT_PATH'
alias ag="LESS='FSRX' ag --pager less"
alias rg='paged_ripgrep'
# Apply latest patch in ~/tmp/
alias hgpl="ls -d -t ~/tmp/* | grep .*diff | head -n 1;ls -d -t ~/tmp/* | grep .*diff | head -n 1 | xargs cat | hg patch --no-commit -"
# Clean up everything
alias hgdel="hg revert --all;hg purge;hg review --clean"
alias mrg_bas="git merge-base HEAD origin/master"
alias gitcm="git checkout master"
alias htop="TERM=screen htop"
alias pg_activity="TERM=screen pg_activity"
alias grp="grep -I --line-buffered"
alias cat=bat
alias more=bat
alias k="kritik -s --success-message OK --failure-message KO"

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
REDBLACK="[38;5;196m"
GREENBLACK="[38;5;82m"
BLACKGREEN="[30;42m"
BLACKPINK="[30;45m"
BLACKLIGHTBLUE="[30;104m"

if [[ "$(command -v hg)" ]]; then
    HG_INSTALLED=1
else
    HG_INSTALLED=0
fi

_echo_good() {
    retval=$?
    if [ "$retval" = "0" ]; then
        echo "😄"
    fi
    return $retval
}

_echo_bad() {
    retval=$?
    if [ "$retval" != "0" ]; then
        echo "😭"
    fi
    return $retval
}

host_ps1() {
    if [[ "${SSH_CONNECTION:-nope}" = "nope" ]]; then
        echo ""
    else
        echo " $HOSTNAME "
    fi
}

hg_ps1_1() {
    [[ "$HG_INSTALLED" = "0" ]] && return
    BRANCH=$(hg prompt "{branch}" 2> /dev/null)
    if [ "$BRANCH" != "" ]; then
        echo " $BRANCH"
    else
        echo ""
    fi
}
hg_ps1_2() {
    [[ "$HG_INSTALLED" = "0" ]] && return
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
    if [[ "${CUSTOM_ENV_NAME:-notset}" != "notset" ]]; then
        echo " $CUSTOM_ENV_NAME "
    elif [[ ! -z "$VIRTUAL_ENV" ]]; then
        echo " $(basename "$VIRTUAL_ENV") "
    else
        echo ""
    fi
}

_get_project_path() {
    if [[ "$PROJECT_PATH" != "" ]]; then
        echo "$PROJECT_PATH"
    elif [[ "$VIRTUAL_ENV" != "" ]]; then
        echo "$VIRTUAL_ENV"
    fi
}

current_path_ps1() {
    local path
    path=$(_get_project_path)
    if [ ! "$path" = "" ] && [ -d "$path" ]; then
        value=$(echo "${PWD#"$path"}")
    else
        value="$(pwd)"
    fi
    if [ "$value" != "" ]; then
        value="${value/#$HOME/\~}"
        value=$(echo "$value" | sed 's:\([^/][^/]\?\)[^/]*/:\1/:g')
        echo " $value "
    else
        echo ""
    fi
}

tryton_db_ps1() {
    local path
    path=$(_get_project_path)
    if [ ! "$path" = "" ] && [ -f "$path"/conf/trytond.conf ]; then
        if [ "$DB_NAME" = "" ]; then
            DB_NAME=$(grep "^uri = postgres" "$path"/conf/trytond.conf | sed -e "s/.*@[^:]\+:[0-9]\+\/\?//")
        fi
        PORT=$(grep "^listen = " "$path"/conf/trytond.conf | sed -e "s/.*://")
        if [ ! "$PORT" = "" ]; then
            PORT=:"$PORT"
        fi
        if [ ! "$DB_NAME" = "" ] && [ ! "$DB_NAME" == "uri = *" ]; then
            echo " $DB_NAME$PORT "
        fi
    fi
}

check_new_line() {
    # If there is a branch name, the PS1 name might get too big, so we switch
    # to a new line
    if [[ "$(git_ps1_1)" != "" ]]; then
        printf "\r\n "
    else
        printf " "
    fi
}

# Init
PS1='\n '

# Bad guy
PS1+='\[\e${REDBLACK}\]$(_echo_bad)\[\e${DEFAULT}\]'

# Good guy
PS1+='\[\e${GREENBLACK}\]$(_echo_good)\[\e${DEFAULT}\]'

# # User
# PS1+='\[\e${PINK}\] \u '
# PS1+='\[\e${PINKLIGHTBLUE}\]'

# Transition
PS1+=' \[\e${BLACKLIGHTBLUE}\]'

# Host
PS1+='\[\e${LIGHTBLUE}\]$(host_ps1)'
PS1+='\[\e${LIGHTBLUEDARKGREEN}\]'

# Transition
# PS1+=' \[\e${BLACKGREEN}\]'

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

# # Time
# PS1+='\[\e${DARKGREY}\] $(date +%H:%M:%S) '
# PS1+='\[\e${DARKGREYBLACK}\]'

# End
PS1+='\[\e${DEFAULT}\]$(check_new_line)'

export PS1
export EDITOR=nvim

if [[ "$(command -v ruby)" ]] && [[ "$(command -v gem)" ]]; then
    PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
fi

export PATH="$PATH:$HOME/bin:$HOME/.local/bin"

_git_store ()
{
  __gitcomp_nl "$(__git_heads)"
}

set -o vi
source ~/.fzf.bash

if [[ "$(command -v direnv)" ]]; then
    eval "$(direnv hook bash)"
fi

if [ -e "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

if [[ "$(command -v npm)" ]]; then
    mkdir -p "$HOME/.npm-modules"
    mkdir -p "$HOME/.npm-modules/bin"
    alias npm='PREFIX=$HOME/.npm-modules/ npm'
    export PATH="$HOME/.npm-modules/bin:$PATH"
fi

if [[ "$(command -v yarn)" ]]; then
    yarn_path=$(yarn global bin)
    export PATH="$yarn_path:$PATH"
fi

if [[ "$(command -v go)" ]]; then
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
fi

if [ -e "$HOME/n" ]; then
    export N_PREFIX="$HOME/n"
    [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
fi

if [ -e "$HOME/.pyenv/bin" ]; then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

if [[ -e "$HOME/tools/git-fuzzy" ]]; then
    export PATH="$HOME/tools/git-fuzzy/bin:$PATH"
fi

if [[ -e "/home/linuxbrew/.linuxbrew" ]]; then
    export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
    export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar";
    export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew";
    export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}";
    export MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:";
    export INFOPATH="/home/linuxbrew/.linuxbrew/share/info${INFOPATH+:$INFOPATH}";
fi

# Local customized path and environment settings, etc.
if [ -f ~/.bash_local ]; then
    source ~/.bash_local
fi
if [ -f ~/.bash_final ]; then
    source ~/.bash_final
fi

# vim:set ft=sh:
