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

if executable("rg")
    call denite#custom#var('grep', 'command', ['rg'])
    call denite#custom#var('grep', 'default_opts',
            \ ['--vimgrep', '--no-heading'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
    call denite#custom#var('file/rec', 'command',
        \ ['rg', '--files', '--glob', '!.git'])
elseif executable("ag")
    call denite#custom#var('grep', 'command', ['ag'])
    call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
    call denite#custom#var('file_rec', 'command',
        \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
endif

" Use git search in git repos
call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command',
    \ ['git', 'ls-files', '-co', '--exclude-standard'])
" }}}

" Ale {{{
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '✖'
let g:ale_sign_style_warning = '✖'
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_delay = 2000
let g:ale_fix_on_save = 1
autocmd ColorScheme *
    \ hi clear ALEErrorSign |
    \ hi ALEErrorSign cterm=bold ctermfg=196 ctermbg=235 |
    \ hi clear ALEWarningSign |
    \ hi ALEWarningSign cterm=bold ctermfg=226 ctermbg=235 |
    \ hi clear ALEInfoSign |
    \ hi ALEInfoSign cterm=bold ctermfg=45 ctermbg=235 |
    \ hi clear ALEStyleErrorSign |
    \ hi ALEStyleErrorSign cterm=bold ctermfg=45 ctermbg=235 |
    \ hi clear ALEStyleWarningSign |
    \ hi ALEStyleWarningSign cterm=bold ctermfg=45 ctermbg=235 |
    \ hi clear ALEErrorline |
    " \ hi ALEErrorline cterm=italic |
    \ hi clear ALEWarningLine |
    " \ hi ALEWarningLine cterm=italic |
    \ hi clear ALEInfoLine |
    " \ hi ALEInfoLine cterm=underline ctermfg=45
    \ hi clear ALEStyleErrorLine |
    \ hi clear ALEStyleWarningLine |
" }}}

" Neomake {{{
" autocmd MyAutoCmd BufWritePost,BufEnter * Neomake
" autocmd ColorScheme *
"     \ hi NeomakeErrorSign cterm=bold ctermfg=196 ctermbg=235 |
"     \ hi NeomakeWarningSign cterm=bold ctermfg=226 ctermbg=235 |
"     \ hi NeomakeMessageSign cterm=bold ctermfg=white ctermbg=235 |
"     \ hi NeomakeInfoSign cterm=bold ctermfg=45 ctermbg=235 |
"     \ hi NeomakeError cterm=underline ctermfg=196 |
"     \ hi NeomakeWarning cterm=underline ctermfg=226 |
"     \ hi NeomakeInfo cterm=underline ctermfg=45
" let g:neomake_po_maker = {
"     \ 'exe': 'msgfmt',
"     \ 'errorformat': '%W%f:%l: warning: %m,' .
"         \ '%E%f:%l:%v: %m,' .
"         \ '%E%f:%l: %m,' .
"         \ '%+C %.%#,' .
"         \ '%Z%p^,' .
"         \ '%-G%.%#'
"     \ }
" let g:neomake_po_enabled_makers = ['po']
" let g:neomake_python_enabled_makers = ['flake8']
" let g:neomake_javascript_enabled_makers = ['standard']
" let g:neomake_nim_enabled_makers = ['nim']
" let g:neomake_nim_nim_remove_invalid_entries = 1
" let g:quickfixsigns_protect_sign_rx = '^neomake_'
" let g:neomake_warning_sign = {
"     \   'text': '✖',
"     \   'texthl': 'NeomakeWarningSign',
"     \ }
" let g:neomake_tempfile_enabled = 0
" }}}

" Airline {{{
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_mode_map = {'n': 'NOR', 'i': 'INS', 'R': 'REP', 't': 'TER',
    \ 'V': 'VIS'}
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#ale#enabled = 1
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
let g:nvim_nim_highlighter_enable = 0
let g:nvim_nim_highlighter_async = 1
let g:nvim_nim_highlighter_semantics = []
" }}}

" Deoplete {{{
let g:deoplete#enable_at_startup = 1
execute 'source ' . expand($VIM_FOLDER) . '/rc/plugins/deoplete.rc.vim'
" }}}

" Local Vimrc {{{
let g:localvimrc_persistent=1
" }}}

" Tryton {{{
let g:tryton_default_mappings = 1
let g:tryton_trytond_path = "$PROJECT_PATH/trytond"
let g:tryton_server_host_name = 'localhost'
let g:tryton_server_port = '7999'
let g:tryton_server_login = 'admin'
" }}}

" Deoplete ternjs {{{
let g:tern_request_timeout = 1
let g:deoplete#sources#ternjs#tern_bin = "ternjs"
let g:deoplete#sources#ternjs#types = 1
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

" Polyglot {{{
let g:polyglot_disabled = ['nim']
" }}}
