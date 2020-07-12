" Intelligent cursor
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

" Share histories
autocmd MyAutoCmd FocusGained * checktime

" Modifiable terminal
autocmd MyAutoCmd TermOpen * setlocal modifiable
autocmd MyAutoCmd TermClose * buffer #
let g:terminal_scrollback_buffer_size = 3000

" Preview search results
set inccommand=split

" Exit terminal mode
tnoremap <A-q> <C-\><C-n>?\w<CR>$:noh<CR>

" Exit terminal and switch window
tnoremap <A-a> <C-\><C-n>?\w<CR>$:noh<CR>:wincmd p<CR>

" Hide terminal
tnoremap <A-z> <C-\><C-n>?\w<CR>$:noh<CR>:quit<CR>

" Kill terminal
tnoremap <A-q> <C-\><C-n>:bdelete!<CR>

" Use C-v to paste
tnoremap <C-v> <C-\><C-n>pa

let s:default_special_buffer_size = 200

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
        execute ":vert botright split"
        execute ":vertical resize 130"
        execute ":set winfixwidth"
        execute ":buffer " . term_buffer
        normal A
    else
        execute ":vert botright split"
        execute ":vertical resize 130"
        execute ":set winfixwidth"
        execute ":terminal"
        execute ":file __DefaultTerm__"
    endif
endfunction  " }}}

" Open hangups in split
nnoremap Sc :call OpenHangups()<CR>
nnoremap Sdc :call DeleteNamedBuffer("__HangupsTerm__")<CR>
nnoremap Shc :call HideNamedBuffer("__HangupsTerm__")<CR>

function! OpenHangups()  " {{{
    let term_buffer = bufnr("__HangupsTerm__")
    if term_buffer != -1 && bufwinnr(term_buffer) != -1
        execute ":" . bufwinnr(term_buffer) . "wincmd w"
        normal A
    elseif term_buffer != -1
        execute ":vert botright split"
        execute ":vertical resize 130"
        execute ":set winfixwidth"
        execute ":buffer " . term_buffer
        normal A
    else
        execute ":vert botright split"
        execute ":vertical resize 130"
        execute ":set winfixwidth"
        execute ":terminal hangups"
        execute ":file __HangupsTerm__"
    endif
endfunction  " }}}

" Open psql in split
nnoremap Sq :call OpenPsql()<CR>
nnoremap Sdq :call DeleteNamedBuffer("__PsqlTerm__")<CR>
nnoremap Shq :call HideNamedBuffer("__PsqlTerm__")<CR>

function! OpenPsql()  " {{{
    let term_buffer = bufnr("__PsqlTerm__")
    if term_buffer != -1 && bufwinnr(term_buffer) != -1
        execute ":" . bufwinnr(term_buffer) . "wincmd w"
        normal A
    elseif term_buffer != -1
        execute ":vert botright split"
        execute ":vertical resize 130"
        execute ":set winfixwidth"
        execute ":buffer " . term_buffer
        normal A
    else
        execute "let parameters = unite#util#input('" .
            \ "psql ')"
        execute ":vert botright split"
        execute ":vertical resize 130"
        execute ":set winfixwidth"
        execute ":terminal psql " . parameters
        execute ":file __PsqlTerm__"
    endif
endfunction  " }}}

" Run select lines in sql term
vnoremap <A-s> :<C-U>call RunSelectedSQL()<CR><Esc>

function! RunSelectedSQL()  " {{{
    let reg_save = @*
    silent exe "normal! gvy"

    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    if lnum1 > lnum2
        let [lnum1, lnum2] = [lnum2, lnum1]
    endif
    let lines = getline(lnum1, lnum2)
    let unified_line = ''
    for line in lines
        if line == '--'
            continue
        endif
        let stripped_line = split(line, '-- ', 1)[0]
        let unified_line .= stripped_line . ' '
    endfor
    let final_lines = [unified_line]
    call add(final_lines, ' ')
    call add(final_lines, ';')

    let @* = join(final_lines, '')

    call OpenPsql()

    " Currently terminal cannot handle Fn keys :'(
    " https://github.com/neovim/neovim/issues/4343

    " startinsert
    " <F6>
    silent exe "normal! p"
    " <F6><C-\><C-n>
    wincmd p
    let @* = reg_save
