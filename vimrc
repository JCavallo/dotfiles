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

if $FORCE_VIM_FOLDER != ''
    let g:vim_folder = $FORCE_VIM_FOLDER
else
    let g:vim_folder = expand('$HOME') . (has('unix') ? '/.vim' : '\nvim')
endif

function! s:source_rc(path, ...) abort "{{{
    execute 'source' . fnameescape(
        \ resolve(expand(g:vim_folder . '/rc/' . a:path)))
endfunction "}}}

"===============================================================================
" Global configuration
"===============================================================================
" {{{
let g:has_notes = 0
let g:note_directory = $HOME . '/notes'
" let g:color_scheme = 'tender'
" let g:airline_theme = 'deus'
let g:color_scheme = 'photon'
let g:airline_theme = 'minimalist'
let g:local_plugin_path = '$HOME/Projets/Plugins/'
" }}}

"===============================================================================
" Call init.rc
" This will preload dein, create necessary directories if needed, clean up
" mapping
"===============================================================================

if has('vim_starting')
    call s:source_rc('init.rc.vim')
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
" Install and initialize Dein
" Dein use a specific cache to avoid reparsing all plugins when starting
" vim. So we make sure it is properly configured, then call dein.rc, which
" will load all plugins
"===============================================================================

call s:source_rc('dein.rc.vim')

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
execute ':colorscheme ' . g:color_scheme

" Lock modifications
set secure
