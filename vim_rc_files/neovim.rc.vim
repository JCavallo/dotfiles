" Easier terminal exit
tnoremap <A-a> <C-\><C-n>?\w<CR>$:noh<CR>

" Use C-v to paste
tnoremap <C-v> <C-\><C-n>pa

" New terminal in split
nnoremap [Window]t :call OpenTerminal()<CR>
nnoremap [Window]r :<C-u>vsplit \| terminal<CR>

function! OpenTerminal()
    let term_buffer = bufnr("__DefaultTerm__")
    if term_buffer != -1 && bufwinnr(term_buffer) != -1
        execute ":" . bufwinnr(term_buffer) . "wincmd w"
        normal A
    elseif term_buffer != -1
        execute ":vsplit"
        execute ":buffer " . term_buffer
        normal A
    else
        execute ":vsplit"
        execute ":terminal"
        execute ":file __DefaultTerm__"
    endif
endfunction
