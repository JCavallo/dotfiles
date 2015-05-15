execute 'source' fnamemodify(expand('<sfile>'), ':h').'/.vimrc'

" sorter_selecta requires ruby, which neovim does not support yet
call unite#filters#sorter_default#use(['sorter_length'])
