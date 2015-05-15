"---------------------------------------------------------------------------
" Plugin:
"---------------------------------------------------------------------------

" if neobundle#tap('neobundle.vim') " {{{
"     call neobundle#untap()
" endif " }}}

" if neobundle#tap('vimproc.vim') " {{{
"     call neobundle#untap()
" endif " }}}

if neobundle#tap('syntastic') "{{{
    let g:syntastic_enable_balloons = 0
    let g:syntastic_check_on_open = 1
    let g:syntastic_enable_signs = 1
    let g:syntastic_auto_jump = 0
    let g:syntastic_enable_highlighting = 1
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 0
    let g:syntastic_error_symbol='✗'
    let g:syntastic_style_error_symbol='▶'
    let g:syntastic_warning_symbol='✗'
    let g:syntastic_style_warning_symbol='▶'
    let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
    let g:syntastic_mode_map = { 'mode': 'active',
        \ 'active_filetypes': ['python'],
        \ 'passive_filetypes': [] }
    let g:syntastic_python_flake8_post_args='--ignore=E123,E124,E126,E128,E711,W404,F403,W503'
    let g:syntastic_python_pylint_post_args='--disable=E1101,W0613,C0111'
    let g:syntastic_python_checkers=['flake8', 'pyflakes']
    call neobundle#untap()
endif "}}}

if neobundle#tap('indentLine') "{{{
    let g:indentLine_char = "│"
    let g:indentLine_fileTypeExclude = ['xml', 'help']
    call neobundle#untap()
endif "}}}

if neobundle#tap('vim-niceblock') "{{{
    xmap I  <Plug>(niceblock-I)
    xmap A  <Plug>(niceblock-A)
    call neobundle#untap()
endif "}}}

if neobundle#tap('unite.vim') "{{{
    nnoremap [unite] <Nop>
    nmap <space> [unite]

    " Quick sources
    nnoremap <silent> [unite]a :<C-u>Unite -buffer-name=sources source<CR>
    " Quick bookmarks
    nnoremap <silent> [unite]b :<C-u>Unite -buffer-name=bookmarks bookmark<CR>
    " Quick mark search
    nnoremap <silent> [unite]e :<C-u>Unite -buffer-name=marks mark<CR>
    " Quick file search
    nnoremap <silent> [unite]f :<C-u>Unite -buffer-name=files file_rec/async
        \ file/new<CR>
    " Quick grep
    nnoremap <silent> [unite]g :<C-u>Unite grep -buffer-name=grep
        \ -no-start-insert<CR>
    " Quick help
    nnoremap <silent> [unite]h :<C-u>Unite -buffer-name=help help<CR>
    " Quick buffer
    nnoremap <silent> [unite]i :<C-u>Unite -buffer-name=buffer buffer<CR>
    " Previous changes navigation
    nnoremap <silent> [unite]k :<C-u>Unite change jump<CR>
    " Location List
    nnoremap <silent> [unite]l :<C-u>Unite -auto-highlight -wrap
        \ -buffer-name=location_list location_list<CR>
    " Next
    nnoremap <silent> [unite]n :UniteNext<CR>
    " Quick outline
    nnoremap <silent> [unite]o :<C-u>Unite outline -start-insert -resume<CR>
    " Previous
    nnoremap <silent> [unite]p :UnitePrevious<CR>
    " Quickfix window
    nnoremap <silent> [unite]q :<C-u>Unite -auto-highlight -wrap -no-quit
        \ -buffer-name=quickfix quickfix<CR>
    " Quick registers
    nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register
        \ history/yank<CR>
    " Quick sessions
    nnoremap <silent> [unite]s :<C-u>Unite -buffer-name=sessions session<CR>
    " Quick tags
    nnoremap <silent> [unite]t :<C-u>UniteWithCursorWord -buffer-name=tag tag<CR>
    " Quick window switch
    nnoremap <silent> [unite]w :<C-u>Unite window<CR>
    " Quick yank history
    nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<CR>
    " General Fuzzy search
    nnoremap <silent> [unite]<Space>
        \ :<C-u>Unite -buffer-name=files -multi-line -unique -silent
        \ jump_point file_point buffer_tab:- file_mru
        \ file_rec/git file file_rec/async<CR>
    " Quick commands
    nnoremap <silent> [unite]; :<C-u>Unite -buffer-name=history
        \ history/command<CR>

    " <C-t>: Tab pages
    nnoremap <silent><expr> <C-t>
        \ " :\<C-u>Unite -auto-resize -select=".(tabpagenr()-1)." tab\<CR>"

    " Execute help.
    nnoremap <silent> <C-h> :<C-u>Unite -buffer-name=help help<CR>

    " Execute help by cursor keyword.
    nnoremap <silent> g<C-h> :<C-u>UniteWithCursorWord help<CR>

    " Search.
    nnoremap <silent><expr> /
        \ " :\<C-u>Unite -buffer-name=search%" . bufnr('%')
        \ . " -auto-highlight -start-insert line:forward:wrap\<CR>"
    nnoremap <silent><expr> ?
        \ " :\<C-u>Unite -buffer-name=search%" . bufnr('%')
        \ . " -auto-highlight -start-insert line:backward\<CR>"
    nnoremap <silent><expr> *
        \ " :\<C-u>UniteWithCursorWord -buffer-name=search%" . bufnr('%')
        \ . " -auto-highlight line:forward:wrap\<CR>"
    nnoremap [unite]/ /
    nnoremap [unite]? ?
    cnoremap <expr><silent><C-g>
        \ (getcmdtype() == '/') ?
        \ "\<ESC>:Unite -buffer-name=search line:forward:wrap -input="
        \ . getcmdline() . "\<CR>" : "\<C-g>"

    nnoremap <silent><expr> n
        \ " :\<C-u>UniteResume search%" . bufnr('%') . " -no-start-insert\<CR>"

    let neobundle#hooks.on_source = '~/.vim/rc/plugins/unite.rc.vim'
    call neobundle#untap()
