"===============================================================================
" Initialize directories, load neobundle, disable unused features
"===============================================================================

" Use english
language message C

" Remap leader key
let g:mapleader = ','

" Release keymappings for plug-in.
nnoremap ;  <Nop>
xnoremap ;  <Nop>
nnoremap ,  <Nop>
xnoremap ,  <Nop>

" Everything should go in $CACHE
let $CACHE = $FORCE_VIM_CACHE != '' ? $FORCE_VIM_CACHE : '~/.cache'
if !isdirectory(expand($CACHE))
    call mkdir(expand($CACHE), 'p')
endif

" Load dein. {{{
let s:dein_dir = finddir('dein.vim', '.;')
if s:dein_dir != '' || &runtimepath !~ '/dein.vim'
    if s:dein_dir == '' && &runtimepath !~ '/dein.vim'
        let s:dein_dir = expand($CACHE . '/dein')
            \ . '/repos/github.com/Shougo/dein.vim'
        if !isdirectory(s:dein_dir)
            execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
        endif
    endif
    execute ' set runtimepath^=' . substitute(
        \ fnamemodify(s:dein_dir, ':p') , '/$', '', '')
endif
"}}}

"---------------------------------------------------------------------------
" Disable default plugins
"---------------------------------------------------------------------------

" Disable menu.vim
if has('gui_running')
    set guioptions=Mc
endif

let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_LogiPat           = 1
let g:loaded_logipat           = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_spellfile_plugin  = 1
let g:loaded_man               = 1
