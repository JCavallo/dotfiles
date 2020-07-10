"===============================================================================
" Nvimrc.
"
" When vim is not enough, there is neovim
"===============================================================================
let $MYVIMRC = fnamemodify(expand('<sfile>'), ':p')

" Properly set python
" if filereadable($HOME . '/.pyenv/versions/neovim2/bin/python')
"     let g:python_host_prog = $HOME . '/.pyenv/versions/neovim2/bin/python'
" else
"     let g:python_host_prog = '/usr/bin/python2'
" endif
" if filereadable($HOME . '/.pyenv/versions/neovim3/bin/python')
"     let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim3/bin/python'
" else
"     let g:python3_host_prog = '/usr/bin/python3'
" endif

echom $MYVIMRC

execute 'source' expand('~/.vimrc')
