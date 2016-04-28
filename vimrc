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
if &compatible
    set nocompatible
endif

let $VIM_FOLDER = $FORCE_VIM_FOLDER != '' ? $FORCE_VIM_FOLDER : expand('~/.vim')
if !has('nvim')
    let $MYVIMRC = expand('%:h')
endif

function! s:source_rc(path, ...) abort "{{{
    let use_global = get(a:000, 0, !has('vim_starting'))
    let abspath = resolve(expand($VIM_FOLDER . '/rc/' . a:path))
    if !use_global
        execute 'source' fnameescape(abspath)
        return
    endif

    " substitute all 'set' to 'setglobal'
    let content = map(readfile(abspath),
            \ 'substitute(v:val, "^\\W*\\zsset\\ze\\W", "setglobal", "")')
    " create tempfile and source the tempfile
    let tempfile = tempname()
    try
        call writefile(content, tempfile)
        execute printf('source %s', fnameescape(tempfile))
    finally
        if filereadable(tempfile)
        call delete(tempfile)
        endif
    endtry
endfunction "}}}

let s:is_sudo = $SUDO_USER != '' && $USER !=# $SUDO_USER
    \ && $HOME !=# expand('~'.$USER)
    \ && $HOME ==# expand('~'.$SUDO_USER)

" Set augroup.
augroup MyAutoCmd
    autocmd!
augroup END

"===============================================================================
" Call init.rc
" This will preload dein, create necessary directories if needed, clean up
" mapping
"===============================================================================

if has('vim_starting')
    call s:source_rc('init.rc.vim')
endif

"===============================================================================
" Install and initialize Neobundle
" Neobundle use a specific cache to avoid reparsing all plugins when starting
" vim. So we make sure it is properly configured, then call neobudle.rc, which
" will load all plugins
"===============================================================================

call s:source_rc('dein.rc.vim')

if !has('vim_starting')
    call dein#call_hook('source')
    call dein#call_hook('post_source')

    syntax enable
    filetype plugin indent on
endif

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
if has('vim_starting')
    set encoding=utf-8
    set fileencoding=utf8
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

" call s:source_rc('filetype.rc.vim')
autocmd MyAutoCmd FileType,Syntax,BufNewFile,BufNew,BufRead
    \ * call s:my_on_filetype()

function! s:my_on_filetype() abort "{{{
    if &l:filetype == '' && bufname('%') == ''
        return
    endif

    redir => filetype_out
    silent! filetype
    redir END
    if filetype_out =~# 'OFF'
        " Lazy loading
        silent! filetype plugin indent on
        syntax enable
        filetype detect
    endif
endfunction "}}}

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
" Gui configuration
"===============================================================================

if has('gui_running')
    call s:source_rc('gui.rc.vim')
endif

if has('nvim')
  call s:source_rc('neovim.rc.vim')
endif

"===============================================================================
" End
"===============================================================================

" Default home directory.
let t:cwd = getcwd()

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

set secure
colorscheme flashy_vim
