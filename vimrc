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
else
    let $MYVIMRC = fnamemodify(expand('<sfile>'), ':p')
endif

" Notes tooling
let g:has_notes = 0
let g:note_directory = $HOME . '/notes'

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

" Set augroup.
augroup MyAutoCmd
  autocmd!
  autocmd FileType,Syntax,BufNewFile,BufNew,BufRead *?
        \ call s:on_filetype()
  " toml syntax is broken
  autocmd CursorHold *.toml syntax sync minlines=300
augroup END
augroup filetypedetect
augroup END

" Lazy check filetypes
function! s:on_filetype() abort "{{{
  if execute('filetype') =~# 'OFF'
    silent! filetype plugin indent on
    syntax enable
    filetype detect
  endif
endfunction " }}}

"===============================================================================
" Call init.rc
" This will preload dein, create necessary directories if needed, clean up
" mapping
"===============================================================================

if has('vim_starting')
    call s:source_rc('init.rc.vim')
endif

"===============================================================================
" Install and initialize Dein
" Dein use a specific cache to avoid reparsing all plugins when starting
" vim. So we make sure it is properly configured, then call dein.rc, which
" will load all plugins
"===============================================================================

call s:source_rc('dein.rc.vim')

if has('vim_starting') && !empty(argv())
  call s:on_filetype()
endif

if !has('vim_starting')
  call dein#call_hook('source')
  call dein#call_hook('post_source')
endif

"===============================================================================
" Global settings
"===============================================================================

call s:source_rc('options.rc.vim')

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
" Local Settings
"===============================================================================

try
    source ~/.vimrc.local
catch
endtry

"===============================================================================
" Call mappings.rc.vim
" Mapping file.
"===============================================================================

 call s:source_rc('mappings.rc.vim')

"===============================================================================
" In case of awesomeness
"===============================================================================

if has('nvim')
  call s:source_rc('neovim.rc.vim')
endif

"===============================================================================
" End
"===============================================================================

" Try to set colorscheme
" silent! colorscheme flashy_vim
" silent! colorscheme photon
" let g:airline_theme = 'minimalist'
silent! colorscheme tender
let g:airline_theme = 'tender'
call rainbow_parentheses#activate()

" Lock modifications
set secure
