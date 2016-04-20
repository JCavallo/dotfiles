" Easier terminal exit
tnoremap <A-a> <C-\><C-n>?\w<CR>$:noh<CR>:wincmd p<CR>

" Hide terminal
tnoremap <A-z> <C-\><C-n>?\w<CR>$:noh<CR>:quit<CR>

" Kill terminal
tnoremap <A-s> <C-\><C-n>:bdelete!<CR>

" Use C-v to paste
tnoremap <C-v> <C-\><C-n>pa

" New terminal in split
nnoremap St :call OpenTerminal()<CR>
nnoremap Sr :<C-u>vsplit \| terminal<CR>
nnoremap Sdt :call DeleteNamedBuffer("__DefaultTerm__")<CR>
nnoremap Sht :call HideNamedBuffer("__DefaultTerm__")<CR>

function! OpenTerminal()  " {{{
    let term_buffer = bufnr("__DefaultTerm__")
    if term_buffer != -1 && bufwinnr(term_buffer) != -1
        execute ":" . bufwinnr(term_buffer) . "wincmd w"
        normal A
    elseif term_buffer != -1
        execute ":vsplit"
        execute ":vertical resize 130"
        execute ":set winfixwidth"
        execute ":buffer " . term_buffer
        normal A
    else
        execute ":vsplit"
        execute ":vertical resize 130"
        execute ":set winfixwidth"
        execute ":terminal"
        execute ":file __DefaultTerm__"
    endif
endfunction  " }}}

" Open psql in split
nnoremap Sq :call OpenPsql()<CR>
nnoremap Shq :call DeleteNamedBuffer("__PsqlTerm__")<CR>
nnoremap Shq :call HideNamedBuffer("__PsqlTerm__")<CR>

function! OpenPsql()  " {{{
    let term_buffer = bufnr("__PsqlTerm__")
    if term_buffer != -1 && bufwinnr(term_buffer) != -1
        execute ":" . bufwinnr(term_buffer) . "wincmd w"
        normal A
    elseif term_buffer != -1
        execute ":vsplit"
        execute ":vertical resize 130"
        execute ":set winfixwidth"
        execute ":buffer " . term_buffer
        normal A
    else
        execute "let parameters = unite#util#input('" .
            \ "psql ')"
        execute ":vsplit"
        execute ":vertical resize 130"
        execute ":set winfixwidth"
        execute ":terminal psql " . parameters
        execute ":file __PsqlTerm__"
    endif
endfunction  " }}}

" Open Python in split
nnoremap Sp :call OpenPython()<CR>
nnoremap Sdp :call DeleteNamedBuffer("__PythonTerm__")<CR>
nnoremap Shp :call HideNamedBuffer("__PythonTerm__")<CR>

function! OpenPython()  " {{{
    let python_buffer = bufnr("__PythonTerm__")
    if python_buffer != -1 && bufwinnr(python_buffer) != -1
        execute ":" . bufwinnr(python_buffer) . "wincmd w"
        normal A
    elseif python_buffer != -1
        execute ":vsplit"
        execute ":vertical resize 130"
        execute ":set winfixwidth"
        execute ":buffer " . python_buffer
        normal A
    else
        execute ":vsplit"
        execute ":vertical resize 130"
        execute ":set winfixwidth"
        if executable("ptpython")
            execute ":terminal ptpython --vi"
        else
            execute ":terminal python"
        endif
        execute ":file __PythonTerm__"
    endif
endfunction  " }}}

" Run select lines in python term
vnoremap <A-p> :<C-U>call RunSelectedPython()<CR><Esc>

function! RunSelectedPython()  " {{{
    let reg_save = @*
    silent exe "normal! gvy"

    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    if lnum1 > lnum2
        let [lnum1, lnum2] = [lnum2, lnum1]
    endif
    let lines = getline(lnum1, lnum2)

    let min_spaces = 100
    for line in lines
        if line != ""
            let min_spaces = min([min_spaces,
                    \ len(line) - len(substitute(line, '^\s*', '', ''))])
        endif
    endfor
    let final_lines = []
    for line in lines
        if line !=  ""
            let new_line = line[min_spaces :]
            call add(final_lines, new_line)
        else
            call add(final_lines, line)
        endif
    endfor
    call add(final_lines, '')

    let @* = join(final_lines, '')

    call OpenPython()

    " Currently terminal cannot handle Fn keys :'(
    " https://github.com/neovim/neovim/issues/4343

    " startinsert
    " <F6>
    silent exe "normal! p"
    " <F6><C-\><C-n>
    wincmd p
    let @* = reg_save
endfunction  " }}}

" Delete Buffer
function! DeleteNamedBuffer(buf_name)  " {{{
    let nbr = bufnr(a:buf_name )
    if nbr == -1
    else
        execute ":silent bdelete! " . nbr
    endif
endfunction  " }}}

" Hide Buffer
function! HideNamedBuffer(buf_name)  " {{{
    let nbr = bufnr(a:buf_name )
    if nbr == -1
    else
        if nbr != -1 && bufwinnr(nbr) != -1
            execute ":silent quit " . nbr
        endif
    endif
endfunction " }}}
