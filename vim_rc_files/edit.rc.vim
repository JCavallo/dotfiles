"===============================================================================
" Edit options
"===============================================================================

" Tabs {{{
" Smart insert tab setting.
set smarttab
" Exchange tab to spaces.
set expandtab
" Substitute <Tab> with blanks.
set tabstop=4
" Spaces instead <Tab>.
set softtabstop=4
" Autoindent width.
set shiftwidth=4
" Round indent by shiftwidth.
set shiftround
" Enable smart indent.
set autoindent smartindent
" }}}

" Enable modeline.
set modeline

" Never write a file without me requesting it
set noautowrite
set noautoread

" Use clipboard register.
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus
else
    set clipboard& clipboard+=unnamed
endif

" Enable backspace delete indent and newline.
set backspace=indent,eol,start

" Matchs {{{
" Highlight parenthesis.
set showmatch
set cpoptions-=m
set matchtime=3

" Highlight <>.
set matchpairs+=<:>
" }}}

" Display another buffer when current buffer isn't saved.
set hidden

" Autocomplete setting {{{
" Ignore case on insert completion.
set infercase

set completeopt=menu,longest
set wildmode=list:longest,full
set wildignore+=*.o,*.obj,.git,*.pyc
set wildignore+=eggs/**
set wildignore+=*.egg-info/**
set wildignore+=.hg,*.orig,*.rej
set wildoptions=tagfile
" }}}

" Folding {{{
set foldenable
set foldmethod=syntax
set foldlevelstart=1

" Fold on one line
function! CustomFoldText()  " {{{
    "get first non-blank line
    let fs = v:foldstart
    while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
    endwhile
    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
    endif

    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = " " . foldSize . " lines "
    let foldLevelStr = repeat("+--", v:foldlevel)
    let lineCount = line("$")
    let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "
    let expansionString = repeat(".", w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
    return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endfunction  "}}}

set foldtext=CustomFoldText()
" }}}

" Use grep.
if executable("ag")
    set grepprg=ag\ --nogroup
else
    set grepprg=grep\ -inH
endif

" Exclude = from isfilename.
set isfname-==

" Reload .vimrc automatically.
if $MYVIMRC != ''
    autocmd MyAutoCmd BufWritePost .vimrc,vimrc,*.rc.vim,neobundle.toml
        \ NeoBundleClearCache | source $MYVIMRC | redraw
endif

" Keymapping timeout.
set timeout timeoutlen=1000 ttimeoutlen=0

" CursorHold time.
set updatetime=1000

" History and undo {{{
set undofile
set undodir=$VIM_FOLDER/undodir
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload
set backupdir=$VIM_FOLDER/backup
set directory=$VIM_FOLDER/swap
set viminfo='50,<1000,s100,n~/.viminfo

" Sets how many lines of history vim has to remember
set history=10000
" }}}

" Enable virtualedit in visual block mode, add virtual space at end of line
set virtualedit=block,onemore

" Set keyword help.
set keywordprg=:help

" Disable paste.
autocmd MyAutoCmd InsertLeave *
    \ if &paste | set nopaste mouse=a | echo 'nopaste' | endif |
    \ if &l:diff | diffupdate | endif

" Update diff.
autocmd MyAutoCmd InsertLeave * if &l:diff | diffupdate | endif

" Make directory automatically.
" --------------------------------------
" http://vim-users.jp/2011/02/hack202/

autocmd MyAutoCmd BufWritePre *
    \ call s:mkdir_as_necessary(expand('<afile>:p:h'), v:cmdbang)
function! s:mkdir_as_necessary(dir, force)
    if !isdirectory(a:dir) && &l:buftype == '' &&
            \ (a:force || input(printf('"%s" does not exist. Create? [y/N]',
            \              a:dir)) =~? '^y\%[es]$')
        call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
endfunction
