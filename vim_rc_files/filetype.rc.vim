"===============================================================================
" Filetype settings
"===============================================================================

" Enable smart indent.
set autoindent smartindent

augroup MyAutoCmd
    autocmd FileType,Syntax * call s:my_on_filetype()

    " Auto reload VimScript.
    autocmd BufWritePost,FileWritePost *.vim if &autoread
        \ | source <afile> | echo 'source ' . bufname('%') | endif

    " Enable omni completion.
    autocmd FileType c setlocal omnifunc=ccomplete#Complete
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
    autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
    if has('python3')
        autocmd FileType python setlocal omnifunc=python3complete#Complete
    else
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    endif
    "autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    "autocmd FileType sql setlocal omnifunc=sqlcomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType xml setlocal foldmethod=syntax
    autocmd FileType xml setlocal foldlevel=2

    autocmd FileType python setlocal foldmethod=syntax
    autocmd FileType vim setlocal foldmethod=marker

    " Update filetype.
    autocmd BufWritePost *
        \ if &l:filetype ==# '' || exists('b:ftdetect')
        \ |   unlet! b:ftdetect
        \ |   filetype detect
        \ | endif

    " Improved include pattern.
    autocmd FileType html
        \ setlocal includeexpr=substitute(v:fname,'^\\/','','') |
        \ setlocal path+=./;/
    autocmd FileType php setlocal path+=/usr/local/share/pear
    autocmd FileType apache setlocal path+=./;/

    autocmd Syntax * syntax sync minlines=100
augroup END

" PHP
let g:php_folding = 0

" Python
let g:python_highlight_all = 1

" XML
let g:xml_syntax_folding = 1

" Vim
let g:vimsyntax_noerror = 1
"let g:vim_indent_cont = 0

" Bash
let g:is_bash = 1

" Java
let g:java_highlight_functions = 'style'
let g:java_highlight_all=1
let g:java_highlight_debug=1
let g:java_allow_cpp_keywords=1
let g:java_space_errors=1
let g:java_highlight_functions=1

" JavaScript
let g:SimpleJsIndenter_BriefMode = 1
let g:SimpleJsIndenter_CaseIndentLevel = -1

" Go
if $GOROOT != ''
    set runtimepath+=$GOROOT/misc/vim
endif

" Vim script
" augroup: a
" function: f
" lua: l
" perl: p
" ruby: r
" python: P
" tcl: t
" mzscheme: m
let g:vimsyn_folding = 'afPl'

" http://mattn.kaoriya.net/software/vim/20140523124903.htm
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

" Syntax highlight for user commands.
augroup syntax-highlight-extends
    autocmd!
    autocmd Syntax vim call s:set_syntax_of_user_defined_commands()
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
        setlocal nofoldenable
        setlocal foldcolumn=0
        setlocal colorcolumn=
    endif
endfunction "}}}

" Do not display completion messages
" Patch: https://groups.google.com/forum/#!topic/vim_dev/WeBBjkXE8H8
set noshowmode
try
    set shortmess+=c
catch /^Vim\%((\a\+)\)\=:E539: Illegal character/
    autocmd MyAutoCmd VimEnter *
        \ highlight ModeMsg guifg=bg guibg=bg |
        \ highlight Question guifg=bg guibg=bg
endtry
