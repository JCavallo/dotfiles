"===============================================================================
" Nvimrc.
"
" When vim is not enough, there is neovim
"===============================================================================
let $MYVIMRC = fnamemodify(expand('<sfile>'), ':p')
execute 'source' fnamemodify(expand('<sfile>'), ':h') . '/.vimrc'
