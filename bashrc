#!/usr/bin/bash
if hash keychain 2>/dev/null; then
    eval "$(keychain --systemd --eval --agents ssh id_rsa)"
    TERM=linux clear
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
# Avoid escaping on completion
shopt -s direxpand

export HISTSIZE=10000
PROMPT_COMMAND='history -a; history -n; history -r'
export VIRTUAL_ENV_DISABLE_PROMPT=1
export WLR_NO_HARDWARE_CURSORS=1

function paged_ripgrep() {
    rg -p "$@" | less -RFX
}

alias la='exa -Fa'
alias ll='exa -Flh -s name'
alias lla='exa -Falh -s name'
alias ls=exa
alias cdve='cd $VIRTUAL_ENV'
alias cdpr='cd $PROJECT_PATH'
alias ag="LESS='FSRX' ag --pager less"
alias rg='paged_ripgrep'
alias htop="TERM=screen htop"
alias pg_activity="TERM=screen pg_activity"
alias cat='bat $(if [[ ! -e /tmp/.current_theme ]] || [[ $(/usr/bin/cat /tmp/.current_theme) = "light" ]]; then echo "--theme base16"; fi)'
alias more='bat $(if [[ ! -e /tmp/.current_theme ]] || [[ $(/usr/bin/cat /tmp/.current_theme) = "light" ]]; then echo "--theme base16"; fi)'
alias clear="TERM=linux clear"
alias k="kritik -s --success-message OK --failure-message KO"
alias g=git
alias ff8="git commit -a -m ':lipstick:' && git push"
alias vim="nvim"
alias v="nvim"
alias t="tmux-sessionizer"

if [ -f "/usr/share/bash-completion/completions/git" ]; then
  source /usr/share/bash-completion/completions/git
  __git_complete g __git_main
fi

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

if [[ -e /usr/bin/sed ]]; then
    sed=/usr/bin/sed
elif [[ -e /bin/sed ]]; then
    sed=/bin/sed
else
    sed=sed
fi

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

_get_current_task() {
    if [[ -e "$PROJECT_PATH/.cur_jira_sub_task" ]]; then
        echo $(cat "$PROJECT_PATH/.cur_jira_sub_task")
    fi
    echo ""
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
    BRANCH=$(git branch 2> /dev/null | grep -e ^* | $sed -E  s/^\\\*\ \(.+\)$/\\\1/)
    if [[ "$BRANCH" != "" ]] && [[ "$BRANCH" != "${GIT_MAIN_BRANCH:-none}" ]]; then
        echo " $BRANCH "
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
    cur_branch=$(git branch 2> /dev/null | grep -e ^* | $sed -E  s/^\\\*\ \(.+\)$/\\\1\ /)
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
    local result
    if [[ "${CUSTOM_ENV_NAME:-notset}" != "notset" ]]; then
        result=" $CUSTOM_ENV_NAME "
    elif [[ ! -z "$VIRTUAL_ENV" ]]; then
        result=" $(basename "$VIRTUAL_ENV") "
    else
        result=""
    fi
    echo "$result"
}

_get_project_path() {
    local result=""
    if [[ "$PROJECT_PATH" != "" ]]; then
        result="$PROJECT_PATH"
    elif [[ "$VIRTUAL_ENV" != "" ]]; then
        result="$VIRTUAL_ENV"
    fi
    echo "$result"
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
        value=$(echo "$value" | $sed 's:\([^/][^/]\?\)[^/]*/:\1/:g')
        echo " $value "
    else
        echo ""
    fi
}

current_task_ps1() {
    local jira=$(_get_current_task)
    if [[ "$jira" = "" ]]; then
        echo ""
    else
        local branch=$(git_ps1_1)
        if [[ "$branch" =~ $jira ]]; then
            echo ""
        else
            echo " [$jira] "
        fi
    fi
}

