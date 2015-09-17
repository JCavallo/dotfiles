"---------------------------------------------------------------------------
" unite.vim
"---------------------------------------------------------------------------

" Global settings {{{
let g:unite_source_history_yank_enable = 1
let g:unite_source_file_mru_limit = 1000
let g:unite_source_rec_max_cache_files = 10000
let g:unite_matcher_fuzzy_max_input_length = 50
let g:unite_ignore_source_files = ['function.vim', 'command.vim']
let g:unite_enable_start_insert = 1
let default_context = {
    \ 'cursor_line_highlight': 'TabLineSel',
    \ 'enable_short_source_names': 1,
    \ 'marked_icon': '✗',
    \ 'prompt': '» ',
    \ 'vertical': 0,
    \ }
call unite#custom#profile('default', 'context', default_context)
" }}}

" Unite aliases {{{
let g:unite_source_alias_aliases = {}
let g:unite_source_alias_aliases.message = {
    \ 'source' : 'output',
    \ 'args'   : 'message',
    \ }
let g:unite_source_alias_aliases.scriptnames = {
    \ 'source' : 'output',
    \ 'args'   : 'scriptnames',
    \ }
" }}}

" Set default options {{{
call unite#custom#profile('action', 'context', {
    \     'start_insert' : 1
    \ })
call unite#custom#profile('source/grep', 'context', {
    \     'no_quit' : 1
    \ })
" }}}

" Set default filters {{{
call unite#custom#source(
    \ 'buffer,file_rec,file_rec/async,file_rec/git,rec/async', 'matchers',
    \ ['converter_relative_word', 'matcher_fuzzy'])
call unite#custom#source(
    \ 'file_mru', 'matchers',
    \ ['matcher_project_files', 'matcher_fuzzy'])
call unite#custom#source(
    \ 'file_rec,file_rec/async,file_rec/git,file_mru,rec/async', 'converters',
    \ ['converter_file_directory'])
call unite#filters#sorter_default#use(['sorter_selecta'])
" }}}

" Set default actions {{{
call unite#custom#default_action('directory', 'rec/async')
" }}}

" Custom settings for unite windows {{{
autocmd MyAutoCmd FileType unite call s:unite_my_settings()

function! s:unite_my_settings()
    " Overwrite settings.
    imap <buffer> <BS> <Plug>(unite_delete_backward_path)
    imap <buffer> jk <Plug>(unite_insert_leave)
    imap <buffer> kj <Plug>(unite_insert_leave)
    imap <buffer> <Tab> <Plug>(unite_complete)
    imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
    imap <buffer> jj <Plug>(unite_insert_leave)
    imap <buffer> qq <Plug>(unite_exit)
    imap <buffer> <C-z> <Plug>(unite_toggle_transpose_window)
    nmap <buffer> ' <Plug>(unite_quick_match_default_action)
    nmap <buffer> cd <Plug>(unite_quick_match_default_action)
    nmap <buffer> <C-r> <Plug>(unite_redraw)
    imap <buffer> <C-r> <Plug>(unite_redraw)
    nmap <buffer> <C-z> <Plug>(unite_toggle_transpose_window)
    nmap <buffer> <C-j> <Plug>(unite_toggle_auto_preview)
    nmap <buffer> h <Plug>(unite_exit)
    nnoremap <silent><buffer> <Tab> <C-w>w
    nnoremap <silent><buffer><expr> l
        \ unite#smart_map('l', unite#do_action('default'))

    let unite = unite#get_current_unite()
    if unite.profile_name ==# '^search'
        nnoremap <silent><buffer><expr> r unite#do_action('replace')
    else
        nnoremap <silent><buffer><expr> r unite#do_action('rename')
    endif

    nnoremap <silent><buffer><expr> cd unite#do_action('lcd')
    nnoremap <silent><buffer><expr> x unite#do_action('start')
    nnoremap <buffer><expr> S unite#mappings#set_current_filters(
        \ empty(unite#mappings#get_current_filters()) ? ['sorter_reverse'] : [])
endfunction
" }}}

" Set search sources executables {{{
if executable('ag')
    " Use ag in unite grep source.
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts =
        \ '-i --vimgrep --hidden --ignore ' .
        \ '''.pyc'' --ignore ''.orig'' --ignore '.
        \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
    let g:unite_source_grep_recursive_opt = ''
    " Using ag as recursive command.
    " let g:unite_source_rec_async_command =
    "     \ 'ag --follow --nocolor --nogroup --hidden -g ""'
elseif executable('ack-grep')
    " For ack.
    let g:unite_source_grep_command = 'ack-grep'
    let g:unite_source_grep_default_opts = '--no-heading --no-color -a'
    let g:unite_source_grep_recursive_opt = ''
endif
" }}}
