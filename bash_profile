[[ -f ~/.bashrc ]] && . ~/.bashrc
if which tmux 2>&1 >/dev/null; then
    #if not inside a tmux session, and if no session is started, start fbterm and a new tmux session
    test -z "$TMUX" && FBTERM=1 TERM=fbterm fbterm --font-name=Inconsolata\ for\ Powerline --font-size=15 && (tmux attach || tmux new-session)
fi

if [ -e "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi
