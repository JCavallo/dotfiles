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
    let g:syntastic_python_flake8_post_args='--ignore=E123,E124,E126,E127,E128,E711,W404,F403,W503'
    let g:syntastic_python_pylint_post_args='--disable=E1101,W0613,C0111'
    let g:syntastic_python_checkers=['flake8']
    let g:syntastic_javascript_checkers=['jshint']
    let g:syntastic_xml_checkers=['xmllint']
    call neobundle#untap()
endif "}}}

if neobundle#tap('indentLine') "{{{
    " let g:indentLine_faster = 1
    let g:indentLine_char = "│"
    let g:indentLine_fileTypeExclude = ['xml', 'help']
    nmap <silent><Leader>i :<C-u>IndentLinesToggle<CR>
    call neobundle#untap()
endif "}}}

if neobundle#tap('vim-niceblock') "{{{
    xmap I  <Plug>(niceblock-I)
    xmap A  <Plug>(niceblock-A)
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
    " call unite#custom_source('quickfix', 'converters',
    "     \ 'converter_quickfix_highlight')
    " call unite#custom_source('location_list', 'converters',
    "     \ 'converter_quickfix_highlight')
    " call neobundle#untap()
endif "}}}

if neobundle#tap('ultisnips') "{{{
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
    call neobundle#untap()
endif "}}}

if neobundle#tap('neocomplete.vim') && has('lua') && !has('nvim') "{{{
    let g:neocomplete#enable_at_startup = 1
    let neobundle#hooks.on_source = expand(
        \ $VIM_FOLDER . '/rc/plugins/neocomplete.rc.vim')
    call neobundle#untap()
endif "}}}

if neobundle#tap('deoplete.nvim') && has('nvim') && has('python3') "{{{
    let g:deoplete#enable_at_startup = 1
    let neobundle#hooks.on_source = expand(
        \ $VIM_FOLDER . '/rc/plugins/deoplete.rc.vim')

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-airline') "{{{
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#fnamemod = ':t'
    let g:airline_mode_map = {'n': 'NOR', 'i': 'INS', 'R': 'REP'}

    if has('nvim')
        " Manager teminal mode
        let g:airline_mode_map.t = 'TER'
    endif

    call neobundle#untap()
endif "}}}

" if neobundle#tap('unite-sudo') "{{{
"     call neobundle#untap()
" endif "}}}

" if neobundle#tap('gundo.vim') "{{{
"     call neobundle#untap()
" endif "}}}

if neobundle#tap('vimfiler.vim') "{{{
    nnoremap <silent>   <leader>v   :<C-u>VimFiler -find<CR>
    nnoremap <leader>ff :<C-u>VimFilerExplorer<CR>
    let neobundle#hooks.on_source = expand(
        \ $VIM_FOLDER . '/rc/plugins/vimfiler.rc.vim')
    call neobundle#untap()
endif "}}}

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

if neobundle#tap('vim-expand-region') "{{{
    xmap v <Plug>(expand_region_expand)
    xmap <C-v> <Plug>(expand_region_shrink)

    call neobundle#untap()
endif "}}}

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

if neobundle#tap('nimrod.vim') "{{{
    function! JumpToDef()
        if exists("*GotoDefinition_" . &filetype)
            call GotoDefinition_{&filetype}()
        else
            execute "norm! \<C-]>"
        endif
    endf

    " Jump to tag
    nnoremap <M-g> :call JumpToDef()<cr>
    inoremap <M-g> <esc>:call JumpToDef()<cr>i
    call neobundle#untap()
endif "}}}

if neobundle#tap('tryton-vim') "{{{
    let g:tryton_default_mappings = 1
    let g:tryton_trytond_path = "$VIRTUAL_ENV/tryton-workspace/trytond"
    let g:tryton_server_host_name = 'localhost'
    let g:tryton_server_port = '8080'
    let g:tryton_server_login = 'admin'
    nmap <leader>com 0yf df oreview http://rietveld.coopengo.com/jkp$xXOjkgg0fFf:lyFFf:lldFFjojkkpxXXX
    call neobundle#untap()
endif "}}}

if neobundle#tap('vim-smartchr') "{{{
    let neobundle#hooks.on_source = expand(
        \ $VIM_FOLDER . '/rc/plugins/smartchr.rc.vim')
    call neobundle#untap()
endif "}}}

if neobundle#tap('nerdcommenter') "{{{
    let g:NERDSpaceDelims=1
    call neobundle#untap()
endif "}}}
