execute 'source' fnamemodify(expand('<sfile>'), ':h').'/.vimrc'

" sorter_selecta requires ruby, which neovim does not support yet
call unite#filters#sorter_default#use(['sorter_nothing'])

tnoremap <A-a> <C-\><C-n>

" New terminal in split
nnoremap <silent> [Window]t :<C-u>vsplit \| terminal<CR>

" Manager teminal mode
let g:airline_mode_map.t = 'TER'
