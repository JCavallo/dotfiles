"---------------------------------------------------------------------------
" unite.vim
"---------------------------------------------------------------------------

" Global settings {{{
let g:unite_enable_auto_select = 0
let g:unite_source_history_yank_enable = 1
let g:unite_source_file_mru_limit = 1000
let g:unite_source_rec_max_cache_files = 10000
let g:unite_matcher_fuzzy_max_input_length = 50
let g:unite_ignore_source_files = ['function.vim', 'command.vim']
let default_context = {
    \ 'cursor_line_highlight': 'TabLineSel',
    \ 'enable_short_source_names': 0,
    \ 'start_insert': 1,
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

" Ignore wildignore
call unite#custom#source('file_rec',
    \ 'ignore_globs', split(&wildignore, ','))
call unite#custom#source('file_rec/async',
    \ 'ignore_globs', split(&wildignore, ','))

" Use fuzzy search for mercurial sources
call unite#custom#source(
    \ 'hg/status,hg/shelve', 'matchers',
    \ ['matcher_fuzzy'])
" }}}

" Set default actions {{{
call unite#custom#default_action('directory', 'rec/async')
call unite#custom#default_action('file', 'context_split')
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
    nmap <buffer> qq <Plug>(unite_exit)
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

" Custom split action
let s:my_split = {'is_selectable': 1}
function! s:my_split.func(candidate)
    let split_action = 'vsplit'
    if bufwinnr(a:candidate[0].word) != -1
        let split_action = 'switch'
    elseif bufname('#') == ''
        let split_action = 'open'
    elseif winwidth(winnr('#')) <= 1.5 * (&tw ? &tw : 80)
        echo winwidth(winnr('#'))
        let split_action = 'split'
    endif
    call unite#take_action(split_action, a:candidate)
endfunction
call unite#custom_action('openable', 'context_split', s:my_split)
unlet s:my_split

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

" Mappings {{{
nnoremap [unite] <Nop>
nmap <space> [unite]

" Quick sources
nnoremap <silent> [unite]a :<C-u>Unite -buffer-name=sources source<CR>
" Quick bookmarks
nnoremap <silent> [unite]b :<C-u>Unite -buffer-name=bookmarks bookmark<CR>
" Quick mark search
nnoremap <silent> [unite]e :<C-u>Unite -buffer-name=marks mark<CR>
" Quick file search
nnoremap <silent> [unite]f :<C-u>Unite -buffer-name=files -multi-line
    \ -unique -silent file_rec buffer_tab:- file/new<CR>
" Quick grep
nnoremap <silent> [unite]g :<C-u>Unite grep -buffer-name=grep`tabpagenr()`
    \ -no-split -no-empty -no-start-insert -resume -quit<CR>
" Quick grep (no resume)
nnoremap <silent> [unite]d :<C-u>Unite grep -buffer-name=grep`tabpagenr()`
    \ -no-split -no-empty -no-start-insert -quit<CR>
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
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register
    \ -default-action=append register history/yank<CR>
" Quick sessions
nnoremap <silent> [unite]s :<C-u>Unite -buffer-name=sessions session<CR>
" Quick tags
nnoremap <silent> [unite]t :<C-u>UniteWithCursorWord
    \ -buffer-name=tag tag<CR>
" Quick window switch
nnoremap <silent> [unite]w :<C-u>Unite window<CR>
" Quick my redmine issues
nnoremap <silent> [unite]xm :<C-u>Unite yarm:assigned=me
    \ -buffer-name=Redmine\ -\ Mine -multi-line<CR>
" Quick yank history
nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<CR>
" Quick mercurial status
nnoremap <silent> [unite]z :<C-u>Unite -buffer-name=status hg/status<CR>
" General Fuzzy search
nnoremap <silent> [unite]<Space>
    \ :<C-u>Unite -buffer-name=files -multi-line -unique -silent
    \ jump_point file_point buffer_tab:- file_mru
    \ file_rec/git file file_rec/async<CR>
" Quick commands
nnoremap <silent> [unite]; :<C-u>Unite -buffer-name=history
    \ history/command<CR>

" Jumps
nnoremap <silent> <C-k>
    \ :<C-u>Unite change jump<CR>

" <C-t>: Tab pages
nnoremap <silent><expr> <C-t>
    \ :<C-u>Unite -auto-resize -select=`(tabpagenr()-1)` tab<CR>"

" Execute help.
nnoremap <silent> <C-h> :<C-u>Unite -buffer-name=help help<CR>

" Execute help by cursor keyword.
nnoremap <silent> g<C-h> :<C-u>UniteWithCursorWord help<CR>

" Search.
nnoremap <silent> /
    \ :<C-u>Unite -buffer-name=search%`bufnr('%')`
    \ -auto-highlight -start-insert line:forward:wrap<CR>
nnoremap <silent> ?
    \ :<C-u>Unite -buffer-name=search%`bufnr('%')`
    \ -auto-highlight -start-insert line:backward<CR>
nnoremap <silent> *
    \ :<C-u>UniteWithCursorWord -buffer-name=search%`bufnr('%')`
    \ -auto-highlight line:forward:wrap<CR>
nnoremap [unite]/ /
nnoremap [unite]? ?
cnoremap <expr><silent><C-g>
    \ (getcmdtype() == '/') ?
    \ "\<ESC>:Unite -buffer-name=search line:forward:wrap -input="
    \ . getcmdline() . "\<CR>" : "\<C-g>"

nnoremap <silent><expr> n
    \ " :\<C-u>UniteResume search%" . bufnr('%') . " -no-start-insert\<CR>"
" }}}
