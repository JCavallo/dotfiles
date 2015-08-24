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

" Clean group MyAytoCmd
augroup MyAutoCmd
    autocmd!
augroup END

let s:neobundle_dir = expand($CACHE . '/neobundle')

if has('vim_starting') "{{{
    " Load neobundle.
    if finddir('neobundle.vim', '.;') != ''
        execute 'set runtimepath^=' .
            \ fnamemodify(finddir('neobundle.vim', '.;'), ':p')
    elseif &runtimepath !~ '/neobundle.vim'
        if !isdirectory(s:neobundle_dir.'/neobundle.vim')
            execute printf('!git clone %s://github.com/Shougo/neobundle.vim.git',
                \ (exists('$http_proxy') ? 'https' : 'git'))
                \ s:neobundle_dir.'/neobundle.vim'
        endif
        execute 'set runtimepath^=' . s:neobundle_dir.'/neobundle.vim'
    endif
endif
"}}}

let g:neobundle#default_options = {}

"---------------------------------------------------------------------------
" Disable default plugins
"---------------------------------------------------------------------------

" Disable menu.vim
if has('gui_running')
    set guioptions=Mc
endif

" Disable GetLatestVimPlugin.vim
if !&verbose
    let g:loaded_getscriptPlugin = 1
endif

let g:loaded_netrwPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimballPlugin = 1
