"---------------------------------------------------------------------------
" deoplete.nvim
"---------------------------------------------------------------------------

set completeopt+=noinsert

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

inoremap <expr><C-y>  deoplete#mappings#close_popup()
inoremap <expr><C-e>  deoplete#mappings#cancel_popup()

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deolete#mappings#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"

let g:deoplete#sources = {}
let g:deoplete#sources._ = ['buffer', 'tags', 'omni']
