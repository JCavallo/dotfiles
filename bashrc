export WORKON_HOME=/home/giovanni/Projets/python_envs
source /etc/bash_completion
# source /home/giovanni/.bash_completion.d/python-argcomplete.sh
shopt -s histappend
export HISTSIZE=10000
PROMPT_COMMAND='history -a; history -n'
export VIRTUAL_ENV_DISABLE_PROMPT=1

if [ "$TERM" != "dumb" ]; then
    [ -e "$HOME/.dir_colors" ] &&
    DIR_COLORS="$HOME/.dir_colors" [ -e "$DIR_COLORS" ] ||
    DIR_COLORS=""
    eval "`dircolors -b $DIR_COLORS`"
    alias ls='ls --color=auto'
fi

alias la='ls -Fa'
alias ll='ls -Flsh'
alias cdve='cd $VIRTUAL_ENV'
alias ag="LESS='FSRX' ag --pager less"
# Apply latest patch in ~/tmp/
alias hgpl="ls -d -t ~/tmp/* | grep .*diff | head -n 1;ls -d -t ~/tmp/* | grep .*diff | head -n 1 | xargs cat | hg patch --no-commit -"
# Clean up everything
alias hgdel="hg revert --all;hg purge;hg review --clean"
alias gitdel="git reset --hard;rm `git rev-parse --show-toplevel 2> /dev/null`/.git/review_id 2> /dev/null;git clean -fd"
alias mrg_bas="git merge-base HEAD origin/master"

DEFAULT="[0m"
BLINK="[5m"
BLINKRESET="[25m"

RED="[30;101m"
REDGREEN="[91;102m"
GREEN="[30;102m"
GREENYELLOW="[92;103m"
YELLOW="[30;103m"
YELLOWBLUE="[93;106m"
BLUE="[30;106m"
BLUEBLACK="[96;49m"
DARKGREY="[37;100m"
DARKGREYDARKGREEN="[90;42m"
DARKGREEN="[30;42m"
DARKGREENPINK="[32;45m"
PINK="[30;45m"
PINKLIGHTBLUE="[35;104m"
LIGHTBLUE="[30;104m"
LIGHTBLUEBLACK="[94;49m"

hg_ps1_1() {
    BRANCH=`hg prompt "{branch}" 2> /dev/null`
    if [ "$BRANCH" != "" ]; then
        echo " $BRANCH"
    else
        echo ""
    fi
}
hg_ps1_2() {
    STATUS=`hg prompt "{status}" 2> /dev/null`
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
    BRANCH=`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\*\ \(.+\)$/\\\1\ /`
    if [ "$BRANCH" != "" ]; then
        echo " $BRANCH"
    else
        echo ""
    fi
}
git_ps1_2() {
    status=$(git status -sb 2> /dev/null | tail -n +2 2> /dev/null)
    if [ "${status}" != "" ]; then
        modified=$(echo ${status} | grep "??")
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
        rietveld=$(git config --get branch.${clean_branch}.rietveldissue 2> /dev/null)
        if [ "${rietveld}" != "" ]; then
            echo " linked $rietveld "
            return
        fi
    fi
    REVIEW=$(cat `git rev-parse --show-toplevel 2> /dev/null`/.git/review_id 2> /dev/null)
    if [ "$REVIEW" != "" ]; then
        echo " applied $REVIEW "
    else
        echo ""
    fi
}

virtual_env_ps1() {
    if [ ! -z $VIRTUAL_ENV ]; then
        echo " `basename $VIRTUAL_ENV` "
    else
        echo ""
    fi
}

# Init
PS1='\n'

# Filepath
PS1+='\e${RED} \w '
PS1+='\e${REDGREEN}'

# Branch
PS1+='\e${GREEN}$(hg_ps1_1)$(git_ps1_1)'
PS1+='\e${GREENYELLOW}'

# Rietveld
PS1+='\e${YELLOW}$(hg_ps1_3)$(git_ps1_3)'
PS1+='\e${YELLOWBLUE}'

# Status
PS1+='\e${BLUE}\e${BLINK}$(hg_ps1_2)$(git_ps1_2)\e${BLINKRESET}'
PS1+='\e${BLUEBLACK}'

# New line
PS1+='\e${DEFAULT}\n'

# Time
PS1+='\e${DARKGREY} $(date +%H:%M:%S) '
PS1+='\e${DARKGREYDARKGREEN}'

# Virtual Env
PS1+='\e${DARKGREEN}$(virtual_env_ps1)'
PS1+='\e${DARKGREENPINK}'

# User
PS1+='\e${PINK} \u '
PS1+='\e${PINKLIGHTBLUE}'

# Host
PS1+='\e${LIGHTBLUE} \h '
PS1+='\e${LIGHTBLUEBLACK} \e${DEFAULT}'

export PS1


export EDITOR=nvim
if [ -z "$FBTERM"]; then
    export TERM=xterm-256color
else
    export TERM=fbterm
fi
export PATH=$PATH:/home/giovanni/bin

# Local customized path and environment settings, etc.
if [ -f ~/.bash_local ]; then
    . ~/.bash_local
fi

set -o vi
source ~/.fzf.bash
