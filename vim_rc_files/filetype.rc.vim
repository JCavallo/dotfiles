" Filetype configuration

" Bash {{{
autocmd MyAutoCmd BufEnter /tmp/bash* setlocal filetype=sh
autocmd MyAutoCmd Filetype sh setlocal foldmethod=indent foldlevel=0
autocmd MyAutoCmd Filetype sh setlocal tabstop=4 softtabstop=4 shiftwidth=4
let g:is_bash = 1
let g:sh_fold_enabled= 3
" }}}

" C {{{
autocmd MyAutoCmd Filetype c setlocal omnifunc=
" }}}

" Html {{{
autocmd MyAutoCmd Filetype html setlocal omnifunc=htmlcomplete#CompleteTags
autocmd MyAutoCmd Filetype html setlocal includeexpr=substitute(v:fname,'^\\/','','')
autocmd MyAutoCmd Filetype html setlocal path+=./;/
autocmd MyAutoCmd Filetype html setlocal tabstop=2 softtabstop=2 shiftwidth=2
" }}}

" Javascript {{
let g:SimpleJsIndenter_BriefMode = 1
let g:SimpleJsIndenter_CaseIndentLevel = -1
autocmd MyAutoCmd Filetype javascript setlocal softtabstop=2 shiftwidth=2
autocmd MyAutoCmd Filetype javascript setlocal tabstop=2 foldmethod=indent
" }}}

" Markdown {{{
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
autocmd MyAutoCmd Filetype markdown setlocal omnifunc=htmlcomplete#CompleteTags
" }}}

" Nim {{{
autocmd MyAutoCmd Filetype nim setlocal foldmethod=indent
autocmd MyAutoCmd Filetype nim setlocal tabstop=2 softtabstop=2 shiftwidth=2
" }}}

" Python {{{
let g:python_highlight_all = 1
autocmd MyAutoCmd Filetype python setlocal foldmethod=indent
if has('python3')
    autocmd MyAutoCmd Filetype python setlocal omnifunc=python3complete#Complete
else
    autocmd MyAutoCmd Filetype python setlocal omnifunc=pythoncomplete#Complete
endif
" }}}

" Pug {{{
autocmd MyAutoCmd FileType pug setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd MyAutoCmd FileType pug setlocal foldmethod=indent
" }}}

" Rust {{{
autocmd MyAutoCmd Filetype rust setlocal foldmethod=indent
" }}}

" SQL {{{
autocmd MyAutoCmd Filetype sql setlocal omnifunc=sqlcomplete#Complete
autocmd MyAutoCmd Filetype sql
    \ nnoremap <leader>xx :execute 'silent %w !sqlformat -r -k upper -i lower -o % %' \| execute ':e!'<CR>
" }}}

" Tryton {{{
autocmd MyAutoCmd Filetype trpy setlocal syntax=python.trpy
autocmd MyAutoCmd Filetype trpy setlocal foldmethod=syntax
" }}}

" Vim {{{
let g:vimsyntax_noerror = 1
let g:vim_indent_cont = 4
let g:vimsyn_folding = 'afPl'
autocmd MyAutoCmd Filetype vim setlocal foldmethod=marker
autocmd MyAutoCmd Filetype vim setlocal nomodeline
" }}}

" Vimrc {{{
autocmd MyAutoCmd BufWritePost .vimrc,vimrc,*.rc.vim,*.toml source $MYVIMRC | redraw
" }}}
"
" XML {{{
let g:xml_syntax_folding = 1
autocmd MyAutoCmd Filetype html setlocal omnifunc=htmlcomplete#CompleteTags
autocmd MyAutoCmd Filetype xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd MyAutoCmd Filetype xml setlocal foldmethod=syntax
autocmd MyAutoCmd Filetype xml setlocal foldlevel=2
" }}}
