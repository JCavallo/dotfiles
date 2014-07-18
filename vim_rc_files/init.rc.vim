"===============================================================================
" Initialize directories, load neobundle, disable unused features
"===============================================================================

" Use English interface.
if IsWindows()
  " For Windows.
  language message en
else
  " For Linux.
  language message C
endif

" Remap leader key
let g:mapleader = ','
" let g:maplocalleader = 'm'

" Release keymappings for plug-in.
nnoremap ;  <Nop>
xnoremap ;  <Nop>
" nnoremap m  <Nop>
" xnoremap m  <Nop>
nnoremap ,  <Nop>
xnoremap ,  <Nop>

if IsWindows()
  " Exchange path separator.
  set shellslash
endif

" Everything should go in $CACHE
let $CACHE = expand('~/.cache')

if !isdirectory(expand($CACHE))
  call mkdir(expand($CACHE), 'p')
endif

" Clean group MyAytoCmd
augroup MyAutoCmd
  autocmd!
augroup END

if filereadable(expand('~/.secret_vimrc'))
  execute 'source' expand('~/.secret_vimrc')
endif

let s:neobundle_dir = expand('$CACHE/neobundle')

if has('vim_starting') "{{{
  " Set runtimepath.
  if IsWindows()
    let &runtimepath = join([
          \ expand('~/.vim'),
          \ expand('$VIM/runtime'),
          \ expand('$VIMRUNTIME'),
          \ expand('~/.vim/after')], ',')
  endif

  " Load neobundle.
  if isdirectory('neobundle.vim')
    set runtimepath^=neobundle.vim
  elseif finddir('neobundle.vim', '.;') != ''
    execute 'set runtimepath^=' . finddir('neobundle.vim', '.;')
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
"
"---------------------------------------------------------------------------
" Disable default plugins

" Disable menu.vim
if has('gui_running')
  set guioptions=Mc
endif

" Disable GetLatestVimPlugin.vim
if !&verbose
  let g:loaded_getscriptPlugin = 1
endif

let g:loaded_netrwPlugin = 1
let g:loaded_matchparen = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimballPlugin = 1
