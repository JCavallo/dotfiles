"===============================================================================
" Filetype settings
"===============================================================================

" All File Types {{{
autocmd MyAutoCmd FileType,Syntax * call s:my_on_filetype()
" Update filetype.
autocmd MyAutoCmd BufWritePost *
    \ if &l:filetype ==# '' || exists('b:ftdetect')
    \ |   unlet! b:ftdetect
    \ |   filetype detect
    \ | endif
autocmd MyAutoCmd Syntax * syntax sync minlines=100
" }}}

" Vim Script {{{
autocmd MyAutoCmd BufWritePost,FileWritePost .vimrc,vimrc,*.rc.vim
    \ NeoBundleClearCache | silent source $MYVIMRC
autocmd MyAutoCmd BufWritePost,FileWritePost *.vim
    \ if &autoread | source <afile> | echo 'source ' . bufname('%') | endif
autocmd MyAutoCmd FileType vim setlocal foldmethod=marker
autocmd MyAutoCmd Syntax vim call s:set_syntax_of_user_defined_commands()
let g:vimsyn_folding = 'afPl'
" }}}

" C {{{
autocmd MyAutoCmd FileType c setlocal omnifunc=ccomplete#Complete
" }}}

" CSS {{{
autocmd MyAutoCmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" }}}

" Html {{{
autocmd MyAutoCmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
autocmd MyAutoCmd FileType html
    \ setlocal includeexpr=substitute(v:fname,'^\\/','','') |
    \ setlocal path+=./;/
" }}}

" Markdown {{{
autocmd MyAutoCmd FileType markdown setlocal omnifunc=htmlcomplete#CompleteTags
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

" Python {{{
if has('python3')
    autocmd MyAutoCmd FileType python
        \ setlocal omnifunc=python3complete#Complete
else
    autocmd MyAutoCmd FileType python setlocal omnifunc=pythoncomplete#Complete
endif
autocmd MyAutoCmd FileType python setlocal foldmethod=syntax
let g:python_highlight_all = 1
" }}}

" SQL {{{
autocmd MyAutoCmd FileType sql setlocal omnifunc=sqlcomplete#Complete
" format sql, requires sqlparse installed in virtual env
autocmd MyAutoCmd FileType sql
    \ nnoremap <leader>xx :execute 'silent %w !sqlformat -r -o % %' \| execute ':e!'<CR>
" }}}

" XML {{{
autocmd MyAutoCmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd MyAutoCmd FileType xml setlocal foldmethod=syntax
autocmd MyAutoCmd FileType xml setlocal foldlevel=2
let g:xml_syntax_folding = 1
" }}}

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
    if !&l:modifiable
        setlocal nofoldenable
        setlocal foldcolumn=0
        setlocal colorcolumn=
    endif
endfunction "}}}