endfunction  " }}}

" Open node in split
nnoremap Sn :call OpenNode()<CR>
nnoremap Sdn :call DeleteNamedBuffer("__NodeTerm__")<CR>
nnoremap Shn :call HideNamedBuffer("__NodeTerm__")<CR>

function! OpenNode()  " {{{
    let node_buffer = bufnr("__NodeTerm__")
    if node_buffer != -1 && bufwinnr(node_buffer) != -1
        execute ":" . bufwinnr(node_buffer) . "wincmd w"
        normal A
    elseif node_buffer != -1
        execute ":vert botright split"
        execute ":vertical resize 130"
        execute ":set winfixwidth"
        execute ":buffer " . node_buffer
        normal A
    else
        execute ":vert botright split"
        execute ":vertical resize 130"
        execute ":set winfixwidth"
        execute ":terminal repl-plus"
        execute ":file __NodeTerm__"
    endif
endfunction  " }}}

" Run select lines in node term
vnoremap <A-n> :<C-U>call RunSelectedNode()<CR><Esc>

function! RunSelectedNode()  " {{{
    let reg_save = @*
    silent exe "normal! gvy"

    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    if lnum1 > lnum2
        let [lnum1, lnum2] = [lnum2, lnum1]
    endif
    let lines = getline(lnum1, lnum2)
    let unified_line = ''
    for line in lines
        if line == '//'
            continue
        endif
        let stripped_line = split(line, '// ', 1)[0]
        let unified_line .= stripped_line . ' '
    endfor
    let final_lines = [unified_line]
    call add(final_lines, '')

    let @* = join(final_lines, '')

    call OpenNode()

    " Currently terminal cannot handle Fn keys :'(
    " https://github.com/neovim/neovim/issues/4343

    " startinsert
    " <F6>
    silent exe "normal! p"
    " <F6><C-\><C-n>
    wincmd p
    let @* = reg_save
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
        execute ":vert botright split"
        execute ":vertical resize 130"
        execute ":set winfixwidth"
        execute ":buffer " . python_buffer
        normal A
    else
        execute ":vert botright split"
        execute ":vertical resize 130"
        execute ":set winfixwidth"
        execute ":terminal python"
        execute ":file __PythonTerm__"
        normal A
    endif
endfunction  " }}}

" Run selected lines in python term
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

    let @* = join(final_lines, '') . ''

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
            execute ":silent quit " . bufwinnr(nbr)
        endif
    endif
endfunction " }}}

" Open Pudb
nnoremap Su :call OpenPudb()<CR>
nnoremap Sup :call DeleteNamedBuffer("__PudbTerm__")<CR>
nnoremap Sup :call HideNamedBuffer("__PudbTerm__")<CR>

function! OpenPudb()  " {{{
    let pudb_buffer = bufnr("__PudbTerm__")
    if pudb_buffer != -1 && bufwinnr(pudb_buffer) != -1
        execute ":" . bufwinnr(pudb_buffer) . "wincmd w"
        normal A
    elseif pudb_buffer != -1
        execute ":vert botright split"
        execute ":vertical resize " . s:default_special_buffer_size
        execute ":set winfixwidth"
        execute ":buffer " . pudb_buffer
        normal A
    else
        execute ":vert botright split"
        execute ":vertical resize " . s:default_special_buffer_size
        execute ":set winfixwidth"
        execute ":terminal telnet localhost 6899"
        execute ":file __PudbTerm__"
    endif
endfunction  " }}}
