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

" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

function! s:source_rc(path)
  execute 'source' fnameescape(expand('~/.vim/rc/' . a:path))
endfunction

let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_sudo = $SUDO_USER != '' && $USER !=# $SUDO_USER
      \ && $HOME !=# expand('~'.$USER)
      \ && $HOME ==# expand('~'.$SUDO_USER)

function! IsWindows()
  return s:is_windows
endfunction

function! IsMac()
  return !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \   (!executable('xdg-open') &&
      \     system('uname') =~? '^darwin'))
endfunction

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

if neobundle#has_cache()
  NeoBundleLoadCache
else
  call s:source_rc('neobundle.rc.vim')
  NeoBundleSaveCache
endif

if filereadable('vimrc_local.vim') ||
      \ findfile('vimrc_local.vim', '.;') != ''
  " Load develop version.
  call neobundle#local(fnamemodify(
        \ findfile('vimrc_local.vim', '.;'), ':h'))
endif

NeoBundleLocal ~/.vim/bundle

call neobundle#end()

NeoBundleCheck

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
" Call plugins.rc.vim
" Configure installed plugins. Part of the configuration may be in rc/plugins/*
" config files which will be loaded on demand
"===============================================================================

 call s:source_rc('plugins.rc.vim')

"===============================================================================
" Call mappings.rc.vim
" Mapping file.
"===============================================================================

 call s:source_rc('mappings.rc.vim')

"===============================================================================
" Call platform specific rc files
"===============================================================================

if s:is_windows
  call s:source_rc('windows.rc.vim')
else
  call s:source_rc('unix.rc.vim')
endif

"===============================================================================
" Mouse configuration
"===============================================================================

" Using the mouse on a terminal.
if has('mouse')
  set mouse=a
  if has('mouse_sgr') || v:version > 703 ||
        \ v:version == 703 && has('patch632')
    set ttymouse=sgr
  else
    set ttymouse=xterm2
  endif

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
" Call extra_commands.rc.vim
" Custom not plugin commands
"===============================================================================

 call s:source_rc('extra_commands.rc.vim')

"===============================================================================
" End
"===============================================================================

" Default home directory.
let t:cwd = getcwd()

call neobundle#call_hook('on_source')

set secure

"===============================================================================
" General Settings
"===============================================================================




"===============================================================================
" Ag : To bind to unite grep
"===============================================================================

" nmap <leader>aa <Esc>:Ag 
" nmap <leader>ac <Esc>:Ag "class 
" nmap <leader>an <Esc>:Ag "__name__ = '
" nmap <leader>ad <Esc>:Ag "def 
" nmap <leader>ax <Esc>:Ag -G xml 
" nmap <leader>afm <Esc>:Ag "^ *[a-zA-Z_]* = fields\.Many2One\([\n ]*'
" nmap <leader>afo <Esc>:Ag "^ *[a-zA-Z_]* = fields\.One2Many\([\n ]*'
" nmap <leader>agg <Esc>:Ag -G coopbusiness 
" nmap <leader>agn <Esc>:Ag -G coopbusiness "__name__ = '
" nmap <leader>agc <Esc>:Ag -G coopbusiness "class 
" nmap <leader>agd <Esc>:Ag -G coopbusiness "def 
" nmap <leader>agx <Esc>:Ag -G coopbusiness.*xml 
" nmap <leader>agfm <Esc>:Ag -G coopbusiness "^ *[a-zA-Z_]* = (fields\.Function\()?[\n ]*fields\.Many2One\([\n ]*'
" nmap <leader>agfo <Esc>:Ag -G coopbusiness "^ *[a-zA-Z_]* = (fields\.Function\()?[\n ]*fields\.One2Many\([\n ]*'


"===============================================================================
" Unite Sessions
"===============================================================================

" Save session automatically.
let g:unite_source_session_enable_auto_save = 1
