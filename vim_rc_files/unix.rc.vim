"===============================================================================
" Unix specific configuration
"===============================================================================

set shell=bash

" Set path.
let $PATH = expand('~/bin').':/usr/local/bin/:'.$PATH

if has('gui_running')
  finish
endif

"===============================================================================
" Command line interface configuration
"===============================================================================

" Enable 256 color terminal.
set t_Co=256

if has('gui')
  " Use CSApprox.vim
  NeoBundleSource csapprox

  " Convert colorscheme in Konsole.
  let g:CSApprox_konsole = 1
  let g:CSApprox_attr_map = {
        \ 'bold' : 'bold',
        \ 'italic' : '', 'sp' : ''
        \ }
else
  " Use guicolorscheme.vim
  NeoBundleSource vim-guicolorscheme

  " Force usage of vim-airline
  NeoBundleSource vim-airline

  " Disable error messages.
  let g:CSApprox_verbose_level = 0
endif
