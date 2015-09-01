"===============================================================================
" My vimrc
"
" Mostly inspired by Terry Ma's :
" https://github.com/terryma/dotfiles/blob/master/.vimrc
"
" and Shougo's :
" https://github.com/Shougo/shougo-s-github/blob/master/vim/vimrc
"
"===============================================================================

" Disable vi-compatibility. Must be first to avoid multiline problems with the
" \ separator
set nocompatible

let $VIM_FOLDER = $FORCE_VIM_FOLDER != '' ? $FORCE_VIM_FOLDER : expand('~/.vim')
let $MYVIMRC = expand('%:p')


function! s:source_rc(path)
    execute 'source' fnameescape(expand($VIM_FOLDER . '/rc/' . a:path))
endfunction

let s:is_sudo = $SUDO_USER != '' && $USER !=# $SUDO_USER
    \ && $HOME !=# expand('~'.$USER)
    \ && $HOME ==# expand('~'.$SUDO_USER)

"===============================================================================
" Call init.rc
" This will preload neobundle, create necessary directories if needed, clean up
" mapping
"===============================================================================

call s:source_rc('init.rc.vim')

"===============================================================================
" Call neobundle.rc
" Neobundle use a specific cache to avoid reparsing all plugins when starting
" vim. So we make sure it is properly configured, then call neobudle.rc, which
" will load all plugins
"===============================================================================

call neobundle#begin(expand('$CACHE/neobundle'))

if neobundle#load_cache()
    NeoBundleFetch 'Shougo/neobundle.vim'

    NeoBundle 'Shougo/vimproc.vim', {
        \ 'build' : {
        \     'windows' : 'tools\\update-dll-mingw',
        \     'cygwin' : 'make -f make_cygwin.mak',
        \     'mac' : 'make -f make_mac.mak',
        \     'unix' : 'make -f make_unix.mak',
        \    }
        \ }

    call neobundle#load_toml(expand(
            \ '$VIM_FOLDER/rc/neobundle.toml'), {'lazy' : 1})
    NeoBundleSaveCache
endif

call s:source_rc('plugins.rc.vim')

call neobundle#end()

"===============================================================================
" Global settings
"===============================================================================

" Ignore the case of normal letters.
set ignorecase

" If the search pattern contains upper case characters, override ignorecase
" option.
set smartcase

" Enable incremental search.
set incsearch

" Highlight search result.
set hlsearch

" Searches wrap around the end of the file.
set wrapscan

" Default encoding is UTF8
set encoding=utf-8
set fileencoding=utf8

" Load indent files to automatically do language-dependent indenting
filetype indent on

" Load ftplugin
filetype plugin on

syntax enable

"===============================================================================
" Finalize plugin installation
" Configure installed plugins. Part of the configuration may be in rc/plugins/*
" config files which will be loaded on demand
"===============================================================================

if !has('vim_starting')
    " Installation check.
    NeoBundleCheck
endif

"===============================================================================
" Local Settings
"===============================================================================

try
    source ~/.vimrc.local
catch
endtry

"===============================================================================
" Call edit.rc
" This will set some global options when editing, history, folding, etc...
"===============================================================================

call s:source_rc('edit.rc.vim')

"===============================================================================
" Call view.rc
" This will customize the window structure
"===============================================================================

call s:source_rc('view.rc.vim')

"===============================================================================
" Call filetype.rc
" This will set filetype specific options
"===============================================================================

call s:source_rc('filetype.rc.vim')

"===============================================================================
" Call extra_commands.rc.vim
" Custom not plugin commands
"===============================================================================

 call s:source_rc('extra_commands.rc.vim')

"===============================================================================
" Call mappings.rc.vim
" Mapping file.
"===============================================================================

 call s:source_rc('mappings.rc.vim')

"===============================================================================
" Call platform specific rc files
"===============================================================================

call s:source_rc('unix.rc.vim')

"===============================================================================
" Mouse configuration
"===============================================================================

" Using the mouse on a terminal.
if has('mouse')
    set mouse=a
    if !has('nvim')
        set ttymouse=sgr
    endif

    " Copy
    vnoremap <LeftMouse> "+y
    " Paste.
    nnoremap <RightMouse> "+p
    xnoremap <RightMouse> "+p
    inoremap <RightMouse> <C-r><C-o>+
    cnoremap <RightMouse> <C-r>+
endif

"===============================================================================
" Gui configuration
"===============================================================================

if has('gui_running')
    call s:source_rc('gui.rc.vim')
endif

"===============================================================================
" End
"===============================================================================

" Default home directory.
let t:cwd = getcwd()

" Set colorscheme
if has('gui')
    colorscheme flashy_vim
else
    GuiColorScheme flashy_vim
endif

set secure
