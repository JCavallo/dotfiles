"===============================================================================
" Gui configuration
"===============================================================================

if has('win32') || has('win64')
  " For Windows.

  set guifontwide=Inconsolata:h9
  set guifont=Inconsolata:h9

  " Number of pixel lines inserted between characters.
  set linespace=2

elseif has('mac')
  " For Mac.
  set guifont=Inconsolata:h9
else
  " For Linux.
  set guifont=Inconsolata\ 9
endif

if has('win32') || has('win64')
  " Width of window.
  set columns=230
  " Height of window.
  set lines=55

  " Set transparency.
  "autocmd GuiEnter * set transparency=221
  " Toggle font setting.
  command! TransparencyToggle let &transparency =
        \ (&transparency != 255 && &transparency != 0)? 255 : 221
  nnoremap TT     :<C-u>TransparencyToggle<CR>
else
  " Width of window.
  set columns=100
  " Height of window.
  set lines=50
endif

" Theme
colorscheme flashy_vim

"===============================================================================
" Mouse configuration
"===============================================================================

set mousemodel=extend
" Don't focus the window when the mouse pointer is moved.
set nomousefocus
" Hide mouse pointer on insert mode.
set mousehide

"===============================================================================
" Menu configuration
"===============================================================================

" Hide toolbar and menus.
set guioptions-=Tt
set guioptions-=m
" Scrollbar is always off.
set guioptions-=rL
" Not guitablabel.
set guioptions-=e

" Confirm without window.
set guioptions+=c

"===============================================================================
" Menu configuration
"===============================================================================

" Highlight search result.
set hlsearch

" Don't flick cursor.
set guicursor&
set guicursor+=a:blinkon0
