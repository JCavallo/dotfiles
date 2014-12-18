"===============================================================================
" Gui configuration
"===============================================================================

" For Linux.
set guifont=Inconsolata\ 9
" Width of window.
set columns=100
" Height of window.
set lines=50

" Theme
colorscheme flashy_vim

"===============================================================================
" Mouse configuration
"===============================================================================

set mousemodel=extend
" Don't focus the window when the mouse pointer is moved.
set nomousefocus
" Hide mouse pointer on insert mode.
set mousehide

"===============================================================================
" Menu configuration
"===============================================================================

" Hide toolbar and menus.
set guioptions-=Tt
set guioptions-=m
" Scrollbar is always off.
set guioptions-=rL
" Not guitablabel.
set guioptions-=e

" Confirm without window.
set guioptions+=c

"===============================================================================
" Menu configuration
"===============================================================================

" Don't flick cursor.
set guicursor&
set guicursor+=a:blinkon0

"===============================================================================
" Some gui specific settings
"===============================================================================

" Fix meta-keys which generate <Esc>A .. <Esc>z
if !has('gui_running')
    let c='a'
    while c <= 'z'
        exec "set <M-".c.">=\e".c
        exec "imap \e".c." <M-".c.">"
        let c = nr2char(1+char2nr(c))
    endw
    " Map these two on its own to enable Alt-Shift-J and Alt-Shift-K. If I map the
    " whole spectrum of A-Z, it screws up mouse scrolling somehow. Mouse events
    " must be interpreted as some form of escape sequence that interferes.
    exec 'set <M-J>=J'
    exec 'set <M-K>=K'
endif

" Spelling highlights. Use underline in term to prevent cursorline highlights
" from interfering
if !has("gui_running")
    hi clear SpellBad
    hi SpellBad cterm=underline ctermfg=red
    hi clear SpellCap
    hi SpellCap cterm=underline ctermfg=blue
    hi clear SpellLocal
    hi SpellLocal cterm=underline ctermfg=blue
    hi clear SpellRare
    hi SpellRare cterm=underline ctermfg=blue
endif
