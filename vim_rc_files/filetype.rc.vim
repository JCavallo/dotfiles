"===============================================================================
" Filetype settings
"===============================================================================

augroup MyAutoCmd
    " All File Types {{{
    autocmd FileType,Syntax,BufEnter,BufWinEnter * call s:my_on_filetype()
    " Update filetype.
    autocmd BufWritePost *
        \ if &l:filetype ==# '' || exists('b:ftdetect')
        \ |   unlet! b:ftdetect
        \ |   filetype detect
        \ | endif
    " }}}

    " Vim Script {{{
    autocmd BufWritePost,FileWritePost .vimrc,vimrc,*.rc.vim
        \ NeoBundleClearCache | silent source $MYVIMRC
    autocmd BufWritePost,FileWritePost *.vim
        \ if &autoread | source <afile> | echo 'source ' . bufname('%') | endif
    autocmd FileType vim setlocal foldmethod=marker
    autocmd Syntax vim call s:set_syntax_of_user_defined_commands()
    let g:vimsyn_folding = 'afPl'
    " }}}

    " Bash {{{
    autocmd BufEnter /tmp/bash* setlocal filetype=sh
    autocmd FileType sh setlocal foldmethod=indent foldlevel=0
    autocmd FileType sh setlocal tabstop=4 softtabstop=4 shiftwidth=4
    " }}}

    " C {{{
    autocmd FileType c setlocal omnifunc=
    " }}}

    " CSS {{{
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    " }}}

    " Javascript {{{
    autocmd FileType javascript setlocal softtabstop=2 shiftwidth=2
    autocmd FileType javascript setlocal tabstop=2 foldmethod=indent
    " }}}

    " Html {{{
    autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType html
        \ setlocal includeexpr=substitute(v:fname,'^\\/','','') |
        \ setlocal path+=./;/
    " }}}

    " Markdown {{{
    autocmd FileType markdown setlocal omnifunc=htmlcomplete#CompleteTags
    let g:markdown_fenced_languages = [
        \  'coffee',
        \  'css',
        \  'erb=eruby',
        \  'javascript',
        \  'js=javascript',
        \  'json=javascript',
        \  'ruby',
        \  'sass',
        \  'xml',
        \  'vim',
        \]
    " }}}

    " Nim {{{
    autocmd FileType nim setlocal foldmethod=indent
    autocmd FileType nim setlocal tabstop=2 softtabstop=2 shiftwidth=2
    " }}}

    " Python {{{
    if has('python3')
        autocmd FileType python
            \ setlocal omnifunc=python3complete#Complete
    else
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    endif
    autocmd FileType python setlocal foldmethod=syntax
    let g:python_highlight_all = 1
    " }}}

    " TrPy {{{
    autocmd BufWinEnter trpy setlocal syntax=python.trpy
    " }}}

    " SQL {{{
    autocmd FileType sql setlocal omnifunc=sqlcomplete#Complete
    " format sql, requires sqlparse installed in virtual env
    autocmd FileType sql
        \ nnoremap <leader>xx :execute 'silent %w !sqlformat -r -k upper -i lower -o % %' \| execute ':e!'<CR>
    " }}}

    " XML {{{
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType xml setlocal foldmethod=syntax
    autocmd FileType xml setlocal foldlevel=2
    let g:xml_syntax_folding = 1
    " }}}
augroup END

function! s:set_syntax_of_user_defined_commands() "{{{
    redir => _
    silent! command
    redir END

    let command_names = join(map(split(_, '\n')[1:],
        \ "matchstr(v:val, '[!\"b]*\\s\\+\\zs\\u\\w*\\ze')"))

    if command_names == '' | return | endif
    execute 'syntax keyword vimCommand ' . command_names
endfunction"}}}

function! s:my_on_filetype() "{{{
    " Use CustomFoldText().
    if &filetype !=# 'help'
        setlocal foldtext=CustomFoldText()
    endif

    if !&l:modifiable
        setlocal colorcolumn=
    endif
endfunction "}}}
