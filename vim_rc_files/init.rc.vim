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

" Set augroup.
augroup MyAutoCmd
  autocmd!
augroup END

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
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
