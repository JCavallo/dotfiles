" Plugins configuration

" Denite {{{
call denite#custom#map('insert', '<C-j>',
    \ '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>',
    \ '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', 'jk',
    \ '<denite:enter_mode:normal>', 'noremap')
call denite#custom#map('insert', 'kj',
    \ '<denite:enter_mode:normal>', 'noremap')
call denite#custom#map('normal', 'l',
    \ '<denite:do_action:default>', 'noremap')
call denite#custom#map('normal', 'h',
    \ '<denite:do_action:walk_up>', 'noremap')
call denite#custom#map('normal', '<C-a>v',
    \ '<denite:do_action:vsplit>', 'noremap')
call denite#custom#map('normal', '<C-a>s',
    \ '<denite:do_action:split>', 'noremap')
call denite#custom#map('insert', '<C-a>v',
    \ '<denite:do_action:vsplit>', 'noremap')
call denite#custom#map('insert', '<C-a>s',
    \ '<denite:do_action:split>', 'noremap')

" Use 'ag' for grep searches
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

call denite#custom#var('file_rec', 'command',
    \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

" Use git search in git repos
call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command',
    \ ['git', 'ls-files', '-co', '--exclude-standard'])
" }}}

" Neomake {{{
let g:neomake_po_maker = {
    \ 'exe': 'msgfmt',
    \ 'errorformat': '%W%f:%l: warning: %m,' .
        \ '%E%f:%l:%v: %m,' .
        \ '%E%f:%l: %m,' .
        \ '%+C %.%#,' .
        \ '%Z%p^,' .
        \ '%-G%.%#'
    \ }
let g:neomake_po_enabled_makers = ['po']
let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_javascript_enabled_makers = ['standard']
let g:neomake_nim_enabled_makers = ['nim']
let g:neomake_nim_nim_remove_invalid_entries = 1
let g:quickfixsigns_protect_sign_rx = '^neomake_'
let g:neomake_warning_sign = {
    \   'text': '✖',
    \   'texthl': 'NeomakeWarningSign',
    \ }
let g:neomake_tempfile_enabled = 0
" }}}

" Airline {{{
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_mode_map = {'n': 'NOR', 'i': 'INS', 'R': 'REP', 't': 'TER',
    \ 'V': 'VIS'}
let g:airline#extensions#whitespace#enabled = 0
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

" Tpl files {{{
autocmd BufRead,BufNewFile *.tpl set filetype=html
" }}}

" Tmux mappings {{{
let g:tmux_navigator_no_mappings = 1
" }}}

" VimFiler {{{
execute 'source ' . expand($VIM_FOLDER) . '/rc/plugins/vimfiler.rc.vim'
" }}}

" Outline {{{
let g:unite_source_outline_indent_width = 4
" }}}

" Easy Motion {{{
let g:EasyMotion_startofline = 0
let g:EasyMotion_show_prompt = 0
let g:EasyMotion_verbose = 0
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

" Rainbow Parentheses {{{
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
" }}}

" Echodoc {{{
let g:echodoc#enable_at_startup = 1
" }}}
