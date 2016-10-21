" Plugins configuration

" Unite {{{
execute 'source ' . expand($VIM_FOLDER) . '/rc/plugins/unite.rc.vim'
" }}}

" Syntastic {{{
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
" }}}

" Indent Lines {{{
let g:indentLine_char = "│"
let g:indentLine_fileTypeExclude = ['help']
" }}}

" Airline {{{
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_mode_map = {'n': 'NOR', 'i': 'INS', 'R': 'REP', 't': 'TER',
    \ 'V': 'VIS'}
" }}}

" Nerd Commenter {{{
let g:NERDSpaceDelims = 1
" }}}

" Yarm {{{
let g:unite_yarm_access_key = 'set in vimrc.local'
let g:unite_yarm_limit = 1000
let g:unite_yarm_backup_dir = '~/tmp/yarm'
let g:unite_yarm_title_fields = [
    \ ['status', 9, 'KeyWord'],
    \ ['assigned_to', 21, 'StorageClass'],
    \ ['project', 16,  'Label'],
    \ ['fixed_version', 20, 'Statement']
    \ ]
" }}}

" Dockerfile {{{
autocmd BufRead,BufNewFile *.df set filetype=Dockerfile
" }}}

" VimFiler {{{
execute 'source ' . expand($VIM_FOLDER) . '/rc/plugins/vimfiler.rc.vim'
nnoremap <silent>   <leader>v   :<C-u>VimFiler -find<CR>
nnoremap <leader>ff :<C-u>VimFilerExplorer<CR>
" }}}

" Junkfile {{{
nnoremap <silent> [Window]e :<C-u>Unite junkfile/new junkfile -start-insert<CR>
" }}}

" Outline {{{
let g:unite_source_outline_indent_width = 4
" }}}

" Nice Blocks {{{
xmap I  <Plug>(niceblock-I)
xmap A  <Plug>(niceblock-A)
" }}}

" Accelerated jk {{{
nmap <silent>j <Plug>(accelerated_jk_gj)
nmap <silent>k <Plug>(accelerated_jk_gk)
" }}}

" Operator Replace {{{
xmap p <Plug>(operator-replace)
" }}}

" Operator surround {{{
nmap <silent>sa <Plug>(operator-surround-append)a
nmap <silent>sd <Plug>(operator-surround-delete)a
nmap <silent>sr <Plug>(operator-surround-replace)a
nmap <silent>sc <Plug>(operator-surround-replace)a
" }}}

" Easy Motion {{{
nmap w <Plug>(easymotion-lineforward)
nnoremap W     w
nmap b <Plug>(easymotion-linebackward)
nnoremap B     b
nmap <M-j> <Plug>(easymotion-j)
nmap <M-k> <Plug>(easymotion-k)
nmap <Leader>, <Plug>(easymotion-prefix)

let g:EasyMotion_startofline = 0
let g:EasyMotion_show_prompt = 0
let g:EasyMotion_verbose = 0
" }}}

" SmartChr {{{
execute 'source ' . expand($VIM_FOLDER) . '/rc/plugins/smartchr.rc.vim'
" }}}

" Jedi {{{
" Let deoplete actually work
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#show_call_signatures = 0
" }}}

" Nim {{{
let g:nvim_nim_enable_default_binds = 1
let g:nvim_nim_enable_custom_textobjects = 1
let g:nvim_nim_highlighter_enable = 1
let g:nvim_nim_highlighter_semantics = []
" }}}

" Deoplete {{{
let g:deoplete#enable_at_startup = 1
execute 'source ' . expand($VIM_FOLDER) . '/rc/plugins/deoplete.rc.vim'
" }}}

" Tryton {{{
let g:tryton_default_mappings = 1
let g:tryton_trytond_path = "$PROJECT_PATH/trytond"
let g:tryton_server_host_name = 'localhost'
let g:tryton_server_port = '7999'
let g:tryton_server_login = 'admin'
nmap <leader>com 0yf df oreview http://rietveld.coopengo.com/jkp$xXOjkgg0fFf:lyFFf:lldFFjojkkpxXXX
" }}}

" Deoplete ternjs {{{
let g:tern_request_timeout = 1
" }}}

" UltiSnips {{{
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" }}}