endif "}}}

if neobundle#tap('unite-session') "{{{
    let g:unite_source_session_enable_auto_save = 1
    call neobundle#untap()
endif "}}}

" if neobundle#tap('neomru.vim') "{{{
"     call neobundle#untap()
" endif "}}}

if neobundle#tap('unite-outline') "{{{
    let g:unite_source_outline_indent_width = 4
    call neobundle#untap()
endif "}}}

" if neobundle#tap('unite-help') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('unite-mark') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('vim-unite-history') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('unite-tag') "{{{
"     call neobundle#untap()
" endif "}}}

if neobundle#tap('unite-quickfix') "{{{
    let g:unite_quickfix_is_multiline = 0
    call unite#custom_source('quickfix', 'converters',
        \ 'converter_quickfix_highlight')
    call unite#custom_source('location_list', 'converters',
        \ 'converter_quickfix_highlight')
    call neobundle#untap()
endif "}}}

" if neobundle#tap('unite-filetype') "{{{
"     call neobundle#untap()
" endif "}}}

if neobundle#tap('ultisnips') "{{{
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
    call neobundle#untap()
endif "}}}

if neobundle#tap('neocomplete.vim') "{{{
    let g:neocomplete#enable_at_startup = 1
    let neobundle#hooks.on_source = '~/.vim/rc/plugins/neocomplete.rc.vim'
    call neobundle#untap()
endif "}}}

if neobundle#tap('neosnippet.vim') "{{{
    let neobundle#hooks.on_source = '~/.vim/rc/plugins/neosnippet.rc.vim'
    call neobundle#untap()
endif "}}}