tryton_db_ps1() {
    local path
    path=$(_get_project_path)
    if [ ! "$path" = "" ] && [ -f "$path"/conf/trytond.conf ]; then
        if [ "$DB_NAME" = "" ]; then
            DB_NAME=$(grep "^uri = postgres" "$path"/conf/trytond.conf | $sed -e "s/.*@[^:]\+:[0-9]\+\/\?//")
            if [[ "$DB_NAME" = $(basename $(_get_project_path)) ]]; then
                DB_NAME=""
            fi
        fi
        PORT=$(grep "^listen = " "$path"/conf/trytond.conf | $sed -e "s/.*://")
        if [[ "$PORT" = "8000" ]]; then
            PORT=""
        elif [[ ! "$PORT" = "" ]]; then
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

# Database
PS1+='\[\e${YELLOW}\]$(tryton_db_ps1)$(current_task_ps1)'
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
export VISUAL=nvim

if [[ "$(command -v ruby)" ]] && [[ "$(command -v gem)" ]]; then
    PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
fi

export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/dotfiles/tools"

_git_store ()
{
  __gitcomp_nl "$(__git_heads)"
}

set -o vi
export FZF_COMPLETION_TRIGGER='**'
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

if [[ "$(command -v n)" ]]; then
    n_path="$HOME/n/bin"
    export PATH="$n_path:$PATH"
fi

if [[ -e "/usr/local/go" ]]; then
    export PATH=$PATH:/usr/local/go/bin
fi

if [[ "$(command -v go)" ]]; then
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
fi

if [ -e "$HOME/n" ]; then
    export N_PREFIX="$HOME/n"
    [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
fi

if [[ -e "$HOME/.nimble" ]]; then
    export PATH=/home/jean.cavallo/.nimble/bin:$PATH
fi

if [ -e "$HOME/.pyenv/bin" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"
fi

if [[ -e "$HOME/tools/git-fuzzy" ]]; then
    export PATH="$HOME/tools/git-fuzzy/bin:$PATH"
fi

if [[ -e "/home/linuxbrew/.linuxbrew" ]]; then
    # export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
    # export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar";
    # export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew";
    # export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}";
    # export MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:";
    # export INFOPATH="/home/linuxbrew/.linuxbrew/share/info${INFOPATH+:$INFOPATH}";
    true
fi

# Local customized path and environment settings, etc.
if [ -f ~/.bash_local ]; then
    source ~/.bash_local
fi
if [ -f ~/.bash_final ]; then
    source ~/.bash_final
fi

# Scaleway CLI autocomplete initialization.
if [[ "$(command -v scw)" ]]; then
    eval "$(scw autocomplete script shell=bash)"
fi

# Kubeconfig
if [[ "$(command -v kubectl)" ]]; then
    source <(kubectl completion bash)
fi

# Haskell
if [[ -f "$HOME/.ghcup/env" ]]; then
    source "$HOME/.ghcup/env"
fi

if [[ "$(command -v fasd)" ]]; then
    fasd_cache="$HOME/.fasd-init-bash"
    if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
        fasd --init bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
    fi
    source "$fasd_cache"
    unset fasd_cache

    function z() {
        dir=$(fasd -Rdl "$*" | fzf)
        if [[ "$dir" != "" ]]; then
            cd "$dir"
        fi
    }

    function l() {
        ls $(fasd -Rdl "$*" | fzf)
    }

    function f() {
        file=$(fasd -Rfl "$*" | fzf)
        if [[ "$file" != "" ]]; then
            nvim "$file"
        fi
    }
fi

# WSL workaround for slow completion: Remove System32 from PATH
if [[ -e "/mnt/c/Windows" ]] && [[ ! -e "$HOME/bin/clip.exe" ]]; then
    ln -s /mnt/c/Windows/System32/clip.exe "$HOME/bin/clip.exe"
fi
export PATH=$(echo $PATH | tr ':' '\n' | grep -v "/mnt/c/" | tr '\n' ':')

export GPG_TTY=$(tty)

# vim:set ft=sh:
