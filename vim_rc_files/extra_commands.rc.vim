"===============================================================================
" Custom commands
"===============================================================================

" Display diff with the file.
command! -nargs=1 -complete=file Diff vertical diffsplit <args>
" Display diff from last save.
command! DiffOrig vert new | setlocal bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
" Disable diff mode.
command! -nargs=0 Undiff setlocal nodiff noscrollbind wrap

" Use F7/Shift-F7 to add/remove a breakpoint (pdb.set_trace)
function! SetPdbBreakpoint()
    let cur_line = line(".")
    let prev_register = @@
    echom prev_register
    normal! _y0
    call append(cur_line - 1, @@ . "vimpdb." . "set_trace()")
    let @@ = prev_register
    let first_line = getline(1)
    if first_line !=# "import vimpdb"
        call append(0, "import vimpdb")
    endif
endfunction

function! RemovePdbBreakpoints()
    let prev_register = @@
    let first_line = getline(1)
    if first_line ==# "import vimpdb"
        execute "1d"
    endif
    execute "%g/vimpdb\\.set_trace/d"
    let @@ = prev_register
endfunction

" Delete all non visible saved buffers
function! DeleteInactiveBufs()
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    "Below originally inspired by Hara Krishna Dara and Keith Roberts
    "http://tech.groups.yahoo.com/group/vim/message/56425
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction

function! GetProjectPath()  " {{{
    if $PROJECT_PATH != ''
        return $PROJECT_PATH
    endif
    if $VIRTUAL_ENV != ''
        return $VIRTUAL_ENV
    endif
    return denite#util#path2project_directory()
endfunction  " }}}

function! GetFileRecSource(type)  " {{{
    if a:type == 'buffer'
        let target = expand('%:p:h') . '/;'
    elseif a:type == 'project'
        let target = GetProjectPath() . '/;'
    else
        let target = ';'
    endif
    if finddir('.git', target) != ''
        return 'file_rec/git'
    else
        return 'file_rec'
    endif
endfunction  " }}}

function! MarkdownLevel()  " {{{
    " Set the fold levels based on headers.
    "
    " Created by Jeromy Anglim
    " (source: http://stackoverflow.com/questions/3828606/vim-markdown-folding)
    if getline(v:lnum) =~ '^[ */;"]*# .*$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^[ */;"]*## .*$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^[ */;"]*### .*$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^[ */;"]*#### .*$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^[ */;"]*##### .*$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^[ */;"]*###### .*$'
        return ">6"
    endif
    return "="
endfunction  " }}}