if neobundle#tap('vim-airline') "{{{
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#fnamemod = ':t'
    let g:airline_mode_map = {'n': 'NOR', 'i': 'INS', 'R': 'REP'}

    " if !exists('g:airline_symbols')
    "     let g:airline_symbols = {}
    " endif

    " " unicode symbols
    " let g:airline_left_sep = '»'
    " let g:airline_left_sep = '▶'
    " let g:airline_right_sep = '«'
    " let g:airline_right_sep = '◀'
    " let g:airline_symbols.linenr = '␊'
    " let g:airline_symbols.linenr = '␤'
    " let g:airline_symbols.linenr = '¶'
    " let g:airline_symbols.branch = '⎇'
    " let g:airline_symbols.paste = 'ρ'
    " let g:airline_symbols.paste = 'Þ'
    " let g:airline_symbols.paste = '∥'
    " let g:airline_symbols.whitespace = 'Ξ'
    call neobundle#untap()
endif "}}}

" if neobundle#tap('neossh.vim') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('unite-sudo') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('gundo.vim') "{{{
"     call neobundle#untap()
" endif "}}}

if neobundle#tap('vimfiler.vim') "{{{
    nnoremap <silent>   <leader>v   :<C-u>VimFiler -find<CR>
    nnoremap [Space]ff :<C-u>VimFilerExplorer<CR>
    let neobundle#hooks.on_source = '~/.vim/rc/plugins/vimfiler.rc.vim'
    call neobundle#untap()
endif "}}}

if neobundle#tap('vimshell.vim') "{{{
    nmap <C-@> <Plug>(vimshell_switch)
    let neobundle#hooks.on_source = '~/.vim/rc/plugins/vimshell.rc.vim'
    call neobundle#untap()
endif "}}}

" if neobundle#tap('vimshell-ssh') "{{{
"     call neobundle#untap()
" endif "}}}

if neobundle#tap('accelerated-jk') "{{{
    nmap <silent>j <Plug>(accelerated_jk_gj)
    nmap gj j
    nmap <silent>k <Plug>(accelerated_jk_gk)
    nmap gk k
    call neobundle#untap()
endif "}}}

" if neobundle#tap('vim-hg-unite') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('csapprox') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('vim-guicolorscheme') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('flashy-vim') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('vim-easymotion') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('vim-surround') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('vim-repeat') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('vim-expand-region') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('vim-json') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('vim-diff-fold') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('simple-javascript-indenter') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('vim-python-pep8-indent') "{{{
"     call neobundle#untap()
" endif "}}}

if neobundle#tap('tryton-vim') "{{{
    let g:tryton_default_mappings = 1
    let g:tryton_trytond_path = "$VIRTUAL_ENV/tryton-workspace/trytond"
    let g:tryton_server_host_name = 'localhost'
    let g:tryton_server_port = '8080'
    let g:tryton_server_login = 'admin'
    nmap <leader>com 0yf df oreview http://rietveld.coopengo.com/jkp$xXOjkgg0fFf:lyFFf:lldFFjojkkpxXXX
    call neobundle#untap()
endif "}}}

if neobundle#tap('riv.vim') "{{{
    let g:riv_i_tab_pum_next = 0
    let g:riv_i_tab_user_cmd = ''
    let g:riv_ignored_imaps = "<Tab>,<S-Tab>"
    let g:riv_ignored_nmaps = "<Tab>,<S-Tab>"
    let g:riv_ignored_vmaps = "<Tab>,<S-Tab>"
    call neobundle#untap()
endif "}}}

if neobundle#tap('InstantRst') "{{{
    let g:instant_rst_browser = 'chrome'
    call neobundle#untap()
endif "}}}

if neobundle#tap('vim-smartchr') "{{{
    let g:neocomplete#enable_at_startup = 1
    let neobundle#hooks.on_source =
        \ '~/.vim/rc/plugins/smartchr.rc.vim'
    call neobundle#untap()
endif "}}}

if neobundle#tap('nerdcommenter') "{{{
    let g:NERDSpaceDelims=1
    call neobundle#untap()
endif "}}}
