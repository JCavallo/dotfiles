export WORKON_HOME=/home/giovanni/Projets/python_envs
source /etc/bash_completion
# source /home/giovanni/.bash_completion.d/python-argcomplete.sh
shopt -s histappend
export HISTSIZE=10000
PROMPT_COMMAND='history -a; history -n'

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
alias gitdel="git reset --hard;rm `git rev-parse --show-toplevel 2> /dev/null`/.git/review_id 2> /dev/null"

DEFAULT="[37;1m"
PINK="[35;1m"
GREEN="[32;1m"
ORANGE="[33;1m"
BLUE="[36;1m"
RED="[31;1m"
BOLD="[1m"
OFF="[m"

hg_ps1_1() {
    hg prompt "{branch}" 2> /dev/null
}
hg_ps1_2() {
    hg prompt "{status}" 2> /dev/null
}
hg_ps1_3() {
    REVIEW=$(hg review --id 2> /dev/null)
    if [ "$REVIEW" != "" ]; then
        echo "[$REVIEW] "
    else
        echo ""
    fi
}
git_ps1_1() {
    git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\*\ \(.+\)$/\\\1\ /
}
git_ps1_2() {
    status=$(git status -sb 2> /dev/null | tail -n +2 2> /dev/null)
    if [ "${status}" != "" ]; then
        modified=$(echo ${status} | grep "??")
        if [ "${modified}" != "" ]; then
            echo "?"
        else
            echo "!"
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
            echo "[linked $rietveld] "
            return
        fi
    fi
    REVIEW=$(cat `git rev-parse --show-toplevel 2> /dev/null`/.git/review_id 2> /dev/null)
    if [ "$REVIEW" != "" ]; then
        echo "[applied $REVIEW] "
    else
        echo ""
    fi
}


export PS1='\[\e${BOLD}\e${RED}\]\w \[\e${GREEN}\]$(hg_ps1_1)$(git_ps1_1)\[\e${ORANGE}\]$(hg_ps1_3)$(git_ps1_3)\[\e${BLUE}\]$(hg_ps1_2)$(git_ps1_2)\[\e${DEFAULT}\e${OFF}\]\n\[\e${BOLD}\e${PINK}\]\u\[\e${DEFAULT}\e${OFF}\]@\[\e${BOLD}\e${ORANGE}\]\h\[\e${DEFAULT}\e${OFF}\] \[\e${BOLD}\e${RED}\]$ \[\e${DEFAULT}\e${OFF}\] '


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
